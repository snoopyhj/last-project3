	package com.example.security.controller;
	
	import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.Principal;
import java.sql.Date;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

import jakarta.servlet.http.Cookie;
	import jakarta.servlet.http.HttpServletRequest;
	import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
	import org.springframework.context.annotation.Lazy;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
	import org.springframework.security.core.userdetails.UsernameNotFoundException;
	import org.springframework.stereotype.Controller;
	import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
	import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
	import org.springframework.web.bind.annotation.ResponseBody;

import com.example.security.dao.LoginDAOImpl;
import com.example.security.dao.RefreshTokenRepository;
import com.example.security.jwt.JwtUtil;
import com.example.security.service.CustomUserDetailsService;
import com.example.security.vo.AuthRequest;
import com.example.security.vo.HotelReview;
import com.example.security.vo.ReservationVO;
import com.example.security.vo.UserDto;
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


	
	    @GetMapping("/login")
	    public String loginPage(HttpServletRequest request, HttpServletResponse response) {
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
	        if(token!=null) {
	        	return "redirect:https://localhost:8444/";
	        }
	        return "login/login"; // login.html 페이지를 반환
	    }
	    
	    
	    
	    
	    @GetMapping("/userinfo")
	    @ResponseBody
	    public AuthRequest getUserInfo(
	            @RequestParam(required = false) String token,
	            HttpServletRequest request, HttpServletResponse response) throws IOException {


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

	    @GetMapping("/reservationlist")
	    public String reservationlist( HttpServletRequest request,Model model,HttpSession session) {
	    	String token=null; 
	    
	    	Cookie[] cookies = request.getCookies();
	        if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                if ("JWT_TOKEN".equals(cookie.getName())) {
	                    token = cookie.getValue();
	                    break;
	                }
	            
	        }
	        }
	        String username=null;
	        if (token != null && !jwtUtil.isTokenExpired(token)) {
	            username = jwtUtil.extractUsername(token);
	            if(username==null) {
	            	username = jwtUtil.extractKakaoId(token);
	            }
	        }
	        List<ReservationVO> relist=dao.findReservationById(username);
	        
	        model.addAttribute("relist", relist);
	        return "mypage/reservationlist";
	    }

	    @GetMapping("/confirm-kakao-insert")
	    public String confirmKakaoInsert(Model model,HttpSession session) {

	    	
	        return "login/confirm-kakao-insert"; // 삽입 여부를 물어보는 HTML 페이지
	    }

	    @PostMapping("/confirm-kakao-insert")
	    public String handleKakaoInsert(@RequestParam(required = false) boolean confirm, HttpServletResponse response,HttpSession session) throws IOException {
	    	UserDto userData = (UserDto) session.getAttribute("userData");
	    	String uniqueId = UUID.randomUUID().toString();
	    	String address=userData.getShippingAddress();
	    	if(address==null) {
	    		address="임시 주소";
	    	}

	        
	        if (confirm) {
	            // 사용자가 삽입을 허용했을 경우 카카오 정보를 삽입
	            boolean kakaoinsert = userDetailsService.InsertkakaoInfo(uniqueId,userData.getKakaoId(),"cozypick",userData.getName(),userData.getEmail(),userData.getPhoneNumber(),userData.getGenderInKorean(),userData.getBirthDate() != null ? userData.getBirthDate().toString() : null,address);
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

	                }
	            }
	        }

	        // 세션이 있다면 세션 무효화
	        request.getSession().invalidate();

	        // 로그아웃 후 로그인 페이지로 리다이렉트
	        return "redirect:/login";
	    }
	    
	    // 기타 요청 처리 메소드들
	
	    
	    @RequestMapping("/register")
	    public String registerform() {
	        return "login/register";
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
		    boolean kakaoinsert1 = dao.insert_memberdashboard(req.getParameter("id"),
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
		    		
            if (kakaoinsert||kakaoinsert1) {
            	
                // 삽입 성공 시 로그인 페이지로 리다이렉트
                response.sendRedirect("/login");
                return null;
            }
         else {
            // 사용자가 삽입을 허용하지 않았을 경우 메시지를 출력하거나 다른 처리
        }
			return "redirect:login";
		}
	    @GetMapping("/find-id/email")
	    public String findidemailget() {
	    	return "login/findidemail";
	    }
	    @GetMapping("/change-pw/email")
	    public String changepwemailget() {
	        return "login/changepwemail";
	    }

	    @GetMapping("/password/check")
	    public String changepw() {
	        return "login/changepw";
	    }
	    
	    @GetMapping("/idview")
	    public String idView(@RequestParam("id") String id, Model model) {
	        model.addAttribute("foundId", id);  // ID를 모델에 추가하여 View로 전달
	        return "login/idview";  // ID를 표시할 뷰 이름 반환
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
					userDetailsService.updatePassword(email, newPassword);
					return "redirect:/login";
}
	    // API to retrieve user info
	    @GetMapping("/api/user-info")
	    @ResponseBody
	    public AuthRequest getUserInfo(HttpServletRequest request) {
	        // JWT 토큰을 추출
	        String token = extractTokenFromRequest(request);

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
	                    userDetails = userDetailsService.loadUserByKakaoId(username);
	                } catch (UsernameNotFoundException ex) {
	                    // 카카오 ID로도 찾지 못한 경우 처리
	                    System.err.println("Kakao ID not found: " + username);
	                    return null; // 사용자 정보를 찾지 못한 경우 null 반환
	                }
	            }
	            if (userDetails != null) {

	                // 사용자 정보(UserInfo) 조회
	                try {
	                    userInfo = dao.getUserInfoByUsername(username);  // 일반 사용자 정보 조회
	                } catch (Exception e) {
	                    System.err.println("Error fetching user info by username: " + e.getMessage());
	                }

	                // 카카오 사용자 정보 조회
	                if (userInfo == null) {
	                    try {
	                        userInfo = dao.getUserInfoByUsernamekakao(username);  // 카카오 사용자 정보 조회
	                    } catch (Exception e) {
	                        System.err.println("Error fetching Kakao user info: " + e.getMessage());
	                        return null;  // 사용자 정보를 찾지 못하면 null 반환
	                    }
	                }

	                if (userInfo != null) {
	                	
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
	    	
	    	return "mypage/mypage";
	    }
	    @GetMapping("/MyInformation")
	    public String MyInformation() {
	    	return "mypage/MyInformation";
	    }
	    @GetMapping("/leave")
	    public String leave() {
	    	return "mypage/leave";
	    }
	    @GetMapping("/setting")
	    public String setting() {
	    	return "mypage/set";
	    }
	    @GetMapping("/reviews")
	    public ResponseEntity<List<HotelReview>> getReviews(HttpServletRequest request) {
	        
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

	        if (token == null || jwtUtil.isTokenExpired(token)) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
	        }
	        
	        String username = jwtUtil.extractUsername(token);
	        if (username == null) {
	            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
	        }

	        List<HotelReview> reviews = dao.getReviewsByUserId(username);
	        
	        for (HotelReview review : reviews) {
	            String hotelName = dao.getHotelNameByDefaultNum(review.getDefaultNum());
	            review.setHotelName(hotelName); // HotelReview에 hotelName 필드 추가 필요
	        }

	        return ResponseEntity.ok(reviews);
	    }
	    @DeleteMapping("/delete_review/{reviewId}")
	    public ResponseEntity<Void> deleteReview(@PathVariable int reviewId) {
	        boolean isDeleted = dao.deleteReviewById(reviewId); // DAO에 삭제 메서드 구현 필요

	        if (isDeleted) {
	            return ResponseEntity.ok().build();
	        } else {
	            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
	        }
	    }
 

	}
