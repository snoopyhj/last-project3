package com.example.security.dao;

import com.example.security.AESEncryptionUtil;
import com.example.security.vo.AuthRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@Repository
@Primary
public class LoginDAOImpl implements LoginDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @Override
    public AuthRequest LoginInfo(String username) {
        String sql = "SELECT id, pwd FROM MEMBER WHERE id = ?";
        System.out.println("사용자 이름: " + username);
        
        List<AuthRequest> users = jdbcTemplate.query(sql, new Object[]{username}, (rs, rowNum) -> {
            AuthRequest user = new AuthRequest();
            user.setUsername(rs.getString("id"));
            user.setPassword(rs.getString("pwd"));
            return user;
        });
        System.out.println("조회된 사용자1: " + users);
        
        return users.isEmpty() ? null : users.get(0);
    }

    @Override
    public boolean checkPasswordMatch(String email, String inputPassword) {
    	System.out.println("emaildao : "+email);
        String sql = "SELECT pwd FROM MEMBER WHERE mail = ?";
        
        try {
            String storedPassword = jdbcTemplate.queryForObject(sql, new Object[]{email}, String.class);
            
            if (storedPassword == null) {
                return false; // 이메일에 해당하는 사용자가 없으면 false를 반환
            }
            
            return passwordEncoder.matches(inputPassword, storedPassword);
        } catch (DataAccessException e) {
            // 데이터베이스 접근 중 오류가 발생한 경우 로깅 및 처리
            // 예: logger.error("Error checking password for email: " + email, e);
            return false; // 예외 발생 시 false 반환
        }
    }

    @Override
    public boolean updatePassword(String email, String newPassword) {
        String sql = "UPDATE MEMBER SET pwd = ? WHERE mail = ?";
        
        String encodedPassword = passwordEncoder.encode(newPassword);

        try {
            int rowsAffected = jdbcTemplate.update(sql, encodedPassword, email);
            System.out.println("업데이트된 행 수: " + rowsAffected);
            return rowsAffected > 0;
        } catch (DataAccessException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public AuthRequest kakaoLoginInfo(String username) {
        String sql = "SELECT kakaoid AS id, PWD AS pw FROM MEMBER WHERE kakaoid = ?";
        System.out.println("사용자 이름: " + username);

        List<AuthRequest> users = jdbcTemplate.query(sql, new Object[]{username}, (rs, rowNum) -> {
            AuthRequest user = new AuthRequest();
            user.setUsername(rs.getString("id"));
            user.setPassword(rs.getString("pw"));
            return user;
        });
        System.out.println("조회된 사용자2: " + users);
        
        return users.isEmpty() ? null : users.get(0);
    }
    @Override
    public AuthRequest naverLoginInfo(String username) {
        String sql = "SELECT kakaoid AS id, PWD AS pw FROM MEMBER WHERE kakaoid = ?";
        System.out.println("사용자 이름: " + username);

        List<AuthRequest> users = jdbcTemplate.query(sql, new Object[]{username}, (rs, rowNum) -> {
            AuthRequest user = new AuthRequest();
            user.setUsername(rs.getString("id"));
            user.setPassword(rs.getString("pw"));
            return user;
        });
        System.out.println("조회된 사용자2: " + users);
        
        return users.isEmpty() ? null : users.get(0);
    }

    @Override
    public boolean InsertkakaoInfo(String id, String username, String password, String name, String email, String phone_number, String gender, String birthDate) {  
        String sql = "INSERT INTO MEMBER (id,kakaoid, PWD,name,mail,tel,gender,birth) VALUES (?, ?, ?, ?,?,?,?,?)";
        jdbcTemplate.update(sql, id, username, password, name, email, phone_number, gender, birthDate);

        System.out.println("사용자 정보가 성공적으로 삽입되었습니다: 사용자 이름 = " + username);
        return true;
    }

    @Override
    public boolean insert_member(String id, String pwd, String name, String tel, String address,String signupRoutesString, String gender, Date formattedDateTime, String mail, Date birth) {
        String sql = "INSERT INTO MEMBER (id, pwd, name, tel, address,signupRouteString, gender,registration_date,mail,birth) VALUES (?, ?, ?, ?, ?, ?,?,?,?,?)";

        String encodedPwd = passwordEncoder.encode(pwd);
        String encryptionKey = "1234567890123456"; 

        try {
            String encryptedTel = AESEncryptionUtil.encrypt(tel, encryptionKey);
            String encryptedAddress = AESEncryptionUtil.encrypt(address, encryptionKey);
            jdbcTemplate.update(sql, id, encodedPwd, name, encryptedTel, encryptedAddress, signupRoutesString, gender, formattedDateTime, mail, birth);
            System.out.println("회원 정보가 성공적으로 추가되었습니다.");
            return true;
        } catch (DataAccessException e) {
            e.printStackTrace();
            return false;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public LocalDate registration_date(String username) {
        String sql = "SELECT registration_date FROM MEMBER WHERE id = ?";
        System.out.println("사용자 이름: " + username);
        
        List<LocalDate> registrationDates = jdbcTemplate.query(sql, new Object[]{username}, (rs, rowNum) -> {
            java.sql.Date sqlDate = rs.getDate("registration_date");
            return sqlDate != null ? sqlDate.toLocalDate() : null;
        });

        return registrationDates.isEmpty() ? null : registrationDates.get(0);
    }

    @Override
    public String idfind(String mail) { 
        String sql = "SELECT id FROM MEMBER WHERE mail = ?";
        System.out.println("사용자 이메일: " + mail);

        List<String> ids = jdbcTemplate.query(sql, new Object[]{mail}, (rs, rowNum) -> {
            return rs.getString("id");
        });

        if (ids.isEmpty()) {
            return null;
        } else {
            System.out.println("조회된 사용자 ID: " + ids.get(0));
            return ids.get(0);
        }
    }
    @Override
    public String mail(String username) {
        String sql = "SELECT mail FROM MEMBER WHERE id = ?";
        System.out.println("사용자 아이디: " + username);

        List<String> ids = jdbcTemplate.query(sql, new Object[]{username}, (rs, rowNum) -> {
            return rs.getString("mail");
        });

        if (ids.isEmpty()) {
            return null;
        } else {
            System.out.println("조회된 사용자 메일: " + ids.get(0));
            return ids.get(0);
        }
    }
}
