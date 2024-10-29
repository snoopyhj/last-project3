package com.example.demo;

import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;

import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.HostnameVerifier;
import java.security.cert.X509Certificate;
import java.security.NoSuchAlgorithmException;
import java.security.KeyManagementException;

@Component
public class JwtTokenValidator {

    private final RestTemplate restTemplate;
    private final String VALIDATE_TOKEN_URL = "http://localhost:8443/validate-token";  // 토큰 검증 엔드포인트

    public JwtTokenValidator() {
        this.restTemplate = getRestTemplateWithDisabledSSLValidation();
    }

    // SSL 검증을 비활성화한 RestTemplate 생성
    private RestTemplate getRestTemplateWithDisabledSSLValidation() {
        try {
            // SSLContext 생성 (모든 인증서 신뢰 설정)
            SSLContext sslContext = SSLContext.getInstance("TLS");
            sslContext.init(null, new TrustManager[]{new X509TrustManager() {
                public X509Certificate[] getAcceptedIssuers() { return null; }
                public void checkClientTrusted(X509Certificate[] certs, String authType) { }
                public void checkServerTrusted(X509Certificate[] certs, String authType) { }
            }}, new java.security.SecureRandom());

            // 모든 호스트 이름을 신뢰하도록 설정
            HttpsURLConnection.setDefaultSSLSocketFactory(sslContext.getSocketFactory());
            HttpsURLConnection.setDefaultHostnameVerifier((hostname, session) -> true);

            return new RestTemplate();
        } catch (NoSuchAlgorithmException | KeyManagementException e) {
            throw new RuntimeException("SSL 설정 중 오류 발생", e);
        }
    }

    // JWT 토큰을 검증하는 메소드
    public boolean validateToken(String token) {
        try {
        	System.out.println("JWT 토큰을 검증하는 메소드 : "+token);
            // 요청 헤더 설정 (Authorization 헤더에 JWT 토큰 설정)
            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + token);

            // HTTP GET 요청
            HttpEntity<String> entity = new HttpEntity<>(headers);
            System.out.println("entity : "+entity);
            ResponseEntity<ValidationResponse> response = restTemplate.exchange(
                VALIDATE_TOKEN_URL, HttpMethod.GET, entity, ValidationResponse.class
            );
            System.out.println("sadasdasdsa1 : "+response);
            // 응답이 200 OK이면 토큰 유효
            return response.getStatusCode().is2xxSuccessful() && response.getBody() != null && response.getBody().isValid();
        } catch (Exception e) {
            // 예외 처리
            e.printStackTrace();
            return false;
        }
    }

    // 토큰 유효성 검증 응답 클래스
    public static class ValidationResponse {
        private boolean valid;
        private String message;

        public boolean isValid() {
            return valid;
        }

        public String getMessage() {
            return message;
        }
    }
}
