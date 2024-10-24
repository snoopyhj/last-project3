<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/hotellist.css">

</head>

<body>


	<div class="container">
<!-- 		<aside class="filter-bar">
			<h2>필터</h2>

			<div class="filter-section">
				<h3>가격대</h3>
				<label><input type="radio" name="price" value="low">
					5만원 이하</label><br> <label><input type="radio" name="price"
					value="medium"> 5만원 ~ 10만원</label><br> <label><input
					type="radio" name="price" value="high"> 10만원 이상</label>
			</div>

			<div class="filter-section">
				<h3>테마</h3>
				<label><input type="checkbox" name="theme" value="romantic">
					로맨틱</label><br> <label><input type="checkbox" name="theme"
					value="family"> 가족 여행</label><br> <label><input
					type="checkbox" name="theme" value="business"> 비즈니스</label>
			</div>
		</aside> -->

		<div class="hotel-container">
			<c:forEach var="eachhotel" items="${hotel_list}">
				<div class="hotel-card">
					<p>호텔이름 : ${eachhotel.name}</p>
					<p>가격 : ${eachhotel.cost}원</p>
					<p>전화번호 : ${eachhotel.tel}</p>
					<button class="btn details-btn" onclick="window.open('/hoteldetail?name=${eachhotel.name}')">상세보기</button>
					<a href="#"><button class="btn book-btn">지금 예약하기</button></a>
				</div>
			</c:forEach>
		</div>
	</div>
</body>
</html>