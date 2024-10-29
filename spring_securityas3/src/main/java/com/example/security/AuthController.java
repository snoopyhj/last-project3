package com.example.security;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Random;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.example.security.vo.AuthRequest;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@ControllerAdvice 
@RestController
@RequestMapping("/")
public class AuthController {

    private final AuthenticationManager authenticationManager;
    private final CustomUserDetailsService userDetailsService;
    private final JwtUtil jwtUtil;
    private final KakaoOAuth2Service kakaoOAuth2Service;
    private String generatedCode; // 인증 번호를 저장할 변수
    private static final Logger log = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    public AuthController(AuthenticationManager authenticationManager,
                          CustomUserDetailsService userDetailsService,
                          JwtUtil jwtUtil,
                          KakaoOAuth2Service kakaoOAuth2Service) {
        this.authenticationManager = authenticationManager;
        this.userDetailsService = userDetailsService;
        this.jwtUtil = jwtUtil;
        this.kakaoOAuth2Service = kakaoOAuth2Service;
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody AuthRequest request) {
        System.out.println("로그인 요청을 받았습니다. 사용자: " + request.getUsername());

        try {
            // 인증 시도
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword()));

            // 사용자 정보를 가져옵니다.
            final UserDetails user = userDetailsService.loadUserByUsername(request.getUsername());
            
            if (user == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new ErrorResponse("사용자를 찾을 수 없습니다."));
            }

            // JWT 토큰 생성 후 반환
            return ResponseEntity.ok(new TokenResponse(jwtUtil.generateToken(user)));
        } catch (AuthenticationException e) {
            // 인증 실패 처리
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new ErrorResponse("아이디 또는 비밀번호가 잘못되었습니다."));
        } catch (Exception e) {
            // 기타 예외 처리
            e.printStackTrace(); // 예외 스택 트레이스를 출력
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(new ErrorResponse("서버 오류가 발생했습니다."));
        }
    }

    // 추가된 JWT 토큰 유효성 검증 API
    @GetMapping("/validate-token")
    public ResponseEntity<?> validateToken(@RequestParam String token) {
    	UserDetails userDetails =null;
        log.debug("Received token for validation: {}", token);  // 디버깅 로그 추가
        
        try {
            // 토큰에서 사용자 이름 추출
            String username = jwtUtil.extractUsername(token);
            if(username==null) {
            	username = jwtUtil.extractKakaoId(token);
            }
            log.debug("Extracted username: {}", username);
            System.out.println("Extracted username : "+username);
            if (username != null) {
                // 토큰이 유효한지 확인
            	try {
                userDetails = userDetailsService.loadUserByUsername(username);
            	} catch (UsernameNotFoundException e) {
	                // 사용자 이름으로 찾지 못했을 경우 카카오 ID로 조회
            		userDetails = userDetailsService.loadUserByKakaoId(username);
	            }
                
                boolean isValid = jwtUtil.validateToken(token, userDetails);
                System.out.println("isValid : "+isValid);
                
                if (isValid) {
                    return ResponseEntity.ok(new ValidationResponse(true, "토큰이 유효합니다."));
                } else {
                    return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new ValidationResponse(false, "토큰이 유효하지 않습니다."));
                }
            } else {
                log.error("Failed to extract username from token.");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ValidationResponse(false, "토큰에서 사용자 정보를 추출할 수 없습니다."));
            }
        } catch (Exception e) {
            log.error("Exception occurred during token validation: ", e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ValidationResponse(false, "토큰 검증 중 오류가 발생했습니다."));
        }
    }

    // 토큰 응답 클래스
    public class TokenResponse {
        private String token;

        public TokenResponse(String token) {
            this.token = token;
        }

        public String getToken() {
            return token;
        }
    }

    // 에러 응답 클래스
    public class ErrorResponse {
        private String message;

        public ErrorResponse(String message) {
            this.message = message;
        }

        public String getMessage() {
            return message;
        }
    }

    // 토큰 유효성 검증 응답 클래스
    public class ValidationResponse {
        private boolean valid;
        private String message;

        public ValidationResponse(boolean valid, String message) {
            this.valid = valid;
            this.message = message;
        }

        public boolean isValid() {
            return valid;
        }

        public String getMessage() {
            return message;
        }
    }


    // 카카오 로그인 처리 엔드포인트
    @GetMapping("/oauth2/success")
    public ModelAndView kakaoLogin(@RequestParam("code") String code, HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        UserDetails userDetails = null;
        // 인가 코드 중복 사용 방지
        if (session.getAttribute("used_code") != null && session.getAttribute("used_code").equals(code)) {
            try {
                String encodedMessage = URLEncoder.encode("Error: 인가 코드가 이미 사용되었습니다. 다시 로그인해주세요.", StandardCharsets.UTF_8);
                response.sendRedirect("/login?message=" + encodedMessage);
                return null;
            } catch (IOException e) {
                throw new RuntimeException("Redirect failed", e);
            }
        }

        // 인가 코드 유효성 검사
        if (code == null || code.isEmpty()) {
            throw new IllegalArgumentException("Invalid authorization code");
        }

        // 카카오 토큰 요청
        RestTemplate restTemplate = new RestTemplate();
        String tokenRequestUrl = "https://kauth.kakao.com/oauth/token";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        String requestBody = String.format(
            "grant_type=authorization_code&client_id=%s&client_secret=%s&redirect_uri=%s&code=%s",
            "41211a2d42ebba192243003ab70cacc9", // client-id
            "PBFDPH3s6hvUPvvPOqhycFo6zYPW3a7n", // client-secret
            "https://localhost:8443/oauth2/success", // redirect URI
            code
        );

        HttpEntity<String> requestEntity = new HttpEntity<>(requestBody, headers);
        ResponseEntity<Map> responseEntity = restTemplate.exchange(tokenRequestUrl, HttpMethod.POST, requestEntity, Map.class);

        if (responseEntity.getStatusCode().is2xxSuccessful()) {
            Map<String, Object> responseBody = responseEntity.getBody();
            String accessToken = (String) responseBody.get("access_token");

            // 인가 코드 세션에 저장
            session.setAttribute("used_code", code);

            // 사용자 정보 요청
            String userInfoRequestUrl = "https://kapi.kakao.com/v2/user/me";
            HttpHeaders userInfoHeaders = new HttpHeaders();
            userInfoHeaders.setBearerAuth(accessToken);

            HttpEntity<String> userInfoRequestEntity = new HttpEntity<>(userInfoHeaders);
            ResponseEntity<Map> userInfoResponseEntity = restTemplate.exchange(userInfoRequestUrl, HttpMethod.GET, userInfoRequestEntity, Map.class);

            if (userInfoResponseEntity.getStatusCode().is2xxSuccessful()) {
                Map<String, Object> userInfo = userInfoResponseEntity.getBody();
                System.out.println("userInfo : "+userInfo);
                System.out.println("userInfoResponseEntity : "+userInfoResponseEntity);
                String kakaoId = userInfo.get("id").toString();
                Map<String, Object> properties = (Map<String, Object>) userInfo.get("properties");
                Map<String, Object> kakaoAccount = (Map<String, Object>) userInfo.get("kakao_account");
                
                String nickname = properties.get("nickname").toString();
                String name = kakaoAccount.get("name") != null ? kakaoAccount.get("name").toString() : "이름 없음";
                String email = kakaoAccount.get("email") != null ? kakaoAccount.get("email").toString() : "이메일 없음";
                String gender = kakaoAccount.get("gender") != null ? kakaoAccount.get("gender").toString() : "성별 없음";
                String birthday = kakaoAccount.get("birthday") != null ? kakaoAccount.get("birthday").toString() : "생일 없음";
                String birthyear = kakaoAccount.get("birthyear") != null ? kakaoAccount.get("birthyear").toString() : "출생연도 없음";
                String phone_number = kakaoAccount.get("phone_number") != null ? kakaoAccount.get("phone_number").toString() : "전화번호 없음";
                //String phone_number = kakaoAccount.get("phone_number") != null ? kakaoAccount.get("phone_number").toString() : "전화번호 없음";

             // 전화번호 변환
             if (phone_number != null && phone_number.startsWith("+82 ")) {
                 phone_number = phone_number.replace("+82 ", "0"); // +82를 0으로 변경
             } else if (phone_number != null && phone_number.startsWith("82 ")) {
                 phone_number = phone_number.replace("82 ", "0"); // 82를 0으로 변경
             }

             // 전화번호에서 공백과 하이픈 제거
             
                LocalDate birthDate = null;
                if (birthyear != null && birthday != null) {
                    // 생년월일을 LocalDate로 변환 (YYYY-MM-DD 형식)
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
                    birthDate = LocalDate.parse(birthyear + birthday, formatter);
                }
                
                if (birthDate != null) {
                    System.out.println("생년월일: " + birthDate); // 변환된 LocalDate 출력
                } else {
                	
                    System.out.println("생일 없음");
                }
                String genderInKorean = "성별 없음";

                if ("male".equals(gender)) {
                    genderInKorean = "남성";
                } else if ("female".equals(gender)) {
                    genderInKorean = "여성";
                }

                System.out.println("성별: " + genderInKorean); // 변환된 성별 출력

                System.out.println("email : " + email);
                System.out.println(nickname);
                System.out.println("phone_number : " + phone_number);
                // JWT 생성
                Map<String, Object> claims = new HashMap<>();
                claims.put("kakaoId", kakaoId);

                String jwtToken = jwtUtil.createToken(claims, kakaoId);

                // 쿠키 생성 및 추가
                Cookie cookie = new Cookie("JWT_TOKEN", jwtToken);
                cookie.setHttpOnly(true);
                cookie.setPath("/");
                cookie.setMaxAge(3600); // 1시간 유지
                response.addCookie(cookie);
                userDetails = userDetailsService.loadUserByKakaoId(kakaoId);
                System.out.println("authuserDetails : "+userDetails);
               
                if (userDetails == null) {
                    // 사용자 정보가 없으면 error 페이지로 이동
                    ModelAndView modelAndView = new ModelAndView("user_not_found");
                    modelAndView.addObject("errorMessage", "사용자가 데이터베이스에 없습니다.");
                    modelAndView.addObject("kakaoId", kakaoId); // kakaoId를 추가
                    modelAndView.addObject("name", name);
                    modelAndView.addObject("nickname", nickname);
                    modelAndView.addObject("email", email);
                    modelAndView.addObject("phoneNumber", phone_number);
                    modelAndView.addObject("genderInKorean", genderInKorean);
                    modelAndView.addObject("birthDate", birthDate);
                    return modelAndView; // 사용자 정보가 없을 경우 error 페이지
                }else {
                	System.out.println("성별: " + genderInKorean); // 변환된 성별 출력

                    System.out.println("email : " + email);
                    System.out.println(nickname);
                    System.out.println("phone_number : " + phone_number);
                ModelAndView modelAndView = new ModelAndView("success");
                modelAndView.addObject("token", jwtToken);
                modelAndView.addObject("phoneNumber", phone_number);
                modelAndView.addObject("genderInKorean", genderInKorean);
                modelAndView.addObject("birthDate", birthDate);
                modelAndView.addObject("username", kakaoId);
                modelAndView.addObject("name", name);
                modelAndView.addObject("nickname", nickname);
                modelAndView.addObject("email", email);
                

                return modelAndView;
                }
            } else {
                throw new RuntimeException("Failed to retrieve user information");
            }
        } else {
            throw new RuntimeException("Failed to retrieve access token");
        }
    }
    @GetMapping("/naver/success")
    public ModelAndView naverLogin(@RequestParam("code") String code, HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        UserDetails userDetails = null;
        System.out.println("code : "+code);
        // 인가 코드 중복 사용 방지
        if (session.getAttribute("used_code") != null && session.getAttribute("used_code").equals(code)) {
            try {
                String encodedMessage = URLEncoder.encode("Error: 인가 코드가 이미 사용되었습니다. 다시 로그인해주세요.", StandardCharsets.UTF_8);
                response.sendRedirect("/login?message=" + encodedMessage);
                return null;
            } catch (IOException e) {
                throw new RuntimeException("Redirect failed", e);
            }
        }

        // 인가 코드 유효성 검사
        if (code == null || code.isEmpty()) {
            throw new IllegalArgumentException("Invalid authorization code");
        }

        // 네이버 토큰 요청
        RestTemplate restTemplate = new RestTemplate();
        String tokenRequestUrl = "https://nid.naver.com/oauth2.0/token";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        String requestBody = String.format(
            "grant_type=authorization_code&client_id=%s&client_secret=%s&redirect_uri=%s&code=%s",
            "ZCu6SjlzSG3mKIvbTW1e", // 네이버 client-id
            "i9tNmWN5dX", // 네이버 client-secret
            "http://localhost:8443/naver/success", // redirect URI
            code
        );

        HttpEntity<String> requestEntity = new HttpEntity<>(requestBody, headers);
        ResponseEntity<Map> responseEntity = restTemplate.exchange(tokenRequestUrl, HttpMethod.POST, requestEntity, Map.class);

        if (responseEntity.getStatusCode().is2xxSuccessful()) {
            Map<String, Object> responseBody = responseEntity.getBody();
            String accessToken = (String) responseBody.get("access_token");

            // 인가 코드 세션에 저장
            session.setAttribute("used_code", code);

            // 사용자 정보 요청
            String userInfoRequestUrl = "https://openapi.naver.com/v1/nid/me";
            HttpHeaders userInfoHeaders = new HttpHeaders();
            userInfoHeaders.setBearerAuth(accessToken);
            userInfoHeaders.add("X-Naver-Client-Id", "ZCu6SjlzSG3mKIvbTW1e"); // 네이버 client-id
            userInfoHeaders.add("X-Naver-Client-Secret", "i9tNmWN5dX"); // 네이버 client-secret

            HttpEntity<String> userInfoRequestEntity = new HttpEntity<>(userInfoHeaders);
            ResponseEntity<Map> userInfoResponseEntity = restTemplate.exchange(userInfoRequestUrl, HttpMethod.GET, userInfoRequestEntity, Map.class);

            if (userInfoResponseEntity.getStatusCode().is2xxSuccessful()) {
                Map<String, Object> userInfo = userInfoResponseEntity.getBody();
                System.out.println("userInfo : " + userInfo);
                
                Map<String, Object> responseData = (Map<String, Object>) userInfo.get("response");
                String naverId = responseData.get("id").toString();
                String nickname = responseData.get("nickname").toString();
                String name = responseData.get("name") != null ? responseData.get("name").toString() : "이름 없음";
                String email = responseData.get("email") != null ? responseData.get("email").toString() : "이메일 없음";
                String gender = responseData.get("gender") != null ? responseData.get("gender").toString() : "성별 없음";
                String birthday = responseData.get("birthday") != null ? responseData.get("birthday").toString() : "생일 없음";
                String birthyear = responseData.get("birthyear") != null ? responseData.get("birthyear").toString() : "생일 없음";
                String phone_number=responseData.get("mobile") != null ? responseData.get("mobile").toString() : "전화번호 없음";
                LocalDate birthDate = null;
                if (birthyear != null && birthday != null) {
                    // 생년월일을 LocalDate로 변환 (YYYY-MM-DD 형식)
                	birthday = birthday.replace("-", ""); // "-" 제거
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd");
                    birthDate = LocalDate.parse(birthyear + birthday, formatter);
                }
                
                if (birthDate != null) {
                    System.out.println("생년월일: " + birthDate); // 변환된 LocalDate 출력
                } else {
                	
                    System.out.println("생일 없음");
                }
                String genderInKorean = "성별 없음";

                if ("m".equals(gender)) {
                    genderInKorean = "남성";
                } else if ("f".equals(gender)) {
                    genderInKorean = "여성";
                }
                System.out.println("naverId : "+naverId);
                System.out.println("birthday");
                // JWT 생성
                Map<String, Object> claims = new HashMap<>();
                claims.put("naverId", naverId);

                String jwtToken = jwtUtil.createToken(claims, naverId);

                // 쿠키 생성 및 추가
                Cookie cookie = new Cookie("JWT_TOKEN", jwtToken);
                cookie.setHttpOnly(true);
                cookie.setPath("/");
                cookie.setMaxAge(3600); // 1시간 유지
                response.addCookie(cookie);
                userDetails = userDetailsService.loadUserByNaverId(naverId);
                System.out.println("authuserDetails : " + userDetails);
               
                if (userDetails == null) {
                    // 사용자 정보가 없으면 error 페이지로 이동
                    ModelAndView modelAndView = new ModelAndView("user_not_found");
                    modelAndView.addObject("errorMessage", "사용자가 데이터베이스에 없습니다.");
                    modelAndView.addObject("kakaoId", naverId); // naverId를 추가
                    modelAndView.addObject("name", name);
                    modelAndView.addObject("nickname", nickname);
                    modelAndView.addObject("email", email);
                    modelAndView.addObject("phoneNumber", phone_number);
                    modelAndView.addObject("genderInKorean", genderInKorean);
                    modelAndView.addObject("birthDate", birthDate);
                    
                    return modelAndView; // 사용자 정보가 없을 경우 error 페이지
                } else {
                    ModelAndView modelAndView = new ModelAndView("success");
                    modelAndView.addObject("token", jwtToken);
                    modelAndView.addObject("username", naverId);
                    modelAndView.addObject("name", name);
                    modelAndView.addObject("nickname", nickname);
                    modelAndView.addObject("email", email);
                    return modelAndView;
                }
            } else {
                throw new RuntimeException("Failed to retrieve user information");
            }
        } else {
            throw new RuntimeException("Failed to retrieve access token");
        }
    }


    

    @GetMapping("/check-duplicate")
    public ResponseEntity<Map<String, Boolean>> checkDuplicate(@RequestParam String username) {
        boolean exists = checkIfUsernameExists(username); // 아이디 중복 체크 로직
        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }

    private boolean checkIfUsernameExists(String username) {
        try {
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);
            System.out.println("userDetails" + userDetails);
            return userDetails != null; // 사용자가 있으면 true 반환
        } catch (UsernameNotFoundException e) {
            // 사용자가 없으면 중복 아님 (false)
        	System.out.println("사용자 없음");
            return false;
        }
    }
    @PostMapping("/send-email")
    public ResponseEntity<?> sendEmail(@RequestBody EmailRequest emailRequest) throws UnsupportedEncodingException {
        System.out.println("emailRequest : " + emailRequest);
        String to = emailRequest.getEmail(); // 받는 사람의 이메일 주소
        String fromName = "코지픽"; // 보낼 웹사이트 이름
        String from = "jho8719@naver.com"; // 보내는 사람의 이메일 주소
        String password = "5G3TYJW8JZ34"; // 보내는 사람의 이메일 계정 비밀번호
        String host = "smtp.naver.com"; // Naver 메일 서버 호스트 이름

        // SMTP 프로토콜 설정
        Properties props = new Properties();
        props.setProperty("mail.smtp.host", host);
        props.setProperty("mail.smtp.port", "465");
        props.setProperty("mail.smtp.auth", "true");
        props.setProperty("mail.smtp.ssl.enable", "true"); // SSL 사용 설정

        // 보내는 사람 계정 정보 설정
        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        });

        try {
            // 인증 번호 생성
            generatedCode = generateRandomCode(6); // 6자리 랜덤 코드 생성

            // 메일 내용 작성 (HTML 형식)
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from, fromName));
            
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            msg.setSubject("코지픽 인증 번호");
            
            // HTML 내용
            String htmlContent = "<html>" +
                    "<body style='font-family: Arial, sans-serif;'>" +
                    "<h2 style='color: #4CAF50;'>안녕하세요!</h2>" +
                    "<p>코지픽 인증 번호를 발송합니다.</p>" +
                    "<h3 style='color: #FF5733;'>" + generatedCode + "</h3>" +
                    "<p>위의 인증 번호를 입력하여 인증을 완료해 주세요.</p>" +
                    "<footer style='margin-top: 20px;'>" +
                    "<p>감사합니다!</p>" +
                    "<p>코지픽 드림</p>" +
                    "</footer>" +
                    "</body>" +
                    "</html>";

            msg.setContent(htmlContent, "text/html; charset=UTF-8"); // HTML 내용 설정

            // 메일 보내기
            Transport.send(msg);
            System.out.println("메일이 성공적으로 발송되었습니다!");
            return ResponseEntity.ok().body(Map.of("success", true));

        } catch (MessagingException e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().body(Map.of("success", false));
        }
    }

    @PostMapping("/verify-code")
    public ResponseEntity<?> verifyCode(@RequestBody CodeVerificationRequest verificationRequest) {
        if (verificationRequest.getCode().equals(generatedCode)) {
            return ResponseEntity.ok().body(Map.of("success", true, "message", "인증 성공"));
        } else {
            return ResponseEntity.badRequest().body(Map.of("success", false, "message", "인증 실패"));
        }
    }

    // 6자리 랜덤 인증 코드 생성 메서드
    private String generateRandomCode(int length) {
        Random random = new Random();
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < length; i++) {
            code.append(random.nextInt(10)); // 0-9 사이의 숫자
        }
        return code.toString();
    }
    @PostMapping("/find-id/email")
    public ResponseEntity<Map<String, String>> findIdEmailPost(@RequestBody Map<String, String> request, HttpSession session) {
        String mail = request.get("email");
        String id = userDetailsService.idfind(mail);
        System.out.println("id : " + id);
        Map<String, String> response = new HashMap<>();
        
        if (id != null) {
            response.put("success", "true");
            response.put("id", id); // 아이디를 반환
            session.setAttribute("foundId", id); // 세션에 아이디 저장
        } else {
            response.put("success", "false");
            response.put("message", "아이디를 찾을 수 없습니다."); // 아이디가 없을 경우 메시지 반환
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("/get-found-id")
    public ResponseEntity<Map<String, String>> getFoundId(HttpSession session) {
        String foundId = (String) session.getAttribute("foundId"); // 세션에서 아이디 가져오기
        Map<String, String> response = new HashMap<>();
        System.out.println("foundId : "+foundId);
        if (foundId != null) {
            response.put("success", "true");
            response.put("id", foundId); // 아이디 반환
        } else {
            response.put("success", "false");
        }
        
        return ResponseEntity.ok(response);
    }
    @PostMapping("/password/check")
    public ResponseEntity<String> checkCurrentPassword(@RequestParam String email, @RequestParam String currentPassword) {
    	System.out.println("emailcontroller : "+email);
        boolean isCurrentPasswordCorrect = userDetailsService.checkPasswordMatch(email, currentPassword);

        if (isCurrentPasswordCorrect) {
            return ResponseEntity.ok("match");
        } else {
            return ResponseEntity.ok("mismatch");
        }
    }

}

// 이메일 요청 객체
class EmailRequest {
    private String email;

    // Getter 및 Setter
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}

// 인증 코드 검증 요청 객체
class CodeVerificationRequest {
    private String code;

    // Getter 및 Setter
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }
    
    

}


