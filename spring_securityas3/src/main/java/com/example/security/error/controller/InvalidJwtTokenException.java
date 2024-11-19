package com.example.security.error.controller; // 패키지 경로는 실제 프로젝트 구조에 맞게 수정

public class InvalidJwtTokenException extends RuntimeException {
    public InvalidJwtTokenException(String message) {
        super(message);
    }

    public InvalidJwtTokenException(String message, Throwable cause) {
        super(message, cause);
    }
}
