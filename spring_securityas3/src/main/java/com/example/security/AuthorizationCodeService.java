package com.example.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

@Service
public class AuthorizationCodeService {

    private static final String REDIS_PREFIX = "auth_code:";
    private static final long CODE_EXPIRATION_MINUTES = 10;  // 인가 코드 만료 시간 (10분)

    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    // 인가 코드를 저장하고 일정 시간 후 만료되도록 설정
    public void storeAuthorizationCode(String code) {
        String key = REDIS_PREFIX + code;
        redisTemplate.opsForValue().set(key, "USED", CODE_EXPIRATION_MINUTES, TimeUnit.MINUTES);
    }

    // 인가 코드가 이미 사용되었는지 확인
    public boolean isCodeUsed(String code) {
        String key = REDIS_PREFIX + code;
        return redisTemplate.hasKey(key);  // 존재하면 이미 사용된 코드
    }
}

