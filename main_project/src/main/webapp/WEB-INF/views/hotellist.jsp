<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>호텔 리스트</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/hotellist.css">
</head>
<body>

<!-- Header -->
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

<!-- Main Content -->
<main class="main-content">
    <aside class="filter-bar">
		<h3>필터 검색</h3>
		      <div class="filter-card">
		          <label for="accommodationType">숙박 유형</label>
		          <select id="accommodationType" onchange="showHotelByType()">
		              <option value="">전체</option>
		              <option value="호텔">호텔</option>
		              <option value="콘도">콘도</option>
		              <option value="유스호스텔">유스호스텔</option>
		              <option value="펜션">펜션</option>
		              <option value="모텔">모텔</option>
		              <option value="민박">민박</option>
		              <option value="게스트하우스">게스트하우스</option>
		              <option value="레지던스">레지던스</option>
		              <option value="한옥">한옥</option>
		              <option value="리조트">리조트</option>
		          </select>
		      </div>

		      <div class="filter-card">
		          <label for="priceRange">가격 범위</label>
		          <input type="range" id="priceRange" min="50000" max="1000000" step="10000" value="100000" 
		                 onchange="updatePrice(this.value)">
		          <span id="priceValue">100000원 이하</span>
		      </div>

		      <button class="filter-btn" onclick="applyFilters()">필터 적용</button>
		  </aside>

	<section class="hotel-container">
	    <c:forEach var="eachhotel" items="${hotel_list}">
	        <div class="hotel-card" 
	             onclick="location.href='/hoteldetail?name=${eachhotel.name}'" 
	             style="cursor: pointer;">
	            <img src="${eachhotel.img1}" alt="${eachhotel.name}" class="hotel-img">
	            <div class="hotel-info">
	                <h3>${eachhotel.name}</h3>
	                <p>주소: ${eachhotel.address}</p>
	                <p>전화번호: ${eachhotel.tel}</p>
					<p class="price">${eachhotel.standard} ~</p>
	            </div>
	        </div>
	        <div class="divider"></div>
	    </c:forEach>
	</section>
</main>

<script>
    function updatePrice(value) {
        document.getElementById("priceValue").innerText = value + "원 이하";
    }

    function applyFilters() {
        const accommodationType = document.getElementById("accommodationType").value;
        const price = document.getElementById("priceRange").value;
        const roomType = document.getElementById("roomType").value;

        location.href = `/regionsearch?type=${accommodationType}&price=${price}&roomType=${roomType}`;
    }
</script>

</body>
</html>