package com.example.demo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.example.demo.dao.RegionSearchDAO;
import com.example.demo.dao.RegisterDAO;
import com.example.demo.JwtTokenValidator;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class MainController {
    
    @Autowired
    RegisterDAO dao;
    
    @Autowired
    RegionSearchDAO region_dao;

    @Autowired
    JwtTokenValidator jwtTokenValidator;  // JWT 검증 객체 추가

    @RequestMapping(value = "/")
    public String move_main() {
        return "main";
    }

    @RequestMapping(value = "/login")
    public String insertform() {
        return "http://localhost:8083/login";
    }

    @RequestMapping("/register")
    public String registerform() {
        return "register";
    }

    

    @RequestMapping("/regionfilter")
    public String regionfilter(HttpServletRequest request, HttpServletResponse response) {
        // 쿠키에서 JWT 토큰을 가져옴
        
       // 토큰이 유효하면 regionfilter 페이지로 이동
       return "regionfilter";
            
    }

    // 쿠키에서 JWT 토큰을 추출하는 메소드
    private String extractTokenFromCookies(Cookie[] cookies) {
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                // JWT 토큰이 저장된 쿠키 이름을 지정 (예: "JWT_TOKEN")
                if ("JWT_TOKEN".equals(cookie.getName())) {
                    return cookie.getValue(); // 쿠키에서 JWT 토큰 값 반환
                }
            }
        }
        return null; // 쿠키에서 JWT 토큰을 찾지 못했을 경우 null 반환
    }
    




    @RequestMapping("/hotellist")
    public String hotellist() {
        return "hotellist";
    }

    @RequestMapping("/hoteldetail")
    public String hoteldetail() {
        return "hoteldetail";
    }

    @RequestMapping("/hoteldetailbytype")
    public String hoteldetailbytype() {
        return "hoteldetailbytype";
    }

    @RequestMapping("/aboutus")
    public String aboutus() {
        return "aboutus";
    }

    @RequestMapping("/question")
    public String question() {
        return "question";
    }

    @RequestMapping("/email")
    public String email() {
        return "email";
    }

    
}
