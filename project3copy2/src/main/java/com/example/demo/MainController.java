package com.example.demo;

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
		return "main";
	}

	@RequestMapping("/register")
	public String registerform() {
		return "register";
	}

	@RequestMapping("/regionfilter")
	public String regionfilter() {
		return "regionfilter";
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

	@RequestMapping(value = "/insert_member", method = RequestMethod.POST)
	public String insert_member(HttpServletRequest req) {
		// 다중 선택된 값을 배열로 받아옴
		String[] signupRoute = req.getParameterValues("signupRoute");

		String signupRoutesString = String.join(",", signupRoute);
		
		System.out.println(signupRoutesString);

		// DAO 메서드 호출
		dao.insert_member(req.getParameter("id"),
						  req.getParameter("pwd"),
						  req.getParameter("name"),
						  req.getParameter("birthday"),
						  req.getParameter("tel"),
						  req.getParameter("address"),
						  signupRoutesString,
						  req.getParameter("gender"));

		return "redirect:login";
	}
	
	// Controller에서 /favicon.ico을 처리하는 메소드에 리턴값이 없게 함(로그인 이후 favicon 파일로 인해 발생하는 문제 처리)
	@GetMapping("/favicon.ico")
    @ResponseBody
    public void returnNoFavicon() {
		
    }
}