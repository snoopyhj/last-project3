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
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/login", "/oauth2/success", "/error", "/success", "/regionfilter", "/css/**","/userinfo","/confirm-kakao-insert","/register","/insert_member","/check-duplicate","/send-email","/verify-code","http://localhost:8084/**","/find-id/email","/idview","/get-found-id","/change-pw/email","/password/change","/changepw","/password/check").permitAll()  // 카카오 성공 URL 허용
                .requestMatchers("/").permitAll()  // 로그인 안 해도 접근 가능
                .anyRequest().authenticated()  // 나머지 요청은 인증 필요
            )
            .oauth2Login(oauth -> oauth
                .loginPage("/login")
                .defaultSuccessUrl("/")
                .failureHandler((request, response, exception) -> { // 실패 핸들러
                    System.out.println("카카오 OAuth2 로그인 실패: " + exception.getMessage());
                    response.sendRedirect("/login?error=true");
                })
            )
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
            )
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
            .addFilterAfter(jwtAuthFilter, OAuth2LoginAuthenticationFilter.class);

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
}
