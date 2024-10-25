package com.example.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtUtil {

    // 강력한 256비트 키 생성 (환경 변수에서 읽어오는 예시)
    private final SecretKey SECRET_KEY = Keys.secretKeyFor(SignatureAlgorithm.HS256);

    public String extractUsername(String token) {
    	System.out.println("jwtutil : "+token);
        return extractClaim(token, Claims::getSubject);
    }

    public String extractKakaoId(String token) {
        String kakaoId = extractClaim(token, claims -> claims.get("kakaoId", String.class));
        System.out.println("jwtutil : "+kakaoId);
        return kakaoId != null ? kakaoId : "unknown"; // 기본값으로 "unknown" 반환
    }

    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        if (claims == null) {
            // Claims가 null인 경우의 처리 로직
            System.out.println("Claims could not be extracted. Returning default value.");
            return null; // 또는 적절한 기본값을 반환
        }
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(SECRET_KEY)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            // 예외 처리: 로그 출력 또는 사용자에게 오류 메시지 반환
            //System.err.println("JWT parsing error: " + e.getMessage());
            return null; // 또는 적절한 예외 처리를 하세요
        }
    }

    private Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    public String generateToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        return createToken(claims, userDetails.getUsername());
    }

    public  String createToken(Map<String, Object> claims, String subject) {
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(subject)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60 * 10))  // 10시간 유효
                .signWith(SECRET_KEY)  // 강력한 키로 서명
                .compact();
    }

    public Boolean validateToken(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }
    
}
