package com.example.security.service;

import java.sql.Date;
import java.time.LocalDate;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;

import com.example.security.vo.AuthRequest;

public interface CustomUserDetailsService extends UserDetailsService {
    UserDetails loadUserByKakaoId(String kakaoId);
    UserDetails loadUserByNaverId(String kakaoId);	
    boolean InsertkakaoInfo(String id,String username,String password,String name,String email,String phone_number,String gender,String birthDate,String shippingAddress);
    boolean insert_member(String id, String password, String name,String tel,String address,String signupRoutesString,String gender,Date formattedDateTime,String mail,Date birth);
    LocalDate registrationDate(String username); 
    String idfind(String mail);
    boolean checkPasswordMatch(String username, String inputPassword);
    boolean updatePassword(String username, String newPassword);
    String mail(String username);
    boolean deleteUser(String mail, String password);
    String uuidfind(String username);
    String idfind2(String id); 
    boolean mailcheck(String mail);
}
