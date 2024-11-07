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
		
		<div class="filter-card">
		    
		    <label>
		        <input type="radio" name="accommodationType" value="" onclick="applyAccommodationFilter()"> 전체
		    </label><br>
		    <label>
		        <input type="radio" name="accommodationType" value="호텔" onclick="applyAccommodationFilter()"> 호텔
		    </label><br>
		    <label>
		        <input type="radio" name="accommodationType" value="리조트" onclick="applyAccommodationFilter()"> 리조트
		    </label><br>
		    <label>
		        <input type="radio" name="accommodationType" value="유스호스텔" onclick="applyAccommodationFilter()"> 유스호스텔
		    </label><br>
		    <label>
		        <input type="radio" name="accommodationType" value="펜션" onclick="applyAccommodationFilter()"> 펜션
		    </label><br>
		    <label>
		        <input type="radio" name="accommodationType" value="모텔" onclick="applyAccommodationFilter()"> 모텔
		    </label><br>
		    <label>
		        <input type="radio" name="accommodationType" value="민박" onclick="applyAccommodationFilter()"> 민박
		    </label><br>
		    <label>
		        <input type="radio" name="accommodationType" value="게스트하우스" onclick="applyAccommodationFilter()"> 게스트하우스
		    </label><br>
		    <label>
		        <input type="radio" name="accommodationType" value="레지던스" onclick="applyAccommodationFilter()"> 레지던스
		    </label><br>
		    <label>
		        <input type="radio" name="accommodationType" value="한옥" onclick="applyAccommodationFilter()"> 한옥
		    </label><br>
		    <label>
				<input type="radio" name="accommodationType" value="콘도" onclick="applyAccommodationFilter()"> 콘도
		        
	
		    </label>
		</div>

		<div class="filter-card2">
		    <label for="priceRange">가격 범위</label>	
		    <input type="range" id="priceRange" min="50000" max="500000" step="10000" value="500000" 
		           oninput="updatePrice(this.value)">
		    <span id="priceValue">500000원 이하</span>
		</div>
	
		  </aside>

		  
		  
		  <section class="hotel-container">
		      <div class="sorting-bar">
		          <select id="sortOptions" onchange="sortHotels()">
		              <option value="">정렬</option>
		              <option value="priceLow">가격 낮은순</option>
		              <option value="priceHigh">가격 높은순</option>
		              <option value="popularity">인기순</option>
		              <option value="recommended">추천순</option>
		          </select>
		      </div>
		      <div id="hotelCards">
		          <c:forEach var="eachhotel" items="${hotel_list}">
		              <div class="hotel-card" onclick="searchByDefaultNum('${eachhotel.default_num}')">
		                  <img src="${eachhotel.img1}" alt="${eachhotel.name}" class="hotel-img">
		                  <div class="hotel-info">
		                      <h3>${eachhotel.name}</h3>
		                      <p>주소: ${eachhotel.address}</p>
		                      <p>전화번호: ${eachhotel.tel}</p>
		                      <p class="price">${eachhotel.standard} ~</p>
							  <p class="resevations" style="display: none;">${eachhotel.reservation_count}</p>
							  <p class="type" style="display: none;" >${eachhotel.type}</p>

		                  </div>
		              </div>
		              <div class="divider"></div>
		          </c:forEach>
		      </div>
		  </section>
</main>

<script>
	let originalHotelCards = [];

	window.addEventListener('DOMContentLoaded', () => {
	    const hotelCardsContainer = document.getElementById('hotelCards');
	    originalHotelCards = Array.from(hotelCardsContainer.querySelectorAll('.hotel-card')); // 원본 리스트 저장
	});

	function updatePrice(value) {
	    document.getElementById("priceValue").innerText = value + "원 이하";
	    applyFilters(); // 가격 변경 시 필터 적용
	}

	function applyFilters() {
	    const selectedType = document.querySelector('input[name="accommodationType"]:checked')?.value || "";
	    const maxPrice = parseInt(document.getElementById("priceRange").value);
	    const hotelCardsContainer = document.getElementById('hotelCards');

	    // hotelCardsContainer 초기화
	    hotelCardsContainer.innerHTML = '';

	    // 원본 리스트에서 조건에 맞는 호텔 카드만 추가
	    originalHotelCards.forEach(card => {
	        const hotelType = card.querySelector('.type').innerText.trim();
	        const priceText = card.querySelector('.price').innerText.replace(/,/g, '').replace(/[^\d]/g, '');
	        const hotelPrice = parseInt(priceText);

	        // 조건: 선택된 유형과 가격 범위 모두 충족
	        if ((selectedType === "" || hotelType === selectedType) && hotelPrice <= maxPrice) {
	            hotelCardsContainer.appendChild(card);
	        }
	    });
	}

	function sortHotels() {
	    const sortOption = document.getElementById("sortOptions").value;
	    const hotelCardsContainer = document.getElementById('hotelCards');
	    const hotelCards = Array.from(hotelCardsContainer.querySelectorAll('.hotel-card'));

	    // 정렬 기준에 따라 호텔 카드 정렬
	    hotelCards.sort((a, b) => {
	        const priceA = parseInt(a.querySelector('.price').innerText.replace(/,/g, '').replace(/[^\d]/g, ''));
	        const priceB = parseInt(b.querySelector('.price').innerText.replace(/,/g, '').replace(/[^\d]/g, ''));
	        const reservationsA = parseInt(a.querySelector('.resevations').innerText.replace(/,/g, ''));
	        const reservationsB = parseInt(b.querySelector('.resevations').innerText.replace(/,/g, ''));
	        switch (sortOption) {
	            case 'priceLow':
	                return priceA - priceB; // 가격 낮은 순
	            case 'priceHigh':
	                return priceB - priceA; // 가격 높은 순
	            case 'popularity':
	                return reservationsB - reservationsA; // 인기순
	            default:
	                return 0;
	        }
	    });

	    // 정렬된 결과를 호텔 카드 컨테이너에 다시 추가하여 렌더링 업데이트
	    hotelCardsContainer.innerHTML = '';
	    hotelCards.forEach(card => hotelCardsContainer.appendChild(card));
	}

	function applyAccommodationFilter() {
	    const selectedType = document.querySelector('input[name="accommodationType"]:checked')?.value || "";
	    const maxPrice = parseInt(document.getElementById("priceRange").value);
	    const hotelCardsContainer = document.getElementById('hotelCards');

	    // hotelCardsContainer 초기화
	    hotelCardsContainer.innerHTML = '';

	    // 원본 리스트에서 조건에 맞는 호텔 카드만 추가
	    originalHotelCards.forEach(card => {
	        const hotelType = card.querySelector('.type').innerText.trim();
	        const priceText = card.querySelector('.price').innerText.replace(/,/g, '').replace(/[^\d]/g, '');
	        const hotelPrice = parseInt(priceText);

	        // 조건: 선택된 유형과 가격 범위 모두 충족
	        if ((selectedType === "" || hotelType === selectedType) && hotelPrice <= maxPrice) {
	            hotelCardsContainer.appendChild(card);
	        }
	    });
	}
	
	function searchByDefaultNum(default_num) {
	    if (default_num) {
	        location.href = "/regionsearch5?default_num=" + encodeURIComponent(default_num);
	    } else {
	        alert("유효한 숙소를 선택해주세요.");
	    }
	}
</script>

</body>
</html>