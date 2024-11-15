package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dao.RegionSearchDAO;
import com.example.demo.dao.RegisterDAO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class MainController {
	@Autowired
	RegisterDAO dao;
	
	@Autowired
	RegionSearchDAO region_dao;
	
	@RequestMapping(value = "/")
	public String move_main() {
		return "mainpage/main";
	}

	

	@RequestMapping("/regionfilter")
	public String regionfilter() {
		return "mainpage/regionfilter";
	}

	@RequestMapping("/hotellist")
	public String hotellist() {
		return "hotel/hotellist";
	}

	@RequestMapping("/hoteldetail")
	public String hoteldetail() {
		return "hotel/hoteldetail";
	}
	
	@RequestMapping("/contact")
    public String contactPage() {
        return "mainpage/contact"; 
    }

	@RequestMapping("/aboutus")
	public String aboutus() {
		return "mainpage/aboutus";
	}

	@RequestMapping("/question")
	public String question() {
		return "mainpage/question";
	}

	@RequestMapping("/email")
	public String email() {
		return "mainpage/email";
	}

	
	
	// Controller에서 /favicon.ico을 처리하는 메소드에 리턴값이 없게 함(로그인 이후 favicon 파일로 인해 발생하는 문제 처리)
	   @GetMapping("/favicon.ico")
	    @ResponseBody
	    public void returnNoFavicon() {
	      
	    }
	
}