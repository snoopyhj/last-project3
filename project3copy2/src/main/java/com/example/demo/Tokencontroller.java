package com.example.demo;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;

@RestController
public class Tokencontroller {

    // JWT 토큰을 가져오는 API
    @GetMapping(value = "/get-jwt", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ValidationResponse> getJwtTokenFromServer(HttpServletRequest request) {
        // 쿠키에서 JWT_TOKEN 검색
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("JWT_TOKEN".equals(cookie.getName())) {
                    String token = cookie.getValue();
                    System.out.println("JWT Token: " + token);
                    // 토큰이 존재하면 유효하다고 응답
                    return ResponseEntity.ok(new ValidationResponse(true, "토큰이 유효합니다.", token));
                }
            }
        }
        // 토큰이 없을 경우 404 상태 코드로 응답
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                             .body(new ValidationResponse(false, "토큰이 없습니다.", null));
    }

    // ValidationResponse 클래스를 static으로 선언
    public static class ValidationResponse {
        private boolean isValid;
        private String message;
        private String token;

        // 생성자
        public ValidationResponse(boolean isValid, String message, String token) {
            this.isValid = isValid;
            this.message = message;
            this.token = token;
        }

        // Getter 메서드
        public boolean isValid() {
            return isValid;
        }

        public String getMessage() {
            return message;
        }

        public String getToken() {
            return token;
        }

        // Setter 메서드 (필요에 따라 추가)
        public void setValid(boolean isValid) {
            this.isValid = isValid;
        }

        public void setMessage(String message) {
            this.message = message;
        }

        public void setToken(String token) {
            this.token = token;
        }
    }
}
