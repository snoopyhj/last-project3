CREATE TABLE refresh_tokens (
    id VARCHAR2(36) PRIMARY KEY, -- UUID나 다른 문자열 ID 사용 시
    token VARCHAR2(512) NOT NULL,
    username VARCHAR2(100) NOT NULL,
    issued_at TIMESTAMP NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    CONSTRAINT unique_username UNIQUE (username)  -- 사용자당 하나의 리프레시 토큰 제한
);