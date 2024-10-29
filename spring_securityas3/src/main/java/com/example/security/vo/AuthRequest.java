package com.example.security.vo;

import java.sql.Date;
import java.time.LocalDate;
import java.util.Collection;
import org.springframework.security.core.GrantedAuthority;

public class AuthRequest {
    private String username; // id 컬럼과 매핑
    private String password; // pw 컬럼과 매핑
    private String kakaoid; // pw 컬럼과 매핑
    private String name;
	private String tel;
	private String address;
    private String signupRoutesString;
    private String gender;
    private Collection<? extends GrantedAuthority> authorities; // 권한
    private LocalDate formattedDateTime;

    // 기본 생성자
    public AuthRequest() {}

    public LocalDate getFormattedDateTime() {
		return formattedDateTime;
	}

	public void setFormattedDateTime(LocalDate string) {
		this.formattedDateTime = string;
	}

	// 모든 필드를 받는 생성자
    public AuthRequest(String username, String password, String kakaoid, Collection<? extends GrantedAuthority> authorities,String name,String tel,String address,String signupRoutesString,String gender,LocalDate formattedDateTime) {
        this.username = username;
        this.password = password;
        this.kakaoid = kakaoid;
        this.authorities = authorities; // 추가된 필드 초기화
        this.name=name;
        this.tel=tel;
        this.address=address;
        this.signupRoutesString=signupRoutesString;
        this.gender=gender;
        this.formattedDateTime=formattedDateTime;
        		
    }

    public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getSignupRoutesString() {
		return signupRoutesString;
	}

	public void setSignupRoutesString(String signupRoutesString) {
		this.signupRoutesString = signupRoutesString;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	// 사용자 이름과 비밀번호만 받는 생성자 추가
    public AuthRequest(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    public void setAuthorities(Collection<? extends GrantedAuthority> authorities) {
        this.authorities = authorities;
    }

    public String getKakaoid() {
        return kakaoid;
    }

    public void setKakaoid(String kakaoid) {
        this.kakaoid = kakaoid;
    }

    // Getter와 Setter
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    @Override
    public String toString() {
        return "AuthRequest{" +
                "username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", kakaoid='" + kakaoid + '\'' +
                '}';
    }
}
