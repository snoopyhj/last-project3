<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>500 오류 - 서버 오류</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
        h1 { color: #FF5733; }
        p { color: #555; }
        button { padding: 10px 20px; font-size: 16px; background-color: #f44336; color: white; border: none; border-radius: 5px; cursor: pointer; }
        button:hover { background-color: #e53935; }
    </style>
</head>
<body>
    <h1>500 오류</h1>
    <p th:text="${errorMessage}"></p>
    <p th:if="${errorDetails}">상세 오류: <span th:text="${errorDetails}"></span></p>
    <button onclick="window.history.back()">뒤로가기</button>
</body>
</html>
