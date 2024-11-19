package com.example.security.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import jakarta.servlet.http.HttpSession;
import java.util.Map;

@Service
public class NaverOAuth2Service {

    private static final Logger logger = LoggerFactory.getLogger(NaverOAuth2Service.class);
    
    private final RestTemplate restTemplate;
    private final UserDetailsServiceImpl userDetailsService;

    @Value("${spring.security.oauth2.client.registration.naver.client-id}")
    private String clientId;

    @Value("${spring.security.oauth2.client.registration.naver.redirect-uri}")
    private String redirectUri;

    @Value("${spring.security.oauth2.client.registration.naver.client-secret}")
    private String clientSecret;

    public NaverOAuth2Service(RestTemplate restTemplate, UserDetailsServiceImpl userDetailsService) {
        this.restTemplate = restTemplate;
        this.userDetailsService = userDetailsService;
    }

    // 네이버 로그인 처리
    public UserDetails processNaverLogin(String code, HttpSession session) {
        String accessToken = getAccessToken(code); // 액세스 토큰 요청
        NaverUserInfo naverUserInfo = getNaverUserInfo(accessToken); // 사용자 정보 요청

        if (naverUserInfo == null) {
            throw new RuntimeException("사용자 정보 요청 실패: 사용자 정보를 가져올 수 없습니다.");
        }

        return userDetailsService.loadUserByNaverId(naverUserInfo.getId()); // 사용자 정보 반환
    }

    // 네이버 API로 액세스 토큰 요청
    private String getAccessToken(String code) {
        String tokenUrl = "https://nid.naver.com/oauth2.0/token";
        logger.info("Requesting Access Token from: {}", tokenUrl);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", clientId);
        params.add("redirect_uri", redirectUri);
        params.add("code", code);
        params.add("client_secret", clientSecret);

        // 디버깅 정보 출력
        logger.debug("네이버 액세스 토큰 요청 중... code: {}, clientId: {}, redirectUri: {}, clientSecret: {}", 
                      code, clientId, redirectUri, clientSecret);

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
        ResponseEntity<Map> response = restTemplate.exchange(tokenUrl, HttpMethod.POST, request, Map.class);

        // 상태 코드와 응답 바디 출력
        logger.debug("네이버 응답 상태 코드: {}", response.getStatusCode());
        logger.debug("네이버 응답 바디: {}", response.getBody());

        if (response.getStatusCode() == HttpStatus.OK) {
            Map<String, Object> body = response.getBody();
            return (String) body.get("access_token"); // 액세스 토큰 반환
        } else {
            throw new RuntimeException("네이버 토큰 요청 실패: " + response.getStatusCode());
        }
    }

    // 네이버 사용자 정보 요청
    private NaverUserInfo getNaverUserInfo(String accessToken) {
        String userInfoUrl = "https://openapi.naver.com/v1/nid/me";

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        HttpEntity<String> request = new HttpEntity<>(headers);

        // 디버깅: 액세스 토큰 확인
        logger.debug("네이버 사용자 정보 요청 중... accessToken: {}", accessToken);

        ResponseEntity<NaverUserInfo> response = restTemplate.exchange(userInfoUrl, HttpMethod.GET, request, NaverUserInfo.class);

        // 상태 코드와 응답 바디 출력
        logger.debug("네이버 사용자 정보 응답 상태 코드: {}", response.getStatusCode());
        logger.debug("네이버 사용자 정보 응답 바디: {}", response.getBody());

        if (response.getStatusCode().is2xxSuccessful()) {
            NaverUserInfo userInfo = response.getBody();
            if (userInfo == null) {
                throw new RuntimeException("사용자 정보 요청 실패: null 반환");
            }
            return userInfo; // 사용자 정보 반환
        } else {
            throw new RuntimeException("사용자 정보 요청 실패: " + response.getStatusCode());
        }
    }
    public class NaverUserInfo {
        private String id; // 네이버 사용자 ID
        public String getId() {
			return id;
		}
		public void setId(String id) {
			this.id = id;
		}
		public String getEmail() {
			return email;
		}
		public void setEmail(String email) {
			this.email = email;
		}
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		private String email; // 사용자 이메일
        private String name; // 사용자 이름
        // 추가적인 필드 및 Getter/Setter
    }
}
