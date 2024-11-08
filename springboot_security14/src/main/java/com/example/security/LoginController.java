	package com.example.security;
	
	import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import jakarta.servlet.http.Cookie;
	import jakarta.servlet.http.HttpServletRequest;
	import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.context.annotation.Lazy;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
	import org.springframework.security.core.userdetails.UsernameNotFoundException;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;

import com.example.security.dao.LoginDAOImpl;
import com.example.security.vo.AuthRequest;
import com.example.security.vo.UserInfo;
	
	@Controller
	@RequestMapping("/")
	public class LoginController {
	
	    @Autowired
	    private JwtUtil jwtUtil;
	    private final CustomUserDetailsService userDetailsService;
	    @Autowired
	    LoginDAOImpl dao;
	    private final RefreshTokenRepository refreshTokenRepository;
	
	    public LoginController(JwtUtil jwtUtil, @Lazy CustomUserDetailsService userDetailsService,RefreshTokenRepository refreshTokenRepository) {
	        this.jwtUtil = jwtUtil;
	        this.userDetailsService = userDetailsService;
	        this.refreshTokenRepository = refreshTokenRepository;
	    }
//	    @GetMapping("/")
//	    public String getHome(HttpServletRequest request, HttpServletResponse response) {
//	        // 쿠키에서 토큰을 추출
//	        String token = null;
//	        Cookie[] cookies = request.getCookies();
//	        if (cookies != null) {
//	            for (Cookie cookie : cookies) {
//	                if ("JWT_TOKEN".equals(cookie.getName())) {
//	                    token = cookie.getValue();
//	                    break; // 토큰을 찾으면 반복 종료
//	                }
//	            }
//	        }
//	
//	        // Authorization 헤더에서 토큰 추출
//	        String authHeader = request.getHeader("Authorization");
//	        if (authHeader != null && authHeader.startsWith("Bearer ")) {
//	            token = authHeader.substring(7); // "Bearer " 이후의 토큰만 추출
//	            // 쿠키 생성
//	            Cookie cookie = new Cookie("JWT_TOKEN", token);
//	            cookie.setHttpOnly(true); // 클라이언트 측 JavaScript에서 접근하지 못하도록 설정
//	            cookie.setPath("/"); // 쿠키가 모든 경로에서 유효하도록 설정
//	            cookie.setMaxAge(3600); // 1시간 동안 쿠키 유지
//	            
//	            response.addCookie(cookie);
//	            System.out.println("쿠키 생성됨: JWT_TOKEN=" + token);
//	        }
//	
//	        if (token != null) {
//	            System.out.println("토큰: " + token);
//	            // 여기서 토큰을 사용한 추가 로직을 작성할 수 있습니다.
//	        } else {
//	            System.out.println("토큰이 존재하지 않음");
//	        }
//	
//	        System.out.println("home page requested");
//	        return "main";
//	    }
	    @GetMapping("/")
	    public String home() {
	        return "main";
	    }
	
	    @GetMapping("/login")
	    public String loginPage() {
	        System.out.println("Login page requested");
	        
	        return "login"; // login.html 페이지를 반환
	    }
	    
	    
	    
	    
	    @GetMapping("/userinfo")
	    @ResponseBody
	    public AuthRequest getUserInfo(
	            @RequestParam(required = false) String token,
	            HttpServletRequest request, HttpServletResponse response) throws IOException {

	        System.out.println("userinfo 요청 수신");

	        // 1. 쿠키 또는 Authorization 헤더에서 JWT 토큰 검색
	        Cookie[] cookies = request.getCookies();
	        if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                if ("JWT_TOKEN".equals(cookie.getName())) {
	                    token = cookie.getValue();
	                    break;
	                }
	            }
	        } else {
	            String authorizationHeader = request.getHeader("Authorization");
	            if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
	                token = authorizationHeader.substring(7); // "Bearer " 부분 제거
	            }
	        }

	        // 2. JWT 토큰 유효성 검사 및 사용자 정보 조회
	        if (token != null && !jwtUtil.isTokenExpired(token)) {
	            String username = jwtUtil.extractUsername(token);
	            System.out.println("username : "+username);
	            if(username==null) {
	            	username = jwtUtil.extractKakaoId(token);
	            }
	            UserDetails userDetails;
	            try {
	                userDetails = userDetailsService.loadUserByUsername(username);
	            } catch (UsernameNotFoundException e) {
	            	userDetails = userDetailsService.loadUserByKakaoId(username);
	                return new AuthRequest(userDetails.getUsername(), "", false); // 사용자를 찾을 수 없는 경우 빈 AuthRequest 반환
	            }

	            // 3. 관리자 권한 확인 및 반환
	            boolean isAdmin = userDetails.getAuthorities().stream()
	                    .anyMatch(authority -> authority.getAuthority().equals("ROLE_ADMIN"));
	            return new AuthRequest(userDetails.getUsername(), "", isAdmin);
	        } else {
	            // 유효하지 않은 토큰 처리: 리프레시 로직을 위해 401 반환
	            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	            return null;
	        }
	    }




	    @GetMapping("/confirm-kakao-insert")
	    public String confirmKakaoInsert(@RequestParam(required = false) String name, 
	            @RequestParam(required = false) String email, 
	            @RequestParam(required = false) String phone_number, 
	            @RequestParam(required = false) String gender, 
	            @RequestParam(required = false) String birthDate,@RequestParam(required = false) String username, Model model) {
	    	System.out.println("인서트 뭍는 부분1:"+username);
	    	System.out.println("name : " + name);
	        System.out.println("email : " + email);
	        System.out.println("phone_number : " + phone_number);
	        System.out.println("genderInKorean : " + gender);
	        System.out.println("birthDate : " + birthDate);
	        // 삽입 여부를 묻는 페이지로 username을 전달
	        model.addAttribute("username", username);
	        model.addAttribute("name", name);
	        model.addAttribute("email", email);
	        model.addAttribute("phoneNumber", phone_number);
	        model.addAttribute("genderInKorean", gender);
	        model.addAttribute("birthDate", birthDate);
	        
	        return "confirm-kakao-insert"; // 삽입 여부를 물어보는 HTML 페이지
	    }

	    @PostMapping("/confirm-kakao-insert")
	    public String handleKakaoInsert(@RequestParam(required = false) String username, @RequestParam(required = false) String name, 
	            @RequestParam(required = false) String email, 
	            @RequestParam(required = false) String phone_number, 
	            @RequestParam(required = false) String gender, 
	            @RequestParam(required = false) String birthDate,@RequestParam(required = false) boolean confirm, HttpServletResponse response) throws IOException {
	    	String uniqueId = UUID.randomUUID().toString();

//	    	System.out.println("username1 : " + username);
	        System.out.println("name : " + name);
	        System.out.println("email : " + email);
	        System.out.println("phone_number : " + phone_number);
	        System.out.println("genderInKorean : " + gender);
	        System.out.println("birthDate : " + birthDate);
	    	System.out.println("인서트 뭍는 부분2:"+username);
	    	System.out.println("인서트 뭍는 부분2:"+confirm);
	        if (confirm) {
	            // 사용자가 삽입을 허용했을 경우 카카오 정보를 삽입
	            boolean kakaoinsert = userDetailsService.InsertkakaoInfo(uniqueId,username,"cozypick",name,email,phone_number,gender,birthDate);
	            if (kakaoinsert) {
	                // 삽입 성공 시 로그인 페이지로 리다이렉트
	                response.sendRedirect("/login");
	                return null;
	            }
	        } else {
	            // 사용자가 삽입을 허용하지 않았을 경우 메시지를 출력하거나 다른 처리
	            System.out.println("User declined to insert Kakao information.");
	        }

	        return "redirect:/"; // 삽입 거부 시 홈 페이지로 리다이렉트
	    }
	    @GetMapping("/logout")
	    @Transactional
	    public String logout(HttpServletRequest request, HttpServletResponse response) {
	        System.out.println("안녕");

	        // 쿠키에서 JWT 토큰 가져오기
	        String jwtToken = null;
	        Cookie[] cookies = request.getCookies();
	        if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                if ("JWT_TOKEN".equals(cookie.getName())) {
	                    jwtToken = cookie.getValue();
	                    break;
	                }
	            }
	        }

	        // JWT 토큰에서 사용자 이름(username) 추출
	        if (jwtToken != null) {
	            try {
	                String username = jwtUtil.extractUsername(jwtToken); // extractUsername 메서드 사용
	                if (username != null) {
	                    // 사용자명으로 리프레시 토큰 삭제
	                    refreshTokenRepository.deleteByUsername(username);
	                    System.out.println("리프레시 토큰 삭제됨 for user: " + username);
	                }
	            } catch (Exception e) {
	                System.out.println("JWT 토큰 파싱 오류: " + e.getMessage());
	            }
	        }

	        // JWT, userUUID, rememberMe 쿠키 삭제
	        if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                if ("JWT_TOKEN".equals(cookie.getName()) || "userUUID".equals(cookie.getName()) || "rememberMe".equals(cookie.getName()) || "KAKAO_ACCESS_TOKEN".equals(cookie.getName())|| "NAVER_ACCESS_TOKEN".equals(cookie.getName())) {
	                    Cookie expiredCookie = new Cookie(cookie.getName(), null);
	                    expiredCookie.setMaxAge(0); // 만료 시간 0으로 설정해 쿠키 삭제
	                    expiredCookie.setPath("/"); // 경로를 '/'로 설정
	                    expiredCookie.setHttpOnly(true); // HttpOnly 설정
	                    expiredCookie.setSecure(request.isSecure()); // HTTPS일 때 Secure 설정

	                    response.addCookie(expiredCookie); // 삭제할 쿠키를 응답에 추가
	                    System.out.println(cookie.getName() + " 쿠키 제거됨");
	                }
	            }
	        }

	        // 세션이 있다면 세션 무효화
	        request.getSession().invalidate();
	        System.out.println("사용자 세션 무효화됨");

	        // 로그아웃 후 로그인 페이지로 리다이렉트
	        return "redirect:/login";
	    }
	    
	    // 기타 요청 처리 메소드들
	
	    
	    @RequestMapping("/register")
	    public String registerform() {
	        return "register";
	    }
	    
	    @RequestMapping("/regionfilter")
	    public String regionfilter() {
	        return "redirect:regionfilter";
	    }
	    
	    @RequestMapping("/hotellist")
	    public String hotellist() {
	        return "hotellist";
	    }
	    
	    @RequestMapping("/hoteldetail")
	    public String hoteldetail() {
	        return "hoteldetail";
	    }   
	    
	    @RequestMapping("/aboutus")
	    public String aboutus() {
	        return "aboutus";
	    }
	    
	    @RequestMapping("/question")
	    public String question() {
	        return "question";
	    }
	    
	    @RequestMapping("/email")
	    public String email() {
	        return "email";
	    }
	    @RequestMapping(value="/insert_member",  method = RequestMethod.POST)
		public String insert_member(HttpServletRequest req,HttpServletResponse response) throws IOException {
	    	LocalDateTime now = LocalDateTime.now();
	    	DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	    	String formattedDateTime = now.format(formatter);
	    	String formation = req.getParameter("birthday");

	    	// 입력 형식이 "yyyy-MM-dd"라고 가정
	    	DateTimeFormatter formatter1 = DateTimeFormatter.ofPattern("yyyyMMdd");

	    	// String -> LocalDate
	    	LocalDate localDate = LocalDate.parse(formation, formatter1);

	    	// LocalDate -> java.sql.Date
	    	Date sqlDate1 = Date.valueOf(localDate);
	    	
	    	// 문자열을 LocalDateTime으로 변환
	    	LocalDateTime dateTime = LocalDateTime.parse(formattedDateTime, formatter);
	    	
	    	// 만약 java.sql.Date가 필요하다면:
	    	java.sql.Date sqlDate = java.sql.Date.valueOf(dateTime.toLocalDate());
	    	
			 // 다중 선택된 값을 배열로 받아옵니다.
		    String[] signupRoute = req.getParameterValues("signupRoute");
 
		    String signupRoutesString = String.join(",", signupRoute);
		    
		    boolean kakaoinsert = userDetailsService.insert_member(req.getParameter("id"),
		    	    req.getParameter("pwd"),
		    	    req.getParameter("name"),
		    	    req.getParameter("tel"),
		    	    req.getParameter("address"),
		    	    signupRoutesString,
		    	    req.getParameter("gender"),
		    	    sqlDate,
		    	    req.getParameter("email"),
		    	    sqlDate1
		    	    ); // LocalDate로 변환하여 전달
		    		
            if (kakaoinsert) {
                // 삽입 성공 시 로그인 페이지로 리다이렉트
                response.sendRedirect("/login");
                return null;
            }
         else {
            // 사용자가 삽입을 허용하지 않았을 경우 메시지를 출력하거나 다른 처리
            System.out.println("User declined to insert Kakao information.");
        }

			
			return "redirect:login";
		}
	    @GetMapping("/find-id/email")
	    public String findidemailget() {
	    	return "findidemail";
	    }
	    @GetMapping("/change-pw/email")
	    public String changepwemailget() {
	        return "changepwemail";
	    }

	    @GetMapping("/password/check")
	    public String changepw() {
	        return "changepw";
	    }
	    
	    @PostMapping("/idview")
	    public String idView(@RequestParam("id") String id, Model model) {
	        model.addAttribute("foundId", id);  // ID를 모델에 추가하여 View로 전달
	        return "idview";  // ID를 표시할 뷰 이름 반환
	    }
	    @PostMapping("/password/change")
	    public String changePassword(@RequestParam(value="email",required=false) String email,
                @RequestParam String newPassword,
                @RequestParam String confirmPassword,
                Model model) {
					if (!newPassword.equals(confirmPassword)) {
					model.addAttribute("error", "새 비밀번호와 비밀번호 확인이 일치하지 않습니다.");
					return "passwordChangeForm";
}
					System.out.println("email : "+email);
					userDetailsService.updatePassword(email, newPassword);
					return "redirect:/login";
}
	    // API to retrieve user info
	    @GetMapping("/api/user-info")
	    @ResponseBody
	    public AuthRequest getUserInfo(HttpServletRequest request) {
	        // JWT 토큰을 추출
	        String token = extractTokenFromRequest(request);
	        System.out.println("api token: " + token);

	        if (token != null) {
	            // JWT에서 사용자 이름 추출
	            String username = jwtUtil.extractUsername(token);
	            UserDetails userDetails = null;
	            UserInfo userInfo = null;

	            try {
	                // 사용자 이름으로 UserDetails 조회
	                userDetails = userDetailsService.loadUserByUsername(username);
	            } catch (UsernameNotFoundException e) {
	                // 사용자 이름으로 찾지 못했을 경우 카카오 ID로 조회
	                try {
	                    System.out.println("Username not found, trying Kakao ID: " + username);
	                    userDetails = userDetailsService.loadUserByKakaoId(username);
	                } catch (UsernameNotFoundException ex) {
	                    // 카카오 ID로도 찾지 못한 경우 처리
	                    System.err.println("Kakao ID not found: " + username);
	                    return null; // 사용자 정보를 찾지 못한 경우 null 반환
	                }
	            }

	            if (userDetails != null) {
	                System.out.println("api userDetails: " + userDetails);

	                // 사용자 정보(UserInfo) 조회
	                try {
	                    userInfo = dao.getUserInfoByUsername(username);  // 일반 사용자 정보 조회
	                } catch (Exception e) {
	                    System.err.println("Error fetching user info by username: " + e.getMessage());
	                }

	                // 카카오 사용자 정보 조회
	                if (userInfo == null) {
	                    try {
	                        System.out.println("Trying to fetch Kakao user info.");
	                        userInfo = dao.getUserInfoByUsernamekakao(username);  // 카카오 사용자 정보 조회
	                    } catch (Exception e) {
	                        System.err.println("Error fetching Kakao user info: " + e.getMessage());
	                        return null;  // 사용자 정보를 찾지 못하면 null 반환
	                    }
	                }

	                if (userInfo != null) {
	                	
	                    System.out.println("api userInfo: " + userInfo.getEmail());
	                    System.out.println("api userInfo: " + userInfo.getName());
	                    System.out.println("api userInfo: " + userInfo.getPhoneNumber());
	                    System.out.println("api userInfo: " + userInfo.getAddress());
	                    // AuthRequest 생성 및 반환
	                    return new AuthRequest(
	                        userDetails.getUsername(),
	                        userInfo.getEmail(),
	                        userInfo.getPhoneNumber(),
	                        userInfo.getName(),
	                        userInfo.getAddress(),
	                        userDetails.getAuthorities().stream()
	                            .anyMatch(auth -> auth.getAuthority().equals("ROLE_ADMIN"))
	                    );
	                } else {
	                    System.out.println("UserInfo is null, could not retrieve user information.");
	                }
	            }
	        }

	        System.out.println("No token or user not found.");
	        return null; // No token or user not found
	    }


	    // Helper method to extract JWT token from cookies or header
	    private String extractTokenFromRequest(HttpServletRequest request) {
	        Cookie[] cookies = request.getCookies();
	        if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                if ("JWT_TOKEN".equals(cookie.getName())) {
	                    return cookie.getValue();
	                }
	            }
	        }

	        String authHeader = request.getHeader("Authorization");
	        if (authHeader != null && authHeader.startsWith("Bearer ")) {
	            return authHeader.substring(7); // Extract token after "Bearer "
	        }

	        return null;
	    }
	
	    @GetMapping("/mypage")
	    public String mypage() {
	    	return "mypage";
	    }
	    @GetMapping("/MyInformation")
	    public String MyInformation() {
	    	return "MyInformation";
	    }
	    @GetMapping("/leave")
	    public String leave() {
	    	return "leave";
	    }
	    @GetMapping("/setting")
	    public String setting() {
	    	return "set";
	    }
	    

	
	    
	    
	}
