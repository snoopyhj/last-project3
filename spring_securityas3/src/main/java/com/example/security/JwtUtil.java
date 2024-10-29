package com.example.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

import org.springframework.core.io.ClassPathResource;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.io.FileInputStream;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtUtil {

    private final PrivateKey privateKey;

    public JwtUtil() {
        this.privateKey = loadPrivateKey();
    }

    private PrivateKey loadPrivateKey() {
        try {
            // KeyStore 로드
            KeyStore keyStore = KeyStore.getInstance("JKS");
            try (FileInputStream keyStoreInputStream = new FileInputStream(new ClassPathResource("static/config/keystore.jks").getFile())) { // keystore 파일 경로
                keyStore.load(keyStoreInputStream, "050924".toCharArray()); // keystore 비밀번호

                // 비밀 키 가져오기
                return (PrivateKey) keyStore.getKey("jwt_key_alias", "050924".toCharArray()); // alias와 비밀번호
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to load private key", e);
        }
    }

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public String extractKakaoId(String token) {
        return extractClaim(token, claims -> claims.get("kakaoId", String.class));
    }

    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return (claims != null) ? claimsResolver.apply(claims) : null; // null 체크
    }

    private Claims extractAllClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(privateKey) // PrivateKey 사용
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            return null; // 또는 적절한 예외 처리를 하세요
        }
    }

    private Boolean isTokenExpired(String token) {
        Date expiration = extractExpiration(token);
        return expiration != null && expiration.before(new Date());
    }

    public String generateToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        return createToken(claims, userDetails.getUsername());
    }

    public String createToken(Map<String, Object> claims, String subject) {
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 10))  // 10시간 유효
                .signWith(privateKey, SignatureAlgorithm.RS256)  // PrivateKey로 서명
                .compact();
    }

    public Boolean validateToken(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        System.out.println("validateToken username : "+token );
        System.out.println(userDetails.getUsername());
        System.out.println(isTokenExpired(token));
        return (username != null && username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }
}
