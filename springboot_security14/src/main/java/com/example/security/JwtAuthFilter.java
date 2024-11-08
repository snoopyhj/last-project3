package com.example.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Lazy;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseCookie;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.IOException;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.util.WebUtils;

@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final CustomUserDetailsService userDetailsService;
    private final RefreshTokenService refreshTokenService;

    public JwtAuthFilter(JwtUtil jwtUtil, @Lazy CustomUserDetailsService userDetailsService, RefreshTokenService refreshTokenService) {
        this.jwtUtil = jwtUtil;
        this.userDetailsService = userDetailsService;
        this.refreshTokenService = refreshTokenService;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        String path = request.getRequestURI();
        System.out.println("Requested Path in shouldNotFilter: " + path);
        return path.equals("/refresh-token") || path.equals("/validate-token") || path.equals("/WEB-INF/views/**"); 
    }


    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        System.out.println("JWT 필터 시작");
        UserDetails userDetails = null;

        try {
            Cookie jwtCookie = WebUtils.getCookie(request, "JWT_TOKEN");
            String jwt = (jwtCookie != null) ? jwtCookie.getValue() : null;

            // rememberMe 쿠키 확인
            Cookie rememberMeCookie = WebUtils.getCookie(request, "rememberMe");
            boolean rememberMe = (rememberMeCookie != null && "true".equalsIgnoreCase(rememberMeCookie.getValue()));

            if (jwt == null || jwtUtil.isTokenExpired(jwt)) {
                System.out.println("JWT 쿠키가 없거나 JWT 토큰이 만료되었습니다. 리프레시 토큰 확인 중...");

                // rememberMe가 true인 경우에만 리프레시 토큰을 통한 재발급을 시도
                if (rememberMe) {
                    String userUUID = retrieveRefreshTokenUUID(request);
                    if (userUUID != null && refreshTokenService.isValidRefreshToken(userUUID)) {
                        String username = refreshTokenService.getUsernameByUUID(userUUID);
                        System.out.println("유효한 리프레시 토큰 확인됨. 새로운 JWT 토큰 생성 중...");

                        String newJwt = jwtUtil.generateToken(userDetailsService.loadUserByUsername(username));
                        ResponseCookie newAccessTokenCookie = ResponseCookie.from("JWT_TOKEN", newJwt)
                                .httpOnly(true)
                                .path("/")
                                .maxAge(60)  // 1시간 유효
                                .secure(true)
                                .build();

                        response.addHeader(HttpHeaders.SET_COOKIE, newAccessTokenCookie.toString());
                        System.out.println("새 JWT 토큰 생성 및 설정 완료");

                        jwt = newJwt;
                    } else {
                        System.out.println("리프레시 토큰이 유효하지 않거나 만료되었습니다. 권한 없음으로 간주");
                        // 클라이언트로 오류 응답을 반환하지 않고 로그만 남기고 넘어감
                    }
                } else {
                    System.out.println("rememberMe가 false이므로 리프레시 토큰으로 재발급하지 않습니다.");
                    // 클라이언트로 오류 응답을 반환하지 않고 로그만 남기고 넘어감
                }
            }

            String username = jwtUtil.extractUsername(jwt);
            if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                System.out.println("SecurityContext에 인증 정보가 없습니다. 인증 진행 중...");

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
	                    
	                }
	            }

                if (userDetails != null && jwtUtil.validateToken(jwt, userDetails)) {
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            userDetails, null, userDetails.getAuthorities());
                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                } else {
                    System.out.println("JWT 토큰 유효성 검증 실패. 권한 없음으로 간주");
                    // 클라이언트로 오류 응답을 반환하지 않고 로그만 남기고 넘어감
                }
            }
        } catch (Exception e) {
            System.out.println("필터 처리 중 예외 발생: " + e.getMessage());
            e.printStackTrace();
            // 클라이언트로 오류 응답을 반환하지 않고 로그만 남기고 넘어감
        }

        // 오류 여부와 상관없이 다음 필터로 요청 전달
        filterChain.doFilter(request, response);
    }




    // 리프레시 토큰 UUID를 쿠키에서 가져오는 메서드
    private String retrieveRefreshTokenUUID(HttpServletRequest request) {
        Cookie refreshTokenCookie = WebUtils.getCookie(request, "userUUID");
        return refreshTokenCookie != null ? refreshTokenCookie.getValue() : null;
    }




    

    // 사용자 세부 정보를 로드하는 메소드
    private UserDetails loadUserDetails(String username) {
        UserDetails userDetails = null;
        try {
            userDetails = userDetailsService.loadUserByUsername(username);
        } catch (UsernameNotFoundException e) {
            System.out.println("사용자 이름으로 찾지 못했습니다. 카카오 ID로 로드 중...");
            userDetails = userDetailsService.loadUserByKakaoId(username);
        }
        return userDetails;
    }



    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/**")
                        .allowedOrigins("*")
                        .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                        .allowedHeaders("Authorization", "Content-Type");
            }
        };
    }
}

