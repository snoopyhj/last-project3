package com.example.security.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Properties;
import java.util.Random;
import java.util.UUID;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseCookie;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.example.security.dao.LoginDAOImpl;
import com.example.security.dao.RefreshTokenRepository;
import com.example.security.jwt.JwtUtil;
import com.example.security.service.CustomUserDetailsService;
import com.example.security.service.KakaoOAuth2Service;
import com.example.security.service.RefreshTokenService;
import com.example.security.vo.AuthRequest;
import com.example.security.vo.RefreshToken;
import com.example.security.vo.ReservationVO;
import com.example.security.vo.UserDto;

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
    private final RefreshTokenService refreshTokenService;
    private final RefreshTokenRepository refreshTokenRepository;
    @Autowired
    LoginDAOImpl dao;

    @Autowired
    public AuthController(AuthenticationManager authenticationManager,
                          CustomUserDetailsService userDetailsService,
                          JwtUtil jwtUtil,
                          KakaoOAuth2Service kakaoOAuth2Service
                          , RefreshTokenService refreshTokenService,RefreshTokenRepository refreshTokenRepository) {
        this.authenticationManager = authenticationManager;
        this.userDetailsService = userDetailsService;
        this.jwtUtil = jwtUtil;
        this.kakaoOAuth2Service = kakaoOAuth2Service;
        this.refreshTokenService = refreshTokenService;
        this.refreshTokenRepository = refreshTokenRepository;
    }
    
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody AuthRequest request, HttpServletResponse response, HttpSession session) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword()));

            UserDetails user = userDetailsService.loadUserByUsername(request.getUsername());
            if (user == null) {
                return ResponseEntity.status(401).body("사용자를 찾을 수 없습니다.");
            }

            // UUID가 있는지 확인하고 없으면 생성
            

            // JWT 및 리프레시 토큰 생성
            String accessToken = jwtUtil.generateToken(user);

            String user1 = userDetailsService.uuidfind(request.getUsername());
            
            String refreshToken = refreshTokenService.createRefreshToken(request.getUsername(), user1);
            if (user1 == null || user1.isEmpty()) {
                user1=userDetailsService.uuidfind(request.getUsername());
            }
            // 쿠키에 userUUID 추가
            Cookie userCookie = new Cookie("userUUID", user1);
            userCookie.setMaxAge(30 * 24 * 60 * 60); // 30일 유지
            userCookie.setHttpOnly(true);
            response.addCookie(userCookie);
            // 엑세스 토큰을 HttpOnly 쿠키에 저장
            ResponseCookie accessTokenCookie = ResponseCookie.from("JWT_TOKEN", accessToken)
                    .httpOnly(true)
                    .path("/")
                    .maxAge(60*60)  // 1시간 유지
                    .build();
            response.addHeader(HttpHeaders.SET_COOKIE, accessTokenCookie.toString());
            // 리프레시 토큰을 응답 바디에 추가
            Map<String, String> tokens = new HashMap<>();
            tokens.put("refreshToken", refreshToken);

            return ResponseEntity.ok(tokens);
        } catch (AuthenticationException e) {
            return ResponseEntity.status(401).body("인증 실패: 아이디 또는 비밀번호가 잘못되었습니다.");
        }
    }


    // 리프레시 토큰을 통한 엑세스 토큰 재발급
    
    @PostMapping("/refresh-token")
    public ResponseEntity<?> refreshAccessToken(
            @RequestBody(required = false) Map<String, String> requestBody,
            HttpSession session, HttpServletResponse response, HttpServletRequest request) {
        
        // 세션에서 UUID와 리프레시 토큰 가져오기
        String userUUID = null;
        
        // request에서 쿠키 배열 가져오기
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("userUUID".equals(cookie.getName())) {
                    userUUID = cookie.getValue();
                    break;
                }
            }
        }

        
        if (userUUID == null && requestBody != null) {
            userUUID = requestBody.get("userUUID");
            log.debug("userUUID from requestBody: {}", userUUID);
        }
        
        if (userUUID == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("세션 정보가 없습니다.");
        }
        
        // 리프레시 토큰 유효성 검사
        Optional<RefreshToken> storedTokenOpt = refreshTokenService.findById(userUUID);
        if (storedTokenOpt.isEmpty() || storedTokenOpt.get().isExpired()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("리프레시 토큰이 유효하지 않거나 만료되었습니다.");
        }
        
        // 새로운 엑세스 토큰 생성
        String userDetails = userDetailsService.idfind2(userUUID);
        UserDetails userDetails1 = userDetailsService.loadUserByUsername(userDetails);
        String newAccessToken = jwtUtil.generateToken(userDetails1);
        
        // 새 엑세스 토큰을 HttpOnly 쿠키로 설정
        ResponseCookie newAccessTokenCookie = ResponseCookie.from("JWT_TOKEN", newAccessToken)
                .httpOnly(true)
                .path("/")
                .maxAge(60*60)  // 1시간 유효
                .secure(true)
                .build();

        response.addHeader(HttpHeaders.SET_COOKIE, newAccessTokenCookie.toString());

        
        // JSON 응답 본문에 액세스 토큰 추가
        Map<String, String> responseBody = new HashMap<>();
        //responseBody.put("message", "새 엑세스 토큰 발급 완료");
        responseBody.put("accessToken", newAccessToken);  // 액세스 토큰을 응답 본문에 포함

        return ResponseEntity.ok(responseBody);  // 응답 본문에 액세스 토큰을 포함하여 반환
    }
    
    @GetMapping("/validate-retoken")
    public ResponseEntity<?> validatereToken(@RequestParam String token) {
        log.debug("Received token for validation: {}", token);
        
        try {
            String userUUID = jwtUtil.extractUserUUID(token);  // UUID를 추출하는 메서드로 변경
            if (userUUID != null) {
                UserDetails userDetails = userDetailsService.loadUserByUsername(userUUID);

                boolean isValid = jwtUtil.validateToken(token, userDetails);
                if (isValid) {
                    return ResponseEntity.ok(new ValidationResponse(true, "토큰이 유효합니다."));
                } else {
                    return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(new ValidationResponse(false, "토큰이 유효하지 않습니다."));
                }
            } else {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ValidationResponse(false, "토큰에서 사용자 정보를 추출할 수 없습니다."));
            }
        } catch (Exception e) {
            log.error("Exception occurred during token validation: ", e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(new ValidationResponse(false, "토큰 검증 중 오류가 발생했습니다."));
        }
    }


    // 추가된 JWT 토큰 유효성 검증 API
    @GetMapping("/validate-token")
    public ResponseEntity<?> validateToken(@RequestParam String token) {
        log.debug("Received token for validation: {}", token);

        try {
            // URL 디코딩 후 기본 형식 체크
            String decodedToken = URLDecoder.decode(token, StandardCharsets.UTF_8);
            
            // 토큰 형식 검증 (JWT 형식: header.payload.signature)
            if (decodedToken == null || !decodedToken.contains(".") || decodedToken.split("\\.").length != 3) {
                log.error("Invalid JWT format: {}", decodedToken);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ValidationResponse(false, "잘못된 토큰 형식입니다."));
            }

            // 토큰에서 사용자 이름 또는 Kakao ID 추출
            String username = jwtUtil.extractUsername(decodedToken);
            if (username == null) {
                username = jwtUtil.extractKakaoId(decodedToken);
            }
            
            log.debug("Extracted username: {}", username);


            if (username != null) {
                // 사용자 로드 시도
                UserDetails userDetails;
                try {
                    userDetails = userDetailsService.loadUserByUsername(username);
                } catch (UsernameNotFoundException e) {
                    log.warn("Username not found, trying Kakao ID lookup: {}", username);
                    userDetails = userDetailsService.loadUserByKakaoId(username);
                }
                // 토큰 유효성 확인
                boolean isValid = jwtUtil.validateToken(decodedToken, userDetails);

                
                if (isValid) {
                    return ResponseEntity.ok(new ValidationResponse(true, "토큰이 유효합니다."));
                } else {
                    return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                            .body(new ValidationResponse(false, "토큰이 유효하지 않습니다."));
                }
            } else {
                log.error("Failed to extract username from token.");
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ValidationResponse(false, "토큰에서 사용자 정보를 추출할 수 없습니다."));
            }
        } catch (Exception e) {
            log.error("Exception occurred during token validation: ", e);
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(new ValidationResponse(false, "토큰 검증 중 오류가 발생했습니다."));
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
            Cookie kakaoTokenCookie = new Cookie("KAKAO_ACCESS_TOKEN", accessToken);
            kakaoTokenCookie.setHttpOnly(true); // 보안을 위해 HttpOnly 설정
            kakaoTokenCookie.setPath("/"); // 경로 설정
            kakaoTokenCookie.setMaxAge(60); // 1시간 (3600초)
            response.addCookie(kakaoTokenCookie);
            // 인가 코드 세션에 저장
            session.setAttribute("used_code", code);
            
            // 사용자 정보 요청
            String userInfoRequestUrl = "https://kapi.kakao.com/v2/user/me";
            HttpHeaders userInfoHeaders = new HttpHeaders();
            userInfoHeaders.setBearerAuth(accessToken);

            
            HttpEntity<String> userInfoRequestEntity = new HttpEntity<>(userInfoHeaders);
            
            ResponseEntity<Map> userInfoResponseEntity = restTemplate.exchange(userInfoRequestUrl, HttpMethod.GET, userInfoRequestEntity, Map.class);

            String shippingAddressUrl = "https://kapi.kakao.com/v1/user/shipping_address";
            HttpEntity<String> shippingAddressRequestEntity = new HttpEntity<>(userInfoHeaders);
            ResponseEntity<Map> shippingAddressResponseEntity = restTemplate.exchange(
                shippingAddressUrl, HttpMethod.GET, shippingAddressRequestEntity, Map.class
            );
            String baseAddress = "배송지 정보 없음";
            if (userInfoResponseEntity.getStatusCode().is2xxSuccessful()&&shippingAddressResponseEntity.getStatusCode().is2xxSuccessful()) {
                
                Map<String, Object> shippingInfo = shippingAddressResponseEntity.getBody();
                if (shippingInfo != null && shippingInfo.containsKey("shipping_addresses")) {
                	 java.util.List<?> shippingAddresses = (java.util.List) shippingInfo.get("shipping_addresses"); // List<?>로 캐스팅

                     if (!shippingAddresses.isEmpty()) {
                         Map<String, Object> firstAddress = (Map<String, Object>) shippingAddresses.get(0); // 첫 번째 배송지
                         baseAddress = (String) firstAddress.get("base_address"); // base_address 추출
                     }
                }
                Map<String, Object> userInfo = userInfoResponseEntity.getBody();

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

               
                if (userDetails == null) {
                    // 사용자 정보가 없으면 error 페이지로 이동
                    ModelAndView modelAndView = new ModelAndView("login/user_not_found");
                    modelAndView.addObject("errorMessage", "사용자가 데이터베이스에 없습니다.");
                    
                    session.setAttribute("userData", new UserDto(kakaoId, email, name, nickname, phone_number, genderInKorean, birthDate, baseAddress));

                    return modelAndView; // 사용자 정보가 없을 경우 error 페이지
                }else {




                ModelAndView modelAndView = new ModelAndView("login/success");
                modelAndView.addObject("token", jwtToken);

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
            Cookie naverTokenCookie = new Cookie("NAVER_ACCESS_TOKEN", accessToken);
            naverTokenCookie.setHttpOnly(true); // 보안을 위해 HttpOnly 설정
            naverTokenCookie.setPath("/"); // 경로 설정
            naverTokenCookie.setMaxAge(3600); // 1시간 (3600초)
            response.addCookie(naverTokenCookie);
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
                } else {
                	
                }
                String genderInKorean = "성별 없음";

                if ("M".equals(gender)) {
                    genderInKorean = "남성";
                } else if ("F".equals(gender)) {
                    genderInKorean = "여성";
                }
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

               
                if (userDetails == null) {
                    // 사용자 정보가 없으면 error 페이지로 이동
                    ModelAndView modelAndView = new ModelAndView("login/user_not_found");
                    modelAndView.addObject("errorMessage", "사용자가 데이터베이스에 없습니다.");
                    session.setAttribute("userData", new UserDto(naverId, email, name, nickname, phone_number, genderInKorean, birthDate, null));
                    return modelAndView; // 사용자 정보가 없을 경우 error 페이지
                } else {
                    ModelAndView modelAndView = new ModelAndView("login/success");
                    modelAndView.addObject("token", jwtToken);
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
    @GetMapping("/check-email-duplicate")
    public ResponseEntity<Map<String, Boolean>> checkEmailDuplicate(@RequestParam String email) {
        boolean exists = userDetailsService.mailcheck(email);
        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        return ResponseEntity.ok(response);
    }

    private boolean checkIfUsernameExists(String username) {
        try {
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);

            return userDetails != null; // 사용자가 있으면 true 반환
        } catch (UsernameNotFoundException e) {
            // 사용자가 없으면 중복 아님 (false)
        	System.out.println("사용자 없음");
            return false;
        }
    }
    
    @PostMapping("/send-email")
    public ResponseEntity<?> sendEmail(@RequestBody EmailRequest emailRequest) throws UnsupportedEncodingException {

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

        boolean isCurrentPasswordCorrect = userDetailsService.checkPasswordMatch(email, currentPassword);

        if (isCurrentPasswordCorrect) {
            return ResponseEntity.ok("match");
        } else {
            return ResponseEntity.ok("mismatch");
        }
    }
    @PostMapping("/deleteuser")
    public ResponseEntity<String> deleteUser(@RequestParam String email, @RequestParam String password, HttpServletResponse response,HttpServletRequest request) {
        // 비밀번호 검증 및 사용자 삭제 로직
    	 boolean isDeleted=false;
        Cookie[] cookies = request.getCookies();
        String jwtToken = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("JWT_TOKEN".equals(cookie.getName())) {
                    jwtToken = cookie.getValue();
                    break;
                }
            }
        }
        String kakaoAccessToken = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("KAKAO_ACCESS_TOKEN".equals(cookie.getName())) {
                    kakaoAccessToken = cookie.getValue();
                    break;
                }
            }
        }
        // 카카오 연결 해제
        if (kakaoAccessToken != null) {
            unlinkKakaoAccount(kakaoAccessToken); // 카카오와의 연결 해제 메서드 호출
        }
        String naverAccessToken = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("NAVER_ACCESS_TOKEN".equals(cookie.getName())) {
                    naverAccessToken = cookie.getValue();
                    break;
                }
            }
        }

        // 네이버 계정 연동 해제
        if (naverAccessToken != null) {
            unlinkNaverAccount(naverAccessToken); // 네이버 연동 해제 메서드 호출
        }

        // JWT 토큰에서 사용자 이름(username) 추출
        if (jwtToken != null) {
            try {
                String username = jwtUtil.extractUsername(jwtToken); // extractUsername 메서드 사용
                if (username != null) {
                    // 사용자명으로 리프레시 토큰 삭제
                    refreshTokenRepository.deleteByUsername(username);
                    isDeleted = dao.deleteUser(email, password);

                }
            } catch (Exception e) {
                System.out.println("JWT 토큰 파싱 오류: " + e.getMessage());
            }
        }
        if (isDeleted) {
            // 쿠키 삭제
        	 if (cookies != null) {
 	            for (Cookie cookie : cookies) {
 	                if ("JWT_TOKEN".equals(cookie.getName()) || "userUUID".equals(cookie.getName()) || "rememberMe".equals(cookie.getName())|| "KAKAO_ACCESS_TOKEN".equals(cookie.getName())|| "NAVER_ACCESS_TOKEN".equals(cookie.getName())) {
 	                    Cookie expiredCookie = new Cookie(cookie.getName(), null);
 	                    expiredCookie.setMaxAge(0); // 만료 시간 0으로 설정해 쿠키 삭제
 	                    expiredCookie.setPath("/"); // 경로를 '/'로 설정
 	                    expiredCookie.setHttpOnly(true); // HttpOnly 설정
 	                    expiredCookie.setSecure(request.isSecure()); // HTTPS일 때 Secure 설정

 	                    response.addCookie(expiredCookie); // 삭제할 쿠키를 응답에 추가

 	                }
 	            }
 	        }
            
            return ResponseEntity.ok("User deleted");
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Deletion failed");
        }
    }
    @GetMapping("/api/reservation-info")
    @ResponseBody
    public ResponseEntity<?> getReservationInfo(HttpServletRequest request) {
        try {
            String token = null;
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("JWT_TOKEN".equals(cookie.getName())) {
                        token = cookie.getValue();
                        break;
                    }
                }
            }

            String username = null;
            if (token != null && !jwtUtil.isTokenExpired(token)) {
                username = jwtUtil.extractUsername(token);
                if (username == null) {
                    username = jwtUtil.extractKakaoId(token);
                }
            }

            if (username == null) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(Map.of("error", "Unauthorized user"));
            }

            List<ReservationVO> reservations = dao.findReservationById(username);
            return ResponseEntity.ok(reservations);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of("error", "An error occurred", "details", e.getMessage()));
        }
    }



    private void unlinkKakaoAccount(String kakaoAccessToken) {
        String url = "https://kapi.kakao.com/v1/user/unlink";
        
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + kakaoAccessToken);
        
        RestTemplate restTemplate = new RestTemplate();
        HttpEntity<String> entity = new HttpEntity<>(headers);
        
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
        if (response.getStatusCode().is2xxSuccessful()) {
            log.info("카카오 계정 연동 해제 성공");
        } else {
            log.warn("카카오 계정 연동 해제 실패: 상태 코드 = {}", response.getStatusCode());
        }
    }
    private void unlinkNaverAccount(String naverAccessToken) {
        String url = "https://nid.naver.com/oauth2.0/token?grant_type=delete&client_id=ZCu6SjlzSG3mKIvbTW1e&client_secret=i9tNmWN5dX&access_token=" + naverAccessToken + "&service_provider=NAVER";
        
        RestTemplate restTemplate = new RestTemplate();
        ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
        
        if (response.getStatusCode().is2xxSuccessful()) {
            log.info("네이버 계정 연동 해제 성공");
        } else {
            log.warn("네이버 계정 연동 해제 실패: 상태 코드 = {}", response.getStatusCode());
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


