package com.example.security.dao;

import com.example.security.AESEncryptionUtil;
import com.example.security.vo.AuthRequest;
import com.example.security.vo.HotelReview;
import com.example.security.vo.ReservationVO;
import com.example.security.vo.UserInfo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Primary;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Repository
@Primary
public class LoginDAOImpl implements LoginDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    private String encryptionKey = "1234567890123456"; 
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
            public List<ReservationVO> findReservationById(String username) {
            	String sql="SELECT * FROM reservation WHERE name = ?";
            	List<ReservationVO> reservations = jdbcTemplate.query(sql, new Object[]{username}, (rs, rowNum) -> {
            		ReservationVO reservation = new ReservationVO();
            		reservation.setImpUid(rs.getString("IMP_UID"));
                    reservation.setProductName(rs.getString("PRODUCT_NAME"));
                    reservation.setCost(rs.getLong("COST"));
                    reservation.setEmail(rs.getString("EMAIL"));
                    reservation.setName(rs.getString("NAME"));
                    reservation.setTel(rs.getString("TEL"));
                    reservation.setAddress(rs.getString("ADDRESS"));
                    reservation.setDateRange(rs.getString("DATERANGE"));
                    reservation.setPayDate(rs.getDate("PAY_DATE"));
                    reservation.setPerson(rs.getString("PERSON"));
                    reservation.setDefault_num(rs.getString("DEFAULT_NUM"));
            		
                    return reservation;
                });
               
            	return reservations;
            }
        
    

    public UserInfo getUserInfoByUsername(String username) {
        String sql = "SELECT id, mail, tel, name, address FROM MEMBER WHERE id = ?";
        
        RowMapper<UserInfo> rowMapper = (rs, rowNum) -> {
            try {
                String decryptedTel = AESEncryptionUtil.decrypt(rs.getString("tel"), encryptionKey);
                String decryptedAddress = AESEncryptionUtil.decrypt(rs.getString("address"), encryptionKey);
                
                return new UserInfo(
                    rs.getString("id"),
                    rs.getString("mail"),
                    decryptedTel,
                    rs.getString("name"),
                    decryptedAddress
                );
            } catch (Exception e) {
                throw new RuntimeException("Failed to decrypt data", e);
            }
        };

        List<UserInfo> users = jdbcTemplate.query(sql, new Object[]{username}, rowMapper);
        return users.isEmpty() ? null : users.get(0);
    }

    public UserInfo getUserInfoByUsernamekakao(String username) {
        String sql = "SELECT id, mail, tel, name, address FROM MEMBER WHERE KAKAOID = ?";

        RowMapper<UserInfo> rowMapper = (rs, rowNum) -> {
            try {
                String decryptedTel = AESEncryptionUtil.decrypt(rs.getString("tel"), encryptionKey);
                String decryptedAddress = AESEncryptionUtil.decrypt(rs.getString("address"), encryptionKey);
                
                return new UserInfo(
                    rs.getString("id"),
                    rs.getString("mail"),
                    decryptedTel,
                    rs.getString("name"),
                    decryptedAddress
                );
            } catch (Exception e) {
                throw new RuntimeException("Failed to decrypt data", e);
            }
        };

        List<UserInfo> users = jdbcTemplate.query(sql, new Object[]{username}, rowMapper);
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
    public boolean InsertkakaoInfo(String id, String username, String password, String name, String email, String phone_number, String gender, String birthDate,String shippingAddress) {  
        String sql = "INSERT INTO MEMBER (id,kakaoid, PWD,name,mail,tel,address,gender,birth) VALUES (?, ?, ?, ?,?,?,?,?,?)";
        String encodedPassword = passwordEncoder.encode(password);
        if(shippingAddress==null)
        {
           shippingAddress="주소없음";
        }
        try {
        String encryptedTel = AESEncryptionUtil.encrypt(phone_number, encryptionKey);
        String encryptedAddress = AESEncryptionUtil.encrypt(shippingAddress, encryptionKey);
        jdbcTemplate.update(sql, id, username, encodedPassword, name, email, encryptedTel,encryptedAddress, gender, birthDate);
        }catch (DataAccessException e) {
            e.printStackTrace();
        }catch (Exception e) {
            e.printStackTrace();
        }
        

        System.out.println("사용자 정보가 성공적으로 삽입되었습니다: 사용자 이름 = " + username);
        return true;
    }

    @Override
    public boolean insert_member(String id, String pwd, String name, String tel, String address,String signupRoutesString, String gender, Date formattedDateTime, String mail, Date birth) {
        String sql = "INSERT INTO MEMBER (id, pwd, name, tel, address,signupRoute, gender,registration_date,mail,birth) VALUES (?, ?, ?, ?, ?, ?,?,?,?,?)";

        String encodedPwd = passwordEncoder.encode(pwd);
        

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
    public boolean insert_memberdashboard(String id, String pwd, String name, String tel, String address,String signupRoutesString, String gender, Date formattedDateTime, String mail, Date birth) {
        String sql = "INSERT INTO MEMBERFORDASHBOARD (id, pwd, name, tel, address,signupRoute, gender,registration_date,mail,birthday) VALUES (?, ?, ?, ?, ?, ?,?,?,?,?)";

        String encodedPwd = passwordEncoder.encode(pwd);
        

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
    public String uuidfind(String username) { 
        String sql = "SELECT id FROM refresh_tokens WHERE username = ?";
        System.out.println("사용자 이메일: " + username);

        List<String> ids = jdbcTemplate.query(sql, new Object[]{username}, (rs, rowNum) -> {
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
    public String idfind2(String id) { 
        String sql = "SELECT username FROM refresh_tokens WHERE id = ?";
        System.out.println("사용자 이메일: " + id);

        List<String> ids = jdbcTemplate.query(sql, new Object[]{id}, (rs, rowNum) -> {
            return rs.getString("username");
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
    @Override
    public String mailcheck(String mail) {
        String sql = "SELECT mail FROM MEMBER WHERE mail = ?";
        System.out.println("사용자 아이디: " + mail);

        List<String> ids = jdbcTemplate.query(sql, new Object[]{mail}, (rs, rowNum) -> {
            return rs.getString("mail");
        });

        if (ids.isEmpty()) {
            return null;
        } else {
            System.out.println("조회된 사용자 메일: " + ids.get(0));
            return ids.get(0);
        }
    }
    @Transactional
    @Override
    public boolean deleteUser(String mail, String password) {
    	System.out.println("mail : "+mail);
    	System.out.println("rowsAffected : ");
        // 1. 데이터베이스에서 암호화된 비밀번호를 먼저 조회
        String sqlSelect = "SELECT pwd FROM MEMBER WHERE mail = ?";
        System.out.println("rowsAffected1 : ");
        String storedPassword = jdbcTemplate.queryForObject(sqlSelect, new Object[]{mail}, String.class);
        System.out.println("storedPassword : "+storedPassword);
        if (storedPassword != null && passwordEncoder.matches(password, storedPassword)) {
        	System.out.println("rowsAffected3 : ");
            // 2. 비밀번호가 일치하면 자식 테이블(HOTEL_REVIEWS)부터 삭제
            String sqlDeleteReviews = "DELETE FROM HOTEL_REVIEWS WHERE user_id = (SELECT id FROM MEMBER WHERE mail = ?)";
            jdbcTemplate.update(sqlDeleteReviews, mail);
            System.out.println("sqlDeleteReviews : "+sqlDeleteReviews);
            // 3. reservation 테이블에서 NAME 필드 기준으로 삭제
            String sqlDeleteReservations = "DELETE FROM reservation WHERE NAME = (SELECT id FROM MEMBER WHERE mail = ?)";
            jdbcTemplate.update(sqlDeleteReservations, mail);
            System.out.println("sqlDeleteReservations : "+sqlDeleteReservations);
            String sqlDeleteFavorite = "DELETE FROM favorites WHERE ID = (SELECT id FROM MEMBER WHERE mail = ?)";
            jdbcTemplate.update(sqlDeleteFavorite, mail);
            System.out.println("sqlDeleteReservations : "+sqlDeleteReservations);
            String sqlDeleteFavorites = "DELETE FROM FAVORITES WHERE id = (SELECT id FROM MEMBER WHERE mail = ?)";
            jdbcTemplate.update(sqlDeleteFavorites, mail);
            // 4. 자식 테이블 삭제 후, 부모 테이블(MEMBER)에서 삭제
            String sqlDeleteMember = "DELETE FROM MEMBER WHERE mail = ?";
            int rowsAffected = 0;
            try {
                rowsAffected = jdbcTemplate.update(sqlDeleteMember, mail);
                System.out.println("rowsAffected : " + rowsAffected);
            } catch (Exception e) {
                e.printStackTrace();
            }

            // 5. 삭제된 행이 있으면 true 반환
            return rowsAffected > 0;
        }

        // 6. 비밀번호가 일치하지 않으면 삭제 실패
        return false;
    }
    
@Override
public List<HotelReview> getReviewsByUserId(String userId) {
	String sql="SELECT * FROM HOTEL_REVIEWS WHERE user_id = ?";
	List<HotelReview> reviews = jdbcTemplate.query(sql, new Object[]{userId}, (rs, rowNum) -> {
		HotelReview review = new HotelReview();
		review.setReviewId(rs.getInt("REVIEW_ID"));
        review.setDefaultNum(rs.getString("DEFAULT_NUM"));
        review.setUserId(rs.getString("USER_ID"));
        review.setRating(rs.getInt("RATING"));
        review.setReviewText(rs.getString("REVIEW_TEXT"));
        review.setReviewDate(rs.getDate("REVIEW_DATE"));
        review.setImagePath(rs.getString("IMAGE_PATH"));
		
        return review;
    });
   
	return reviews;
}
public String getHotelNameByDefaultNum(String defaultNum) {
    // 예시: SQL 쿼리 또는 ORM으로 호텔 이름 가져오기
    String sql = "SELECT name FROM hotel_list WHERE default_num = ?";
    return jdbcTemplate.queryForObject(sql, new Object[]{defaultNum}, String.class);
}
public boolean deleteReviewById(int reviewId) {
    String sql = "DELETE FROM HR.HOTEL_REVIEWS WHERE REVIEW_ID = ?";
    int rowsAffected = jdbcTemplate.update(sql, reviewId);
    return rowsAffected > 0;
}


}
