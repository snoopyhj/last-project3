package com.example.security;

import java.sql.Date;
import java.time.LocalDate;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.example.security.dao.LoginDAO;
import com.example.security.vo.AuthRequest;

@Service
public class UserDetailsServiceImpl implements CustomUserDetailsService {

    private final LoginDAO loginDAO;

    public UserDetailsServiceImpl(LoginDAO loginDAO) {
        this.loginDAO = loginDAO; 
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        AuthRequest user = loginDAO.LoginInfo(username);
        System.out.println("아이디 : "+username);
        if (user != null) {
            return User.builder()
                    .username(user.getUsername())
                    .password(user.getPassword())  // DB에서 암호화된 비밀번호 사용
                    .roles("USER")
                    .build();
        } else {
            throw new UsernameNotFoundException("User not found");
        }
    }

    // 카카오 로그인 정보 처리
    @Override
    public UserDetails loadUserByKakaoId(String kakaoId) { 
        AuthRequest kakaoUser = loginDAO.kakaoLoginInfo(kakaoId);
        System.out.println("카카오 : " + kakaoUser);
        if (kakaoUser != null) {
            return User.builder()
                    .username(kakaoUser.getUsername())
                    .password("") // 비밀번호가 없으므로 빈 값
                    .roles("USER")
                    .build();
        } else {
            // 사용자 정보가 없을 경우 null을 반환한 후 추가 작업을 수행
            System.out.println("카카오 유저 정보가 존재하지 않음. 추가 작업을 수행합니다.");

            // 예: 추가 로직 (여기서는 예시로 `logError` 메소드를 호출)
            logError("Kakao user not found. ID: " + kakaoId);

            // 혹은, 해당 메소드에서 계속해서 다른 동작을 수행할 수 있음.
            // 특정 기본값을 반환하거나 추가 로직을 계속 이어감
            performSomeAction();

            return null; // 여전히 null을 반환하지만, 그 후에 코드가 이어질 수 있음.
        }
    }

    // 추가 로직을 처리하는 메소드
    private void logError(String message) {
        // 로그 기록, 예외 처리 등 추가 작업 수행
        System.err.println(message);
    }

    private void performSomeAction() {
        // 카카오 사용자 정보가 없을 때 실행할 다른 작업
        System.out.println("Performing some action after no Kakao user found.");
    }

    @Override
    public boolean InsertkakaoInfo(String id,String username,String password,String name,String email,String phone_number,String gender,String birthDate) {
    	boolean kakaoinsert = loginDAO.InsertkakaoInfo(id,username,password,name,email,phone_number,gender,birthDate);
    	if(kakaoinsert) {
    	System.out.println("잘 삽입됨");
    	return true;
    	}else {
    		System.out.println("삽입 안됨");
    		return false;
    	}
    	
    }
    @Override
    public boolean insert_member(String id, String password, String name,String tel,String address,String signupRoutesString,String gender,Date formattedDateTime,String mail,Date birth) {
    	boolean kakaoinsert = loginDAO.insert_member(id,password,name,tel,address,signupRoutesString,gender,formattedDateTime,mail,birth);
    	if(kakaoinsert) {
    	System.out.println("잘 삽입됨");
    	return true;
    	}else {
    		System.out.println("삽입 안됨");
    		return false;
    	}
    }
    public LocalDate registrationDate(String username) {
    	LocalDate dateTime1 = loginDAO.registration_date(username);
        System.out.println("dateTime1 : " + dateTime1);
        if (dateTime1 != null) {
            return dateTime1; // 반환할 날짜
        } else {
            performSomeAction();
            return null;
        }
    }
    public String idfind(String mail) {
    	String id = loginDAO.idfind(mail); 
        System.out.println("dateTime1 : " + mail);
        if (mail != null) {
            return id; // 반환할 날짜
        } else {
            performSomeAction();
            return null;
        }
    }
    public boolean checkPasswordMatch(String username, String inputPassword) {
    	boolean checkPassword= loginDAO.checkPasswordMatch(username, inputPassword);
    	if(checkPassword) {
    		return true;
    	}
    	else {
    		return false; 
    	}
    }
    public boolean updatePassword(String username, String newPassword) {
    	boolean updatePassword= loginDAO.updatePassword(username, newPassword);
    	if(updatePassword) {
    		return true;
    	}
    	else {
    		return false; 
    	}
    }

    
}
