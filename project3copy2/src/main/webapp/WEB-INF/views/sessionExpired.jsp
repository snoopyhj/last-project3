<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>세션 만료</title>
</head>
<body>
	<p>Hotel Name: ${hotelName}</p>

    <h1>세션이 만료되었습니다</h1>
    <p>결제 시간이 초과되었습니다. 다시 결제를 시도해 주세요.</p>
    <a href="/hoteldetail?name=${fn:escapeXml(hotelName)}">호텔 상세 페이지로 돌아가기</a>
</body>
</html>
