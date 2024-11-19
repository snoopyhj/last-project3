package com.example.demo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.dao.HotelInfoDAO;
import com.example.demo.vo.HotelVO;

@Controller
public class DashBoardController {
   
   @Autowired
   HotelInfoDAO dao;
   HotelVO hotelvo;
   
   @RequestMapping(value = "/")
   public String move_main() {
      return "main";
   }
   
   // ------------------------회원 가입 현황 -------------------------------------------------------------------
   @GetMapping(value = "/join_member_dashboard")
   public String getDashboardData1(Model model) {
       JSONArray jsonArray1 = new JSONArray();
       JSONArray jsonArray2 = new JSONArray();
       JSONArray jsonArray3 = new JSONArray();

       try (Connection conn = DriverManager.getConnection(
               "jdbc:oracle:thin:@192.168.2.63:1521/xe", "c##hr", "hr")) {

           // 1) 회원가입자 월별 수
           String query1 = "SELECT TO_CHAR(TO_DATE(REGISTRATION_DATE, 'YYYY-MM-DD'), 'MM') AS MONTH, " +
                   "COUNT(*) AS COUNT " +
                   "FROM MEMBERFORDASHBOARD " +
                   "WHERE TO_CHAR(TO_DATE(REGISTRATION_DATE, 'YYYY-MM-DD'), 'YYYY') = '2024' " +
                   "GROUP BY TO_CHAR(TO_DATE(REGISTRATION_DATE, 'YYYY-MM-DD'), 'MM') " +
                   "ORDER BY MONTH";

           PreparedStatement stmt1 = conn.prepareStatement(query1);
           ResultSet rs1 = stmt1.executeQuery();

           while (rs1.next()) {
               JSONArray data1 = new JSONArray();
               data1.put(rs1.getString(1));  // 날짜
               data1.put(rs1.getInt(2));     // 가입자 수
               jsonArray1.put(data1);
           } 

           // 2024년 분기별 회원가입자 수
           String query2 = "SELECT " +
                   "CASE " +
                   "  WHEN TO_NUMBER(SUBSTR(REGISTRATION_DATE, 6, 2)) BETWEEN 1 AND 3 THEN '1분기' " +
                   "  WHEN TO_NUMBER(SUBSTR(REGISTRATION_DATE, 6, 2)) BETWEEN 4 AND 6 THEN '2분기' " +
                   "  WHEN TO_NUMBER(SUBSTR(REGISTRATION_DATE, 6, 2)) BETWEEN 7 AND 9 THEN '3분기' " +
                   "  WHEN TO_NUMBER(SUBSTR(REGISTRATION_DATE, 6, 2)) BETWEEN 10 AND 12 THEN '4분기' " +
                   "END AS QUARTER, " +
                   "COUNT(*) AS COUNT " +
                   "FROM MEMBERFORDASHBOARD " +
                   "WHERE SUBSTR(REGISTRATION_DATE, 1, 4) = '2024' " +
                   "GROUP BY " +
                   "CASE " +
                   "  WHEN TO_NUMBER(SUBSTR(REGISTRATION_DATE, 6, 2)) BETWEEN 1 AND 3 THEN '1분기' " +
                   "  WHEN TO_NUMBER(SUBSTR(REGISTRATION_DATE, 6, 2)) BETWEEN 4 AND 6 THEN '2분기' " +
                   "  WHEN TO_NUMBER(SUBSTR(REGISTRATION_DATE, 6, 2)) BETWEEN 7 AND 9 THEN '3분기' " +
                   "  WHEN TO_NUMBER(SUBSTR(REGISTRATION_DATE, 6, 2)) BETWEEN 10 AND 12 THEN '4분기' " +
                   "END " +
                   "ORDER BY QUARTER";

           PreparedStatement stmt2 = conn.prepareStatement(query2);
           ResultSet rs2 = stmt2.executeQuery();

           while (rs2.next()) {
               JSONArray data2 = new JSONArray();
               data2.put(rs2.getString("QUARTER"));  // 분기 (Q1, Q2, Q3, Q4)
               data2.put(rs2.getInt("COUNT"));       // 해당 분기의 가입자 수
               jsonArray2.put(data2);                // 차트에 사용될 JSON 배열에 추가
           }

           // 3) 주간 회원가입 수
           LocalDate today = LocalDate.now();
           LocalDate sevenDaysAgo = today.minusDays(7);
           DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

           String todayStr = today.format(formatter);
           String sevenDaysAgoStr = sevenDaysAgo.format(formatter);

           String query3 = "SELECT TO_CHAR(TO_DATE(REGISTRATION_DATE, 'YYYY-MM-DD'), 'MM/DD') AS REG_DATE, " +
                           "COUNT(*) AS COUNT " +
                           "FROM MEMBERFORDASHBOARD " +
                           "WHERE TO_DATE(REGISTRATION_DATE, 'YYYY-MM-DD') BETWEEN TO_DATE(?, 'YYYY-MM-DD') AND TO_DATE(?, 'YYYY-MM-DD') " +
                           "GROUP BY TO_CHAR(TO_DATE(REGISTRATION_DATE, 'YYYY-MM-DD'), 'MM/DD') " +
                           "ORDER BY REG_DATE";

           try (PreparedStatement stmt3 = conn.prepareStatement(query3)) {
               stmt3.setString(1, sevenDaysAgoStr);  // 7일 전 날짜 설정
               stmt3.setString(2, todayStr);         // 오늘 날짜 설정
               ResultSet rs3 = stmt3.executeQuery();

               while (rs3.next()) {
                   JSONArray data3 = new JSONArray();
                   data3.put(rs3.getString("REG_DATE"));  // 가입 날짜 (MM/DD 형식)
                   data3.put(rs3.getInt("COUNT"));        // 해당 날짜의 가입자 수
                   jsonArray3.put(data3);
               }
           }


           // 모델에 데이터 추가
           model.addAttribute("jsonArray1", jsonArray1);
           model.addAttribute("jsonArray2", jsonArray2);
           model.addAttribute("jsonArray3", jsonArray3);

       } catch (SQLException e) {
           e.printStackTrace();
       }

       return "join_member_dashboard";  
   }
    
   // ------------------------회원 분석 -------------------------------------------------------------------

    @GetMapping(value = "/member_analysis_dashboard")
    public String getDashboardData2(Model model) { 
        JSONArray jsonArray1 = new JSONArray();
        JSONArray jsonArray2 = new JSONArray();
        JSONArray jsonArray3 = new JSONArray();

        try (Connection conn = DriverManager.getConnection(
                "jdbc:oracle:thin:@192.168.2.63:1521/xe", "c##hr", "hr")) {

            // 1) 연령별 회원 비율
            String query1 =
                    "SELECT AGEARRANGE AS age_group, COUNT(ID) AS count " +
                    "FROM MEMBERBYGENDER " + 
                    "GROUP BY AGEARRANGE " +
                    "ORDER BY CASE " +
                    "WHEN AGEARRANGE = '10대' THEN 1 " +
                    "WHEN AGEARRANGE = '20대' THEN 2 " +
                    "WHEN AGEARRANGE = '30대' THEN 3 " +
                    "WHEN AGEARRANGE = '40대' THEN 4 " +
                    "WHEN AGEARRANGE = '50대' THEN 5 " +
                    "WHEN AGEARRANGE = '60대 이상' THEN 6 " +
                    "ELSE 7 END ASC";

            PreparedStatement stmt1 = conn.prepareStatement(query1);
            ResultSet rs1 = stmt1.executeQuery();

            while (rs1.next()) {
               try {
                JSONObject data1 = new JSONObject();
                data1.put("ageGroup", rs1.getString("age_group"));
                data1.put("count", rs1.getInt("count"));
                jsonArray1.put(data1);
                
            } catch (Exception e) {
                   e.printStackTrace();
            }
            }
            // 2) 가입경로 별 회원분류
            String query2 = "SELECT SIGNUPROUTESTRING, COUNT(*) AS count " +
                            "FROM MEMBERFORDASHBOARD " +
                            "GROUP BY SIGNUPROUTESTRING " +
                            "ORDER BY count DESC";

            PreparedStatement stmt2 = conn.prepareStatement(query2);
            ResultSet rs2 = stmt2.executeQuery();

            while (rs2.next()) {
                JSONArray data2 = new JSONArray();
                data2.put(rs2.getString(1));  // 경로 이름
                data2.put(rs2.getInt(2));     // 가입자 수
                jsonArray2.put(data2);
            }

            // 3) 성별 회원 비율 
            String query3 = "SELECT GENDER, COUNT(*) AS count " +
                            "FROM MEMBERFORDASHBOARD " +
                            "GROUP BY GENDER";

            PreparedStatement stmt3 = conn.prepareStatement(query3);
            ResultSet rs3 = stmt3.executeQuery();

            while (rs3.next()) {
            try {
               JSONObject data3 = new JSONObject();
                data3.put("gender", rs3.getString("GENDER"));
                data3.put("count", rs3.getInt("count"));
                jsonArray3.put(data3);
            }catch(Exception e) {
                e.printStackTrace();
            }

        } 
            model.addAttribute("jsonArray1", jsonArray1);
            model.addAttribute("jsonArray2", jsonArray2);
            model.addAttribute("jsonArray3", jsonArray3);
        
    } catch(SQLException e) {
       e.printStackTrace();
    }
        return "/member_analysis_dashboard";
    }

   // ------------------------Daily 요약 -------------------------------------------------------------------

    @GetMapping(value = "/daily_dashboard")
    public String getDashboardData3(Model model) {
        // 오늘과 어제 날짜 계산
        LocalDate today = LocalDate.now();
        LocalDate yesterday = today.minusDays(1);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        String todayStr = today.format(formatter);
        String yesterdayStr = yesterday.format(formatter);

        // 가입자 수 관련 변수 초기화
        int todaySignupCount = 0;
        int yesterdaySignupCount = 0;
        double signupChangeRate = 0;

        // 오늘과 어제 가입자 수 계산
        try (Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.2.63:1521/xe", "c##hr", "hr")) {
            String queryToday = "SELECT COUNT(*) AS COUNT FROM MEMBERFORDASHBOARD WHERE TO_DATE(REGISTRATION_DATE, 'YYYY-MM-DD') = TO_DATE(?, 'YYYY-MM-DD')";
            String queryYesterday = "SELECT COUNT(*) AS COUNT FROM MEMBERFORDASHBOARD WHERE TO_DATE(REGISTRATION_DATE, 'YYYY-MM-DD') = TO_DATE(?, 'YYYY-MM-DD')";

            // 오늘 가입자 수
            try (PreparedStatement stmtToday = conn.prepareStatement(queryToday)) {
                stmtToday.setString(1, todayStr);
                ResultSet rsToday = stmtToday.executeQuery();
                if (rsToday.next()) {
                    todaySignupCount = rsToday.getInt("COUNT");
                }
            }

            // 어제 가입자 수
            try (PreparedStatement stmtYesterday = conn.prepareStatement(queryYesterday)) {
                stmtYesterday.setString(1, yesterdayStr);
                ResultSet rsYesterday = stmtYesterday.executeQuery();
                if (rsYesterday.next()) {
                    yesterdaySignupCount = rsYesterday.getInt("COUNT");
                }
            }

            // 가입자 증감률 계산
            if (yesterdaySignupCount > 0) {
                signupChangeRate = ((double) (todaySignupCount - yesterdaySignupCount) / yesterdaySignupCount) * 100;
            } else if (todaySignupCount > 0) {
                signupChangeRate = 100.0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
// ----------------------------------------  가입자 끝 ---------------------------
        // 예약 건수 관련 변수 초기화
        int todayReservationCount = 0;
        int yesterdayReservationCount = 0;
        double reservationChangeRate = 0;

        // 오늘과 어제 예약 건수 계산
        try (Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@192.168.2.63:1521:xe", "c##hr", "hr")) {
            String queryTodayReservation = "SELECT COUNT(*) AS COUNT FROM RESERVATION WHERE PAY_DATE = TO_DATE(?, 'YYYY-MM-DD')";
            String queryYesterdayReservation = "SELECT COUNT(*) AS COUNT FROM RESERVATION WHERE PAY_DATE = TO_DATE(?, 'YYYY-MM-DD')";

            // 오늘 예약 건수
            try (PreparedStatement stmtTodayReservation = conn.prepareStatement(queryTodayReservation)) {
                stmtTodayReservation.setString(1, todayStr);
                ResultSet rsTodayReservation = stmtTodayReservation.executeQuery();
                if (rsTodayReservation.next()) {
                    todayReservationCount = rsTodayReservation.getInt("COUNT");
                }
            }

            // 어제 예약 건수
            try (PreparedStatement stmtYesterdayReservation = conn.prepareStatement(queryYesterdayReservation)) {
                stmtYesterdayReservation.setString(1, yesterdayStr);
                ResultSet rsYesterdayReservation = stmtYesterdayReservation.executeQuery();
                if (rsYesterdayReservation.next()) {
                    yesterdayReservationCount = rsYesterdayReservation.getInt("COUNT");
                }
            }

            // 예약 증감률 계산
            if (yesterdayReservationCount > 0) {
                reservationChangeRate = ((double) (todayReservationCount - yesterdayReservationCount) / yesterdayReservationCount) * 100;
            } else if (todayReservationCount > 0) {
                reservationChangeRate = 100.0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
     // ----------------------------------------  예약건수 끝 ---------------------------       
        // 결제 금액 변수 초기화
        int todayTotalPayment = 0;
        int yesterdayTotalPayment = 0;
        double paymentChangeRate = 0;

        java.sql.Date todaySqlDate = java.sql.Date.valueOf(today);
        java.sql.Date yesterdaySqlDate = java.sql.Date.valueOf(yesterday);


        // JDBC 연결 및 결제 금액 계산
        try (Connection dbConnection = DriverManager.getConnection("jdbc:oracle:thin:@192.168.2.63:1521:xe", "c##hr", "hr")) {
            String paymentQuery = "SELECT NVL(SUM(COST), 0) AS TOTAL_COST FROM RESERVATION WHERE PAY_DATE = ?";

            // 오늘 총 결제 금액
            try (PreparedStatement todayPaymentStmt = dbConnection.prepareStatement(paymentQuery)) {
                todayPaymentStmt.setDate(1, todaySqlDate);
                ResultSet todayPaymentResult = todayPaymentStmt.executeQuery();
                if (todayPaymentResult.next()) {
                    todayTotalPayment = todayPaymentResult.getInt("TOTAL_COST");
                }
            }

            // 어제 총 결제 금액
            try (PreparedStatement yesterdayPaymentStmt = dbConnection.prepareStatement(paymentQuery)) {
                yesterdayPaymentStmt.setDate(1, yesterdaySqlDate);
                ResultSet yesterdayPaymentResult = yesterdayPaymentStmt.executeQuery();
                if (yesterdayPaymentResult.next()) {
                    yesterdayTotalPayment = yesterdayPaymentResult.getInt("TOTAL_COST");
                }
            }

            // 결제 금액 증감률 계산
            if (yesterdayTotalPayment > 0) {
                paymentChangeRate = ((double) (todayTotalPayment - yesterdayTotalPayment) / yesterdayTotalPayment) * 100;
            } else if (todayTotalPayment > 0) {
                paymentChangeRate = 100.0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // ----------------------------------------결제 금액 종료 ----------------------------
        
        // 리뷰 건수 변수 초기화
        int todayReviewCount = 0;
        int yesterdayReviewCount = 0;
        double reviewChangeRate = 0.0;
        
        // JDBC 연결 및 리뷰 건수 계산
        try (Connection connection = DriverManager.getConnection("jdbc:oracle:thin:@192.168.2.63:1521:xe", "c##hr", "hr")) {
            String reviewQuery = "SELECT COUNT(*) AS REVIEW_COUNT FROM HOTEL_REVIEWS WHERE REVIEW_DATE = ?";

            // 오늘 리뷰 건수
            try (PreparedStatement todayReviewStmt = connection.prepareStatement(reviewQuery)) {
                todayReviewStmt.setDate(1, todaySqlDate);
                ResultSet todayResultSet = todayReviewStmt.executeQuery();
                if (todayResultSet.next()) {
                    todayReviewCount = todayResultSet.getInt("REVIEW_COUNT");
                }
            }

            // 어제 리뷰 건수
            try (PreparedStatement yesterdayReviewStmt = connection.prepareStatement(reviewQuery)) {
                yesterdayReviewStmt.setDate(1, yesterdaySqlDate);
                ResultSet yesterdayResultSet = yesterdayReviewStmt.executeQuery();
                if (yesterdayResultSet.next()) {
                    yesterdayReviewCount = yesterdayResultSet.getInt("REVIEW_COUNT");
                }
            }

            // 리뷰 증감률 계산
            if (yesterdayReviewCount > 0) {
                reviewChangeRate = ((double) (todayReviewCount - yesterdayReviewCount) / yesterdayReviewCount) * 100;
            } else if (todayReviewCount > 0) {
                reviewChangeRate = 100.0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        // Model에 데이터를 추가하여 JSP에서 사용
        model.addAttribute("todaySignupCount", todaySignupCount);
        model.addAttribute("yesterdaySignupCount", yesterdaySignupCount);
        model.addAttribute("signupChangeRate", String.format("%.2f", signupChangeRate));

        model.addAttribute("todayReservationCount", todayReservationCount);
        model.addAttribute("yesterdayReservationCount", yesterdayReservationCount);
        model.addAttribute("reservationChangeRate", String.format("%.2f", reservationChangeRate));

        model.addAttribute("todayTotalPayment", todayTotalPayment);
        model.addAttribute("yesterdayTotalPayment", yesterdayTotalPayment);
        model.addAttribute("paymentChangeRate", String.format("%.2f", paymentChangeRate));

        model.addAttribute("todayReviewCount", todayReviewCount);
        model.addAttribute("yesterdayReviewCount", yesterdayReviewCount);
        model.addAttribute("reviewChangeRate", String.format("%.2f", reviewChangeRate));
        
        return "daily_dashboard"; // daily_dashboard.jsp 파일에 데이터 전달
    }

    @RequestMapping(value="/insert_hotelInfo")
    public String insert_hotelinfo() {

        return "insert_hotelInfo";
    }
    
    @RequestMapping(value="/default_num_check", method=RequestMethod.POST)
    public String default_num_check(@RequestParam("default_num") String default_num,
                            @RequestParam("name") String name,
                            @RequestParam("address") String address,
                            @RequestParam("mapx") String mapx,
                            @RequestParam("mapy") String mapy,
                            @RequestParam("region") String region,
                            @RequestParam("subregion") String subregion,
                            @RequestParam("type") String type,
                            @RequestParam("img_auth") String img_auth,
                            @RequestParam("person") String person,
                            @RequestParam("standard") String STANDARD,
                            @RequestParam("deluxe") String DELUXE,
                            @RequestParam("suite") String SUITE,
                            @RequestParam("tel") String tel,
                            @RequestParam("img1") String img1,
                            @RequestParam("img2") String img2,
                            @RequestParam("coment") String coment) {

        // 유효성 검사 (영어 대소문자, 숫자 1~5글자)
        if (default_num == null || !default_num.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{5}$")) {
            System.out.println("Invalid default_num format");
            return "error2"; // 유효성 검사 실패 시 error2 페이지로 반환
        }

      /*
       * @GetMapping("/check_duplicate_default_num") public ResponseEntity<Boolean>
       * checkDuplicateDefaultNum(@RequestParam("default_num") String defaultNum) {
       * boolean isDuplicate = dao.existsByDefaultNum(defaultNum); return
       * ResponseEntity.ok(isDuplicate); }
       */

        // HotelVO 객체 생성 및 필드 설정
        HotelVO hotelVO = new HotelVO();
        hotelVO.setDefault_num(default_num);
        hotelVO.setName(name);
        hotelVO.setAddress(address);
        hotelVO.setMapx(mapx);
        hotelVO.setMapy(mapy);
        hotelVO.setRegion(region);
        hotelVO.setSubregion(subregion);
        hotelVO.setType(type);
        hotelVO.setImg_auth(img_auth);
        hotelVO.setPerson(person);
        hotelVO.setStandard(STANDARD);
        hotelVO.setDeluxe(DELUXE);
        hotelVO.setSuite(SUITE);
        hotelVO.setTel(tel);
        hotelVO.setImg1(img1);
        hotelVO.setImg2(img2);
        hotelVO.setComent(coment);

        
        // 유효성 검사를 통과한 경우에만 DB에 삽입
        dao.insertHotelReservation(hotelVO);
        dao.insert_hotelinfo(hotelVO);
        return "redirect:/insert_hotelInfo";
    }
    
    @RequestMapping(value="/update_hotelInfo")
    public String update_hotelInfo() {

        return "update_hotelInfo";
    }
    
    @RequestMapping(value="/default_num_check_update", method=RequestMethod.POST)
    public String default_num_check_update(@ModelAttribute HotelVO hotelvo, RedirectAttributes redirectAttributes) {
        // 유효성 검사
        if (hotelvo.getDefault_num() == null || hotelvo.getDefault_num().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "호텔 고유번호를 입력해주세요.");
            return "redirect:/update_hotelInfo";
        }

        // 업데이트 처리
        int rowsUpdated = dao.hotel_update(hotelvo);
        if (rowsUpdated > 0) {
            redirectAttributes.addFlashAttribute("successMessage", "호텔 정보가 성공적으로 업데이트되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "업데이트할 호텔 정보를 찾을 수 없습니다.");
        }

        return "redirect:/update_hotelInfo";
    }
    
    
   @ControllerAdvice
   public class CustomGlobalExceptionHandler {

       // DuplicateKeyException 예외 발생 시 duplicate_error.jsp 페이지로 이동
       @ExceptionHandler(DuplicateKeyException.class)
       public String handleDuplicateKeyException(DuplicateKeyException e, Model model) {
           model.addAttribute("errorMessage", "중복된 고유번호가 있습니다. 다른 번호를 사용하세요.");
           return "error"; // error/duplicate_error.jsp 페이지로 이동
       }
   }
}