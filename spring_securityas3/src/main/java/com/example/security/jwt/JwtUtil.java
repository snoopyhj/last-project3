package com.example.security.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.core.io.ClassPathResource;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import java.io.FileInputStream;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Component
public class JwtUtil {

    private final PrivateKey privateKey;

    public JwtUtil() {
        this.privateKey = loadPrivateKey();
    }

    private PrivateKey loadPrivateKey() {
        try {
            KeyStore keyStore = KeyStore.getInstance("JKS");
            try (FileInputStream keyStoreInputStream = new FileInputStream(new ClassPathResource("static/config/keystore.jks").getFile())) {
                keyStore.load(keyStoreInputStream, "050924".toCharArray());
                return (PrivateKey) keyStore.getKey("jwt_key_alias", "050924".toCharArray());
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to load private key", e);
        }
    }

    public String extractUserUUID(String token) {
        return extractClaim(token, Claims::getSubject);
    }
 // JWT에서 Kakao ID 추출
    public String extractKakaoId(String token) {
        return extractClaim(token, claims -> claims.get("kakaoId", String.class));
    }

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return (claims != null) ? claimsResolver.apply(claims) : null;
    }

    private Claims extractAllClaims(String token) {
        try {
            return Jwts.parserBuilder()
                    .setSigningKey(privateKey)
                    .setAllowedClockSkewSeconds(60)  // 5초 허용 오차
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        }catch (ExpiredJwtException e) {
            System.out.println("JWT 토큰이 만료되었습니다.");
            throw e;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Boolean isTokenExpired(String token) {
        try {
            Date expiration = extractExpiration(token);
            return expiration != null && expiration.before(new Date());
        } catch (ExpiredJwtException e) {
            System.out.println("Token has expired: " + e.getMessage());
            return true;
        }
    }

    public String generateToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("roles", userDetails.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .collect(Collectors.toList()));
        return createToken(claims, userDetails.getUsername());
    }

    public String generateRefreshToken(String uuid) {
        Map<String, Object> claims = new HashMap<>();
        return createRefreshToken(claims, uuid);
    }

    public String createToken(Map<String, Object> claims, String username) {
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(username)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60))
                .signWith(privateKey, SignatureAlgorithm.RS256)
                .compact();
    }

    public String createRefreshToken(Map<String, Object> claims, String userUUID) {
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(userUUID)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + 1000L * 60 * 60 * 24 * 30))
                .signWith(privateKey, SignatureAlgorithm.RS256)
                .compact();
    }

    public Boolean validateToken(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return (username != null && username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }

    public Boolean validateRefreshToken(String token, String userUUID) {
        final String tokenUserUUID = extractUserUUID(token);
        return (tokenUserUUID != null && tokenUserUUID.equals(userUUID) && !isTokenExpired(token));
    }

    public String refreshAccessToken(String refreshToken, UserDetails userDetails) {
        if (validateRefreshToken(refreshToken, userDetails.getUsername())) {
            return generateToken(userDetails);
        }
        throw new RuntimeException("Invalid refresh token");
    }
}
