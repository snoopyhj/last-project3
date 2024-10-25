package com.example.security;

import java.security.SecureRandom;
import java.util.Base64;
import java.util.UUID;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class Scretkey {
	public static void main(String[] args) {
		BCryptPasswordEncoder passwordEncoder=new BCryptPasswordEncoder();
		System.out.println(passwordEncoder.encode("서울"));
    }
}
