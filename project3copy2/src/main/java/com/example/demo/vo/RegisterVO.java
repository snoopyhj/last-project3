package com.example.demo.vo;

import lombok.Data;

@Data
public class RegisterVO {
	private String id;
	private String pwd;
	private String name;
	private String birthday;
	private String tel;
	private String address;
    private String signupRoutesString;
    private String gender;
}
