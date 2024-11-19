package com.example.security.vo;

import java.time.LocalDate;

import lombok.Data;



@Data
public class UserDto {
    
	private String kakaoId;
    private String email;
    private String name;
    private String nickname;
    private String phoneNumber;
    private String genderInKorean;
    private LocalDate birthDate;
    private String shippingAddress;

    public String getKakaoId() {
		return kakaoId;
	}

	public void setKakaoId(String kakaoId) {
		this.kakaoId = kakaoId;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public String getGenderInKorean() {
		return genderInKorean;
	}

	public void setGenderInKorean(String genderInKorean) {
		this.genderInKorean = genderInKorean;
	}

	public LocalDate getBirthDate() {
		return birthDate;
	}

	public void setBirthDate(LocalDate birthDate) {
		this.birthDate = birthDate;
	}

	public String getShippingAddress() {
		return shippingAddress;
	}

	public void setShippingAddress(String shippingAddress) {
		this.shippingAddress = shippingAddress;
	}

	// Constructor, Getters, Setters, toString() 추가
    public UserDto(String kakaoId2, String email2, String name2, String nickname2, String phone_number,
			String genderInKorean2, LocalDate birthDate2, String baseAddress) {
		this.kakaoId=kakaoId2;
		this.email=email2;
		this.name=name2;
		this.nickname=nickname2;
		this.phoneNumber=phone_number;
		this.genderInKorean=genderInKorean2;
		this.birthDate=birthDate2;
		this.shippingAddress=baseAddress;
		
	}
}

