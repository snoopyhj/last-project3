package com.example.demo;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;



@Controller
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(jakarta.servlet.http.HttpServletRequest request, Model model) {
        Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");

        // 상태 코드에 따라 에러 메시지 설정
        if (statusCode != null && statusCode == 401) {
            model.addAttribute("errorMessage", "접근이 거부되었습니다. 인증이 필요합니다.");
        } else {
            model.addAttribute("errorMessage", "알 수 없는 오류가 발생했습니다.");
        }

        return "error"; // error.html 페이지 반환
    }
}

