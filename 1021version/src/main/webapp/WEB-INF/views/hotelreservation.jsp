<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>예약 페이지</title>
</head>
<body>
    <h1>${hotelInfo.name} 예약 페이지</h1>
    <p>주소: ${hotelInfo.address}</p>
    <p>전화번호: ${hotelInfo.tel}</p>

    <h2>예약 정보</h2>
    <p>객실 유형: ${roomType}</p>
    <p>가격: ${price}원</p> 

    <form action="/confirmReservation" method="post">
        <input type="hidden" name="name" value="${hotelInfo.name}">
        <input type="hidden" name="roomType" value="${roomType}">
        <input type="hidden" name="price" value="${price}">
        <button type="submit">결제하기</button>
    </form>
</body>
</html>
