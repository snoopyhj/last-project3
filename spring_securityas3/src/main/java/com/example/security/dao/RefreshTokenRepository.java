package com.example.security.dao;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.security.vo.RefreshToken;

import jakarta.transaction.Transactional;

import java.util.Optional;

public interface RefreshTokenRepository extends JpaRepository<RefreshToken, String> {

    // 사용자명으로 리프레시 토큰 검색
    Optional<RefreshToken> findByUsername(String username);
    Optional<RefreshToken> findById(String Id);

    // 토큰으로 리프레시 토큰 검색
    Optional<RefreshToken> findByToken(String token);
 
    // 사용자명으로 리프레시 토큰 삭제
    @Transactional
    void deleteByUsername(String username);
}
