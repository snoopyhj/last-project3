package com.example.security.vo;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

//@Getter
//@Setter
@NoArgsConstructor
public class KakaoUserInfo {
    private String id; // 사용자 ID
    private String nickname; // 사용자 닉네임
    private String email; // 사용자 이메일
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}

    // 필요한 다른 필드 추가 가능
}
