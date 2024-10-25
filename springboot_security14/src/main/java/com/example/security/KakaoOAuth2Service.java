package com.example.security;

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
import java.util.UUID;

@Service
public class KakaoOAuth2Service {

    private static final Logger logger = LoggerFactory.getLogger(KakaoOAuth2Service.class);
    
    private final RestTemplate restTemplate;
    private final UserDetailsServiceImpl userDetailsService;

    @Value("${spring.security.oauth2.client.registration.kakao.client-id}")
    private String clientId;

    @Value("${spring.security.oauth2.client.registration.kakao.redirect-uri}")
    private String redirectUri;

    @Value("${spring.security.oauth2.client.registration.kakao.client-secret}")
    private String clientSecret;

    public KakaoOAuth2Service(RestTemplate restTemplate, UserDetailsServiceImpl userDetailsService) {
        this.restTemplate = restTemplate;
        this.userDetailsService = userDetailsService;
    }

    // 카카오 로그인 요청 URL 생성
//    public String getKakaoAuthorizationUrl(HttpSession session) {
//        // 랜덤한 state 값 생성
//        String state = UUID.randomUUID().toString();
//        
//        // state 값을 세션에 저장
//        session.setAttribute("kakaoState", state);
//
//        // 카카오 인가 요청 URL 생성
//        String url = String.format(
//        		"https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=%s&redirect_uri=%s&state=%s",
//        	    clientId, redirectUri, state
//        	
//        );
//        System.out.println("url : "+url);
//        System.out.println("state : "+state);
//        
//        logger.debug("카카오 인가 요청 URL: {}", url); // URL 로깅
//        return url; // 인가 요청 URL 반환
//    }

    // 카카오 로그인 처리
    public UserDetails processKakaoLogin(String code, HttpSession session) {
        String accessToken = getAccessToken(code); // 액세스 토큰 요청
        KakaoUserInfo kakaoUserInfo = getKakaoUserInfo(accessToken); // 사용자 정보 요청

        if (kakaoUserInfo == null) {
            throw new RuntimeException("사용자 정보 요청 실패: 사용자 정보를 가져올 수 없습니다.");
        }

        return userDetailsService.loadUserByKakaoId(kakaoUserInfo.getId()); // 사용자 정보 반환
    }


//    // 인가 코드가 없을 경우 리다이렉트하는 메서드 추가
//    public String redirectToKakaoLogin(HttpSession session) {
//        return getKakaoAuthorizationUrl(session); // 기존의 인가 요청 URL 반환
//    }

    // 카카오 API로 액세스 토큰 요청
    private String getAccessToken(String code) {
        String tokenUrl = "https://kauth.kakao.com/oauth/token";
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
        logger.debug("카카오 액세스 토큰 요청 중... code: {}, clientId: {}, redirectUri: {}, clientSecret: {}", 
                      code, clientId, redirectUri, clientSecret);

        HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
        ResponseEntity<Map> response = restTemplate.exchange(tokenUrl, HttpMethod.POST, request, Map.class);

        // 상태 코드와 응답 바디 출력
        logger.debug("카카오 응답 상태 코드: {}", response.getStatusCode());
        logger.debug("카카오 응답 바디: {}", response.getBody());

        if (response.getStatusCode() == HttpStatus.OK) {
            Map<String, Object> body = response.getBody();
            return (String) body.get("access_token"); // 액세스 토큰 반환
        } else {
            throw new RuntimeException("카카오 토큰 요청 실패: " + response.getStatusCode());
        }
    }

    // 카카오 사용자 정보 요청
    private KakaoUserInfo getKakaoUserInfo(String accessToken) {
        String userInfoUrl = "https://kapi.kakao.com/v2/user/me";

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(accessToken);
        HttpEntity<String> request = new HttpEntity<>(headers);

        // 디버깅: 액세스 토큰 확인
        logger.debug("카카오 사용자 정보 요청 중... accessToken: {}", accessToken);

        ResponseEntity<KakaoUserInfo> response = restTemplate.exchange(userInfoUrl, HttpMethod.GET, request, KakaoUserInfo.class);

        // 상태 코드와 응답 바디 출력
        logger.debug("카카오 사용자 정보 응답 상태 코드: {}", response.getStatusCode());
        logger.debug("카카오 사용자 정보 응답 바디: {}", response.getBody());

        if (response.getStatusCode().is2xxSuccessful()) {
            KakaoUserInfo userInfo = response.getBody();
            if (userInfo == null) {
                throw new RuntimeException("사용자 정보 요청 실패: null 반환");
            }
            return userInfo; // 사용자 정보 반환
        } else {
            throw new RuntimeException("사용자 정보 요청 실패: " + response.getStatusCode());
        }
    }
}
