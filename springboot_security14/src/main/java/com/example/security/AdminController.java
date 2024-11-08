package com.example.security;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @GetMapping("")
    @PreAuthorize("hasRole('ADMIN')")  // ADMIN 권한이 있는 사용자만 접근 가능
    public String admin() {
        System.out.println("관리자임");
        return "redirect:http://localhost:8087/management_main";
    }

    @ExceptionHandler(Exception.class)
    public ModelAndView handleException(Exception ex) {
        System.out.println("예외 발생: " + ex.getMessage());
        ModelAndView mav = new ModelAndView("error");
        mav.addObject("message", ex.getMessage());
        return mav;
    }
}

