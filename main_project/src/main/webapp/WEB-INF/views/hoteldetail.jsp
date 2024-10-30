<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${hotel.name} 호텔 소개</title>
<link rel = "stylesheet" type = "text/css" href = "${pageContext.request.contextPath}/css/hoteldetail.css">
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
			<p class="hotel-comment">${hotel.coment}</p>
			<p class="hotel-type">${hotel.type}</p>
		</div>

		<!-- 방 종류 섹션 -->
		<div class="room-types">
			<h2>객실 종류</h2>

			<div class="room">
				<h3>스탠다드</h3>
				<p>기본적인 편의시설을 갖춘 스탠다드룸입니다.</p>
				<p>${hotel.standard}</p>
				<button class="btn book-btn" onclick="location.href='/hotelreservation?name=${hotel.name}&roomType=스탠다드&price=${hotel.standard}'">예약하기</button>
			</div>

			<div class="room">
				<h3>디럭스</h3>
				<p>넓은 공간과 고급 침구를 갖춘 디럭스룸입니다.</p>
				<p>${hotel.deluxe}</p>
				<button class="btn book-btn"onclick="location.href='/hotelreservation?name=${hotel.name}&roomType=디럭스&price=${hotel.deluxe}'">예약하기</button>
			</div>

			<div class="room">
				<h3>스위트</h3>
				<p>럭셔리한 인테리어와 최고의 편안함을 제공하는 스위트룸입니다.</p>
				<p>${hotel.suite}</p>
				<button class="btn book-btn" onclick="location.href='/hotelreservation?name=${hotel.name}&roomType=스위트&price=${hotel.suite}'">예약하기</button>
			</div>
		</div>
		<h3>오시는 길</h3>
		<input type = "hidden" id = "map_x" value = "${hotel.mapx}">
		<input type = "hidden" id = "map_y" value = "${hotel.mapy}">
		<div id = "map" class = "hotel_map"></div>
	</div>
	
	<script type = "text/javascript" src = "//dapi.kakao.com/v2/maps/sdk.js?appkey=b8314e6d575584c7e23cae7bdbb3bc39"></script>
	<script type = "text/javascript">
		var mapContainer = document.getElementById("map"); // 지도가 표시될 위치
		var map_x = parseFloat(document.getElementById("map_x").value); // 지도의 x좌표
		var map_y = parseFloat(document.getElementById("map_y").value); // 지도의 y좌표
		
		mapOption = {
			center : new kakao.maps.LatLng(map_x, map_y), // 중심 좌표
			level : 2, // 지도 확대 수준
			mapTypeId : daum.maps.MapTypeId.ROADMAP
		};
		
		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도 생성
		
		var marker_position = new kakao.maps.LatLng(map_x, map_y); // Marker 표시 위치
		
		var marker = new kakao.maps.Marker({ // Marker 생성
			position : marker_position
		})
		
		marker.setMap(map); // Marker가 지도 위에 표시되도록 설정
	</script>
</body>
</html>