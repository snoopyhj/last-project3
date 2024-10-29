package com.example.security;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class KakaoUserInfo {
    private String id; // 사용자 ID
    private String nickname; // 사용자 닉네임
    private String email; // 사용자 이메일

    // 필요한 다른 필드 추가 가능
}