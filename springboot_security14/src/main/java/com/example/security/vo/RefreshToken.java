package com.example.security.vo;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "refresh_tokens")
public class RefreshToken {

	 @Id
	private String id;  // UUID를 사용하기 위해 String 타입으로 설정

    @Column(nullable = false, length = 512)
    private String token;

    @Column(nullable = false, length = 100)
    private String username;

    @Column(nullable = false)
    private LocalDateTime issuedAt;

    @Column(nullable = false)
    private LocalDateTime expiresAt;

    // 기본 생성자
    public RefreshToken() {}

    public RefreshToken(String id,String token, String username, LocalDateTime issuedAt, LocalDateTime expiresAt) {
    	this.id=id;
        this.token = token;
        this.username = username;
        this.issuedAt = issuedAt;
        this.expiresAt = expiresAt;
    }

    // Getter 및 Setter
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public LocalDateTime getIssuedAt() {
        return issuedAt;
    }

    public void setIssuedAt(LocalDateTime issuedAt) {
        this.issuedAt = issuedAt;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    // 만료 여부 확인 메서드
    public boolean isExpired() {
        return LocalDateTime.now().isAfter(this.expiresAt);
    }
}
