package com.example.security.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.security.dao.RefreshTokenRepository;
import com.example.security.jwt.JwtUtil;
import com.example.security.vo.RefreshToken;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Service
public class RefreshTokenService {
    private final JwtUtil jwtUtil = new JwtUtil();

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    @PersistenceContext
    private EntityManager entityManager;

    @Transactional
    public String createRefreshToken(String username, String uuid) {
        String id = UUID.randomUUID().toString();

        // 기존에 유효한 토큰이 있는지 확인
        Optional<RefreshToken> existingTokenOpt = refreshTokenRepository.findByUsername(username);
        if (existingTokenOpt.isPresent()) {
            RefreshToken existingToken = existingTokenOpt.get();

            // 유효 기간이 남아있는 경우 기존 토큰을 재사용
            if (existingToken.getExpiresAt().isAfter(LocalDateTime.now())) {
                return existingToken.getToken();
            } else {
                // 유효 기간이 지난 경우 기존 토큰 삭제
                refreshTokenRepository.delete(existingToken);
            }
        }

        // 새로운 리프레시 토큰 생성
        String refreshToken = jwtUtil.generateRefreshToken(uuid);

        // 새로운 토큰 정보 저장
        RefreshToken token = new RefreshToken(
                id,
                refreshToken,
                username,
                LocalDateTime.now(),
                LocalDateTime.now().plusDays(30)  // 30일 유효
        );
        refreshTokenRepository.save(token);

        return refreshToken;
    }

    public Optional<RefreshToken> findById(String userUUID) {
        return refreshTokenRepository.findById(userUUID);
    }

    public Optional<RefreshToken> findByToken(String token) {
        return refreshTokenRepository.findByToken(token);
    }

    @Transactional
    public void deleteByUsername(String username) {
        try {
            refreshTokenRepository.deleteByUsername(username);
            System.out.println("Refresh token for username " + username + " deleted successfully.");
        } catch (Exception e) {
            System.out.println("Error deleting token for username: " + username);
            e.printStackTrace();
        }
    }

    // UUID로 리프레시 토큰 유효성 검사
    public boolean isValidRefreshToken(String userUUID) {
        Optional<RefreshToken> tokenOpt = findById(userUUID);
        return tokenOpt.isPresent() && tokenOpt.get().getExpiresAt().isAfter(LocalDateTime.now());
    }

    // UUID로 사용자 이름 가져오기
    public String getUsernameByUUID(String userUUID) {
        Optional<RefreshToken> tokenOpt = findById(userUUID);
        return tokenOpt.map(RefreshToken::getUsername).orElse(null);
    }
}
