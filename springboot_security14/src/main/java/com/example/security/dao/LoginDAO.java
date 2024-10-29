package com.example.security.dao;

import java.sql.Date;
import java.time.LocalDate;

import com.example.security.vo.AuthRequest;

public interface LoginDAO {
    AuthRequest LoginInfo(String username);
    AuthRequest kakaoLoginInfo(String username);
    boolean InsertkakaoInfo(String id,String username,String password,String name,String email,String phone_number,String gender,String birthDate);
    boolean insert_member(String id, String pwd, String name, String tel, String address,String signupRoutesString, String gender,Date formattedDateTime,String mail,Date birth);
    LocalDate registration_date(String username);
    String idfind(String mail);
    boolean checkPasswordMatch(String username, String inputPassword);
    boolean updatePassword(String username, String newPassword);
}