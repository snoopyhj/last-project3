package com.example.demo;

import com.example.demo.vo.ValidationResponse;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.HandlerInterceptor;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Component
public class TokenInterceptor implements HandlerInterceptor {

    private final RestTemplate restTemplate = new RestTemplate();
    private static final List<String> EXCLUDED_URLS = List.of(
            "/", "/regionfilter", "/api/hotel", "/regionsearch", "/js/*", "/images/*", "/error", 
            "/hoteldetail", "/hoteldetailbytype", "/aboutus", "/question", "/email", 
            "/regionsearch5", "/regionsearch2", "/hotel/data", "/regionsearch3", "/regionsearch2","/payment_success","/getReviews","https://online-payment.kakaopay.com"
    );

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String requestURI = request.getRequestURI();
        Cookie[] cookies = request.getCookies();
        String token = null;
        String userUUID = null;
        boolean rememberMe = false;

        if (cookies != null) {
            for (Cookie cookie : cookies) {
                switch (cookie.getName()) {
                    case "JWT_TOKEN":
                        token = cookie.getValue();
                        break;
                    case "rememberMe":
                        rememberMe = "true".equals(cookie.getValue());
                        break;
                    case "userUUID":
                        userUUID = cookie.getValue();
                        break;
                }
            }
        }

        if (isExcludedUrl(requestURI)) {
            return true;
        }

        if (token != null) {
            try {
                String decodedToken = URLDecoder.decode(token, StandardCharsets.UTF_8);

                HttpHeaders headers = new HttpHeaders();
                headers.setBearerAuth(decodedToken);
                HttpEntity<Void> entity = new HttpEntity<>(headers);

                ResponseEntity<ValidationResponse> authResponse = restTemplate.exchange(
                        "https://localhost:8443/validate-token?token=" + URLEncoder.encode(decodedToken, StandardCharsets.UTF_8),
                        HttpMethod.GET,
                        entity,
                        ValidationResponse.class
                );

                if (authResponse.getBody() != null && authResponse.getBody().isValid()) {
                    return true;
                } else {
                    redirectToErrorPage(response, "유효하지 않은 토큰입니다.");
                    return false;
                }

            } catch (HttpClientErrorException e) {
                if (e.getStatusCode() == HttpStatus.UNAUTHORIZED) {
                    // 토큰이 만료된 경우, 리프레시 시도
                    System.out.println("만료된 토큰, 새 토큰 발급 시도 중");
                    return issueNewToken(request, response, userUUID);
                } else {
                    redirectToErrorPage(response, "유효하지 않은 토큰입니다.");
                    return false;
                }
            }
        } else if (rememberMe && userUUID != null) {
            return issueNewToken(request, response, userUUID);
        } else {
            redirectToErrorPage(response, "토큰이 제공되지 않았습니다.");
            return false;
        }
    }


    private boolean isExcludedUrl(String requestURI) {
        return EXCLUDED_URLS.stream().anyMatch(url -> requestURI.matches(url.replace("*", ".*")));
    }

    private boolean issueNewToken(HttpServletRequest request, HttpServletResponse response, String userUUID) throws IOException {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            String requestBody = "{\"userUUID\":\"" + userUUID + "\"}";
            HttpEntity<String> requestEntity = new HttpEntity<>(requestBody, headers);

            ResponseEntity<String> refreshResponse = restTemplate.exchange(
                    "https://localhost:8443/refresh-token",
                    HttpMethod.POST,
                    requestEntity,
                    String.class
            );

            if (refreshResponse.getStatusCode() == HttpStatus.OK && refreshResponse.getBody() != null) {
                ObjectMapper objectMapper = new ObjectMapper();
                JsonNode jsonResponse = objectMapper.readTree(refreshResponse.getBody());
                String accessToken = jsonResponse.get("accessToken").asText();

                String encodedToken = URLEncoder.encode(accessToken, StandardCharsets.UTF_8);
                Cookie newTokenCookie = new Cookie("JWT_TOKEN", encodedToken);
                newTokenCookie.setHttpOnly(true);
                newTokenCookie.setPath("/");
                newTokenCookie.setSecure(true);
                // 쿠키의 만료 시간 설정 (예: 30분)
                newTokenCookie.setMaxAge(60); // 30분(1800초) 설정
                
                response.addCookie(newTokenCookie);
                response.setHeader("Cache-Control", "no-store"); // 캐싱 방지
                response.setHeader("Pragma", "no-cache");

                request.setAttribute("newToken", accessToken);
                return true;
            } else {
                redirectToErrorPage(response, "리프레시 토큰을 통한 액세스 토큰 발급에 실패했습니다.");
                return false;
            }
        } catch (HttpClientErrorException e) {
            System.out.println("토큰 발급 중 오류: " + e.getMessage());
            redirectToErrorPage(response, "토큰 발급 중 예기치 않은 오류가 발생했습니다.");
            return false;
        }
    }



    private void redirectToErrorPage(HttpServletResponse response, String message) throws IOException {
        response.sendRedirect("https://localhost:8443/login");
        response.getWriter().write(message);
    }
}
