<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>${hotel.name} 호텔 상세정보</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/hoteldetail.css">
</head>
<body>
	<header class="header">
	    <a href="http://localhost:8084" class="logo">cozypick</a>
	    <nav class="nav">
	        <a href="http://localhost:8084">HOME</a>
	        <a href="http://localhost:8084/#ABOUTUS">ABOUT US</a>
	        <a href="http://localhost:8084/#RESERVATION">RESERVATION</a>
	        <a href="http://localhost:8084/#REVIEW">REVIEW</a>
	        <a href="http://localhost:8084/#CONTACT">CONTACT</a>
	    </nav>
	    <div class="auth-buttons">
	        <a href="/register" class="login">회원가입</a>
	        <a href="https://localhost:8443/login" class="login">LOGIN</a>
	    </div>
	</header>
<!-- 전체 페이지 컨테이너 -->
<div class="hotel-detail-page">

	<!-- 이미지와 지도 섹션 -->
	<div class="image-map-container">
		<img src="${hotel.img1}" alt="Hotel Image" class="hotel-main-image">
		<div id="map" class="hotel-map"></div>
	</div>

	<!-- 호텔 기본 정보 및 요약 -->
	<div class="hotel-summary">
		<h1 class="hotel-name">${hotel.name}</h1>
		<p class="hotel-address">${hotel.address}</p>
		<p class="hotel-tel">${hotel.tel}</p>
		<p class="hotel-comment">${hotel.coment}</p>
		<p class="hotel-type">${hotel.type}</p>
	</div>

	<!-- 객실 정보 섹션 -->
	<div class="room-types">
		<h2>객실 종류 및 요금</h2>
		<div class="room">
			<h3>스탠다드룸</h3>
			<p>기본적인 편의시설을 갖춘 스탠다드룸입니다.</p>
			<p class="room-price">${hotel.standard}원</p>
			<button class="btn book-btn" onclick="location.href='/hotelreservation?name=${hotel.name}&roomType=스탠다드&price=${hotel.standard}'">예약하기</button>
		</div>

		<div class="room">
			<h3>디럭스룸</h3>
			<p>넓은 공간과 고급 침구를 갖춘 디럭스룸입니다.</p>
			<p class="room-price">${hotel.deluxe}원</p>
			<button class="btn book-btn" onclick="location.href='/hotelreservation?name=${hotel.name}&roomType=디럭스&price=${hotel.deluxe}'">예약하기</button>
		</div>

		<div class="room">
			<h3>스위트룸</h3>
			<p>럭셔리한 인테리어와 최고의 편안함을 제공하는 스위트룸입니다.</p>
			<p class="room-price">${hotel.suite}원</p>
			<button class="btn book-btn" onclick="location.href='/hotelreservation?name=${hotel.name}&roomType=스위트&price=${hotel.suite}'">예약하기</button>
		</div>
	</div>

	<!-- 리뷰 작성 및 목록 섹션 -->
	<div class="review-section">
		<div class="review-form">
		    <h2>리뷰 작성하기</h2>
		    <form action="/addReview" method="post">
		        <input type="hidden" name="defaultNum" value="${hotel.default_num}">
		        <textarea name="reviewText" placeholder="리뷰를 작성해주세요" required></textarea>

		        <!-- 별 평점 선택 -->
		        <div class="star-rating">
		            <input type="hidden" name="rating" id="rating" required>
		            <span class="star" data-value="1">&#9733;</span>
		            <span class="star" data-value="2">&#9733;</span>
		            <span class="star" data-value="3">&#9733;</span>
		            <span class="star" data-value="4">&#9733;</span>
		            <span class="star" data-value="5">&#9733;</span>
		        </div>

		        <button type="submit">리뷰 제출</button>
		    </form>
		</div>

		<!-- 리뷰 목록 표시 -->
		<h3 class="review-list-title">리뷰 목록</h3>
		<div class="review-list">
		    <c:forEach items="${reviews}" var="review">
		        <div class="review-item">
		            <div class="rating-stars">
		                <c:forEach begin="1" end="5" var="i">
		                    <span class="${i <= review.rating ? 'filled-star' : 'empty-star'}">&#9733;</span>
		                </c:forEach>
		            </div>
		            <p><strong>작성자:</strong> ${review.userId}</p>
					<p><strong>작성일:</strong>
					    <span class="relative-time" data-timestamp="<fmt:formatDate value='${review.createdAt}' pattern='yyyy-MM-dd\'T\'HH:mm:ss'/>">
					        <fmt:formatDate value="${review.createdAt}" pattern="yyyy-MM-dd HH:mm:ss"/>
					    </span>
					</p>
		            <p class="review-content">${review.reviewText}</p>
		        </div>
		        <hr>
		    </c:forEach>
		</div>

	<!-- 지도 좌표 정보 -->
	<input type="hidden" id="map_x" value="${hotel.mapx}">
	<input type="hidden" id="map_y" value="${hotel.mapy}">
</div>

<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b8314e6d575584c7e23cae7bdbb3bc39"></script>
<script>
	var mapContainer = document.getElementById('map'),
	    mapOption = { 
	        center: new kakao.maps.LatLng(parseFloat(document.getElementById('map_x').value), parseFloat(document.getElementById('map_y').value)),
	        level: 4 
	    };
	var map = new kakao.maps.Map(mapContainer, mapOption); 
	var marker = new kakao.maps.Marker({
	    position: new kakao.maps.LatLng(parseFloat(document.getElementById('map_x').value), parseFloat(document.getElementById('map_y').value)) 
	});
	marker.setMap(map);
	
	document.querySelectorAll('.star-rating .star').forEach(star => {
	    star.addEventListener('click', function() {
	        const ratingValue = this.getAttribute('data-value');
	        document.getElementById('rating').value = ratingValue;

	        // 클릭된 별과 그 이하의 별들에만 'filled-star' 클래스를 추가
	        document.querySelectorAll('.star-rating .star').forEach(s => {
	            s.classList.remove('filled-star');
	        });
	        for (let i = 0; i < ratingValue; i++) {
	            document.querySelectorAll('.star-rating .star')[i].classList.add('filled-star');
	        }
	    });
	});
	
	document.addEventListener("DOMContentLoaded", function() {
	    // 모든 .relative-time 요소를 찾아 처리
	    document.querySelectorAll(".relative-time").forEach(element => {
	        const timestamp = new Date(element.getAttribute("data-timestamp"));
	        element.textContent = getRelativeTime(timestamp);
	    });
	});

	function getRelativeTime(timestamp) {
	    const now = new Date();
	    const diffInMs = now - timestamp;
	    const diffInSeconds = Math.floor(diffInMs / 1000);
	    const diffInMinutes = Math.floor(diffInSeconds / 60);
	    const diffInHours = Math.floor(diffInMinutes / 60);
	    const diffInDays = Math.floor(diffInHours / 24);
	    const diffInMonths = Math.floor(diffInDays / 30);

	    if (diffInDays < 1) {
	        if (diffInHours < 1) {
	            return diffInMinutes < 1 ? "방금 전" : `${diffInMinutes}분 전`;
	        }
	        return `${diffInHours}시간 전`;
	    } else if (diffInDays < 30) {
	        return `${diffInDays}일 전`;
	    } else if (diffInMonths < 12) {
	        return `${diffInMonths}달 전`;
	    } else {
	        const years = Math.floor(diffInMonths / 12);
	        return `${years}년 전`;
	    }
	}
	
</script>

</body>
</html>
