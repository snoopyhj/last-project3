package com.example.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.web.OAuth2LoginAuthenticationFilter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;

@Configuration
public class SecurityConfig {

    private final JwtAuthFilter jwtAuthFilter;
    private final RequestCache requestCache;

    public SecurityConfig(JwtAuthFilter jwtAuthFilter) {
        this.jwtAuthFilter = jwtAuthFilter;
        this.requestCache = new HttpSessionRequestCache();  // 생성자에서 RequestCache를 초기화
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())  // CSRF 비활성화
            .authorizeHttpRequests(auth -> auth
            		.requestMatchers("/login", "/oauth2/success", "/error", "/success", "/regionfilter", "/css/**", 
                            "/userinfo", "/confirm-kakao-insert", "/register", "/insert_member", 
                            "/check-duplicate", "/send-email", "/verify-code", "/find-id/email", 
                            "/idview", "/get-found-id", "/change-pw/email", "/password/change", 
                            "/changepw", "/password/check", "/naver/success", "/validate-token","https://localhost:8443/**","/image/**").permitAll()  // 여기서 인증 필요 없음
                .requestMatchers("/", "/validate-token").permitAll()  // 로그인 없이 접근 허용
                .anyRequest().authenticated()  // 나머지 요청은 인증 필요
            )
            .oauth2Login(oauth -> oauth
                .loginPage("/login")  // 사용자 정의 로그인 페이지
                .defaultSuccessUrl("/")  // 로그인 성공 후 리디렉션 URL
                .failureHandler((request, response, exception) -> {  // 로그인 실패 핸들러
                    System.out.println("카카오 OAuth2 로그인 실패: " + exception.getMessage());
                    response.sendRedirect("/login?error=true");  // 실패 시 리디렉션
                })
            )
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)  // 세션 정책
            )
//            .requiresChannel(channel -> channel
//                .anyRequest().requiresSecure()  // 모든 요청에 대해 HTTPS 강제
//            )
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)  // JWT 필터를 UsernamePassword 필터 앞에 추가
            .addFilterAfter(jwtAuthFilter, OAuth2LoginAuthenticationFilter.class);  // OAuth2 필터 이후에 JWT 필터 추가

        return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();  // BCrypt 비밀번호 인코더
    }
}
