package com.example.security.config;

import org.apache.catalina.filters.CorsFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.web.OAuth2LoginAuthenticationFilter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import com.example.security.jwt.JwtAuthFilter;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@Configuration
public class SecurityConfig {

    private final JwtAuthFilter jwtAuthFilter;

    public SecurityConfig(JwtAuthFilter jwtAuthFilter) {
        this.jwtAuthFilter = jwtAuthFilter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable)  // CSRF 비활성화
            
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS))  // 세션 비저장 방식 사용
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/refresh-token", "/login", "/oauth2/success", "/error", "/success", "/css/**",
                    "/userinfo", "/confirm-kakao-insert", "/register", "/insert_member", 
                    "/check-duplicate", "/send-email", "/verify-code", "/find-id/email", 
                    "/idview", "/get-found-id", "/change-pw/email", "/password/change", 
                    "/changepw", "/password/check", "/naver/success", "/validate-token", "/image/**", "/api/user-info")
                    .permitAll()  // 인증 불필요 경로
                .requestMatchers("/", "/validate-token", "/refresh-token", "/logout", "/check-email-duplicate").permitAll()
                .requestMatchers("/admin/**").hasRole("ADMIN")  // 관리자 권한만 접근 가능
                .anyRequest().authenticated())  // 그 외 나머지 요청은 인증 필요
            .oauth2Login(oauth -> oauth
                .loginPage("/login")
                .defaultSuccessUrl("/")
                .failureHandler((request, response, exception) -> {
                    System.out.println("OAuth2 로그인 실패: " + exception.getMessage());
                    response.sendRedirect("/login?error=true");
                }))
            .logout(logout -> logout
                .logoutUrl("/custom-logout")
                .logoutSuccessHandler(customLogoutSuccessHandler())
                .permitAll())
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)  // JWT 필터 추가
            .addFilterAfter(jwtAuthFilter, OAuth2LoginAuthenticationFilter.class);  // OAuth2 필터 이후 JWT 필터 추가

        return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    // 커스텀 로그아웃 성공 핸들러
    @Bean
    public LogoutSuccessHandler customLogoutSuccessHandler() {
        return (request, response, authentication) -> {
            // JWT 토큰 쿠키 삭제
            Cookie jwtCookie = new Cookie("JWT_TOKEN", null);
            jwtCookie.setMaxAge(0);  // 쿠키 만료 설정
            jwtCookie.setPath("/");
            jwtCookie.setHttpOnly(true);
            jwtCookie.setSecure(request.isSecure());

            response.addCookie(jwtCookie);
            System.out.println("JWT 토큰 쿠키가 삭제되었습니다.");

            response.sendRedirect("/login?logout");  // 로그아웃 후 리다이렉트
        };
    }

    // CORS 설정 추가
    
    
}
