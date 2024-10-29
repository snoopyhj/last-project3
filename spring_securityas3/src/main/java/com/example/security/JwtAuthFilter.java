package com.example.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Lazy;
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

@Component
public class JwtAuthFilter extends OncePerRequestFilter {

    private final JwtUtil jwtUtil;
    private final CustomUserDetailsService userDetailsService;

    public JwtAuthFilter(JwtUtil jwtUtil, @Lazy CustomUserDetailsService userDetailsService) {
        this.jwtUtil = jwtUtil;
        this.userDetailsService = userDetailsService;
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) throws ServletException {
        // validate-token 경로에 대해 필터링을 제외
        String path = request.getRequestURI();
        System.out.println("Requested Path in shouldNotFilter: " + path);
        return path.equals("/validate-token");
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        System.out.println("JWT 필터 시작");  // 필터 시작 로그

        // Authorization 헤더에서 JWT를 추출
        final String authHeader = request.getHeader("Authorization");
        System.out.println("Authorization 헤더: " + authHeader);

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            System.out.println("Authorization 헤더가 없거나 잘못되었습니다.");
            filterChain.doFilter(request, response);
            return;
        }

        final String jwt = authHeader.substring(7);  // "Bearer " 제거
        final String username = jwtUtil.extractUsername(jwt);  // JWT에서 사용자 이름 추출
        System.out.println("JWT에서 추출된 사용자 이름: " + username);

        // SecurityContext에 인증 정보가 없는 경우 인증 진행
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            System.out.println("SecurityContext에 인증 정보가 없습니다. 인증 진행 중...");

            UserDetails userDetails = null;
            try {
                // 사용자 정보 로드 (Username으로)
                userDetails = userDetailsService.loadUserByUsername(username);
            } catch (UsernameNotFoundException e) {
                System.out.println("사용자 이름으로 사용자 정보를 찾을 수 없습니다: " + username);
            }

            // Kakao ID로도 사용자 정보를 찾지 못하면 인증 실패 처리
            if (userDetails == null) {
                System.out.println("Kakao ID로 사용자 정보 로드 중...");
                userDetails = userDetailsService.loadUserByKakaoId(username);
            }

            // JWT 토큰 유효성 검증
            if (userDetails != null && jwtUtil.validateToken(jwt, userDetails)) {
                System.out.println("JWT 토큰 유효성 검증 성공");
                UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());
                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authToken);
            } else {
                System.out.println("JWT 토큰 유효성 검증 실패");
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
                return;
            }
        }

        // 다음 필터로 요청 전달
        filterChain.doFilter(request, response);
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
