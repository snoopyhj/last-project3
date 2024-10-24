<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/hoteldetail.css">
</head>
<body>
	<div class="hotel-detail-page">
		<!-- 상단 호텔 이미지 -->
		<img src="${hotel.img1}" alt="Hotel Image" class="hotel-image">

		<!-- 호텔 기본 정보 -->
		<div class="hotel-info">
			<h1 class="hotel-name">${hotel.name}</h1>
			<p class="hotel-address">${hotel.address}</p>
			<p class="hotel-tel">${hotel.tel}</p>
			<p class="hotel-comment">${hotel.comment}</p>
			<p class="hotel-cost">${hotel.cost}</p>
			<p class="hotel-type">${hotel.type}</p>
		</div>

		<!-- 방 종류 섹션 -->
		<div class="room-types">
			<h2>객실 종류</h2>

			<div class="room">
				<h3>스탠다드</h3>
				<p>기본적인 편의시설을 갖춘 스탠다드룸입니다.</p>
				<p>가격: 80,000원/박</p>
				<button class="btn book-btn" onclick="bookRoom('스탠다드', '80,000원')">예약하기</button>
			</div>

			<div class="room">
				<h3>디럭스</h3>
				<p>넓은 공간과 고급 침구를 갖춘 디럭스룸입니다.</p>
				<p>가격: 120,000원/박</p>
				<button class="btn book-btn" onclick="bookRoom('디럭스', '120,000원')">예약하기</button>
			</div>

			<div class="room">
				<h3>스위트</h3>
				<p>럭셔리한 인테리어와 최고의 편안함을 제공하는 스위트룸입니다.</p>
				<p>가격: 200,000원/박</p>
				<button class="btn book-btn" onclick="bookRoom('스위트', '200,000원')">예약하기</button>
			</div>
		</div>
	</div>

	<script src="script.js"></script>
</body>
</html>