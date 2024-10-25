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
	import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.context.annotation.Lazy;
	import org.springframework.security.core.userdetails.UserDetails;
	import org.springframework.security.core.userdetails.UsernameNotFoundException;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
	import org.springframework.web.bind.annotation.GetMapping;
	import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;

import com.example.security.dao.LoginDAOImpl;
import com.example.security.vo.AuthRequest;
	
	@Controller
	@RequestMapping("/")
	public class LoginController {
	
	    @Autowired
	    private JwtUtil jwtUtil;
	    private final CustomUserDetailsService userDetailsService;
	    @Autowired
	    LoginDAOImpl dao;
	
	    public LoginController(JwtUtil jwtUtil, @Lazy CustomUserDetailsService userDetailsService) {
	        this.jwtUtil = jwtUtil;
	        this.userDetailsService = userDetailsService;
	    }
	    @GetMapping("/")
	    public String getHome(HttpServletRequest request, HttpServletResponse response) {
	        // 쿠키에서 토큰을 추출
	        String token = null;
	        Cookie[] cookies = request.getCookies();
	        if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                if ("JWT_TOKEN".equals(cookie.getName())) {
	                    token = cookie.getValue();
	                    break; // 토큰을 찾으면 반복 종료
	                }
	            }
	        }
	
	        // Authorization 헤더에서 토큰 추출
	        String authHeader = request.getHeader("Authorization");
	        if (authHeader != null && authHeader.startsWith("Bearer ")) {
	            token = authHeader.substring(7); // "Bearer " 이후의 토큰만 추출
	            // 쿠키 생성
	            Cookie cookie = new Cookie("JWT_TOKEN", token);
	            cookie.setHttpOnly(true); // 클라이언트 측 JavaScript에서 접근하지 못하도록 설정
	            cookie.setPath("/"); // 쿠키가 모든 경로에서 유효하도록 설정
	            cookie.setMaxAge(3600); // 1시간 동안 쿠키 유지
	            
	            response.addCookie(cookie);
	            System.out.println("쿠키 생성됨: JWT_TOKEN=" + token);
	        }
	
	        if (token != null) {
	            System.out.println("토큰: " + token);
	            // 여기서 토큰을 사용한 추가 로직을 작성할 수 있습니다.
	        } else {
	            System.out.println("토큰이 존재하지 않음");
	        }
	
	        System.out.println("home page requested");
	        return "main";
	    }
	
	    @GetMapping("/login")
	    public String loginPage() {
	        System.out.println("Login page requested");
	        return "login"; // login.html 페이지를 반환
	    }
	    
	    
	    
	    @GetMapping("/userinfo")
	    @ResponseBody
	    public AuthRequest getUserInfo(@RequestParam(required = false) String token,
	            @RequestParam(required = false) String username,
	            @RequestParam(required = false) String name, 
	            @RequestParam(required = false) String email, 
	            @RequestParam(required = false) String phone_number, 
	            @RequestParam(required = false) String genderInKorean, 
	            @RequestParam(required = false) String birthDate,
	            HttpServletRequest request, HttpServletResponse response, AuthRequest auth) throws IOException {
	        System.out.println("userinfo 입니다 : ");
	        
	        System.out.println("username1 : " + username);
	        System.out.println("name : " + name);
	        System.out.println("email : " + email);
	        System.out.println("phone_number : " + phone_number);
	        System.out.println("genderInKorean : " + genderInKorean);
	        System.out.println("birthDate : " + birthDate);
	        System.out.println(token);
	        Cookie[] cookies = request.getCookies();
	        
	        // 쿠키에서 JWT_TOKEN 찾기
	        if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                if ("JWT_TOKEN".equals(cookie.getName())) {
	                    token = cookie.getValue();
	                    break; // 토큰을 찾으면 반복 종료
	                }
	            }
	        } else {
	            String authorizationHeader = request.getHeader("Authorization");
	            
	            if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
	                token = authorizationHeader.substring(7); // "Bearer " 부분 제거
	            }
	        }
	        
	        // JWT 토큰이 존재하는 경우
	        if (token != null) {
	            UserDetails userDetails = null;
	            String username1 = jwtUtil.extractUsername(token); // JWT에서 사용자 이름 추출
	            
	            if (username1 == null) {
	                username1 = jwtUtil.extractKakaoId(token); // JWT에서 카카오 ID 추출
	            }

	            try {
	                userDetails = userDetailsService.loadUserByUsername(username1);
	            } catch (UsernameNotFoundException e) {
	                // 사용자 이름으로 찾지 못했을 경우 카카오 ID로 조회
	                userDetails = userDetailsService.loadUserByKakaoId(username1);
	            }

	            // 사용자 정보가 있는 경우 반환
	            if (userDetails != null) {
	                return new AuthRequest(userDetails.getUsername(), ""); // 패스워드는 빈 문자열로 설정
	            } else {
	                // 사용자 없음 - 추가 정보 입력 요청
	                System.out.println("사용자 없음: " + username1);
	                response.sendRedirect("/userinfo");
	                return new AuthRequest(username1, ""); // 빈 AuthRequest 반환
	            }
	        } else {
	            // 토큰이 없으면 카카오 로그인 페이지로 리다이렉트
	            response.sendRedirect("/confirm-kakao-insert"); // 카카오 로그인 페이지로 리다이렉트
	            return new AuthRequest("", ""); // 빈 AuthRequest 반환
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
	            boolean kakaoinsert = userDetailsService.InsertkakaoInfo(uniqueId,username,"",name,email,phone_number,gender,birthDate);
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
	    public String logout(HttpServletRequest request, HttpServletResponse response) {
	        // 쿠키에서 JWT 토큰 제거
	        Cookie[] cookies = request.getCookies();
	        if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                if ("JWT_TOKEN".equals(cookie.getName())) {
	                    cookie.setValue(null);
	                    cookie.setMaxAge(0); // 쿠키 만료
	                    cookie.setPath("/"); // 모든 경로에서 유효하도록 설정
	                    response.addCookie(cookie);
	                    System.out.println("JWT 토큰 쿠키 제거됨");
	                    break;
	                }
	            }
	        }

	        // 세션이 있다면 세션도 무효화
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
	    public String changePassword(@RequestParam String email,
                @RequestParam String newPassword,
                @RequestParam String confirmPassword,
                Model model) {
					if (!newPassword.equals(confirmPassword)) {
					model.addAttribute("error", "새 비밀번호와 비밀번호 확인이 일치하지 않습니다.");
					return "passwordChangeForm";
					}
					
					userDetailsService.updatePassword(email, newPassword);
					return "redirect:/login";
					}

	    

	
	    
	    
	}
