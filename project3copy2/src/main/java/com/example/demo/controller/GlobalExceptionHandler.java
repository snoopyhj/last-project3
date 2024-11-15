package com.example.demo.controller;

import java.io.IOException;

import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

import org.springframework.web.servlet.NoHandlerFoundException;

import com.example.demo.UnauthorizedException;

import jakarta.servlet.http.HttpServletResponse;


// 일반 @Controller용 오류 처리
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handleNotFound(NoHandlerFoundException ex, Model model) {
        model.addAttribute("errorMessage", "페이지를 찾을 수 없습니다.");
        return "error";
    }

    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleException(Exception ex, Model model) {
        model.addAttribute("errorMessage", "알 수 없는 오류가 발생했습니다.");
        return "error";
    }
    @ExceptionHandler(UnauthorizedException.class)
    @ResponseStatus(HttpStatus.UNAUTHORIZED) // 401 상태 코드 반환
    public String handleUnauthorized(UnauthorizedException ex, Model model) {
        model.addAttribute("errorMessage", "접근이 거부되었습니다. 인증이 필요합니다.");
        return "error"; // error.html 페이지를 반환
    }
}



