<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title> cozypick </title> <link rel="icon" href="/image/메인로고.png" >
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/hotel/hotelbytype.css">
</head>
<body>
	<div class="container">
		<h1>타입별 숙소 선택</h1>
		<div class="button-container">
			<button onclick="showHotel('게스트하우스')">게스트하우스</button>
			<button onclick="showHotel('레지던스')">레지던스</button>
			<button onclick="showHotel('리조트')">리조트</button>
			<button onclick="showHotel('모텔')">모텔</button>
			<button onclick="showHotel('민박')">민박</button>
			<button onclick="showHotel('유스호스텔')">유스호스텔</button>
			<button onclick="showHotel('콘도')">콘도</button>
			<button onclick="showHotel('펜션')">펜션</button>
			<button onclick="showHotel('한옥')">한옥</button>
			<button onclick="showHotel('호텔')">호텔</button>
		</div>
		<div id="hotel-info" class="hotel-info"></div>
	</div>

	<script>
        function showHotel(type) {
            const xhr = new XMLHttpRequest();
            xhr.open("GET", "/hotel/data?type="+type, true);
            xhr.onreadystatechange = function() { // 서버 응답 상태가 변경될 때마다 호출
                if (xhr.readyState === 4 && xhr.status === 200) {
                	console.log(xhr.responseText);
                    const hotels = JSON.parse(xhr.responseText); // JSON 파싱
                    displayHotels(hotels); // HTML에 호텔 정보 표시
                }
            };
            xhr.send(); // AJAX 요청 전송
        }
        
        function displayHotels(hotels) {

            const hotelInfoDiv = document.getElementById("hotel-info");
            hotelInfoDiv.innerHTML = ""; // 기존 내용 초기화
            
            hotels.forEach((hotel, index) => {        
            	
            	const card = document.createElement("div");
				
            	card.classList.add("hotel-card");
				
            	// name 요소 생성 및 추가
            	const name = document.createElement("h2");
            	name.classList.add("hotel-name");
				
            	// 호텔 이름에서 특정 문자열을 '★'로 대체
            	const hotelName = hotel.name.includes('[한국관광 품질인증/Korea Quality]')
            	    ? hotel.name.replace('[한국관광 품질인증/Korea Quality]', '★품질인증된 숙소임 ㅇㅇ ★')
            	    : hotel.name;

            	name.textContent = "호텔이름: " + hotelName;

            	// 주소 요소 생성 및 추가
            	const address = document.createElement("p");
            	address.classList.add("hotel-address");
            	address.textContent = "주소: " + hotel.address;

            	// 상세보기 링크 생성 및 추가
            	const detailsLink = document.createElement("a");
            	detailsLink.classList.add("details-button");
            	detailsLink.textContent = "상세보기";
            	detailsLink.href = "/regionsearch5?default_num=" + encodeURIComponent(hotel.default_num); 
            	detailsLink.target = "_self";  // 현재 창에서 링크 열기

            	// 요소들을 카드에 추가
            	card.appendChild(name);
            	card.appendChild(address);
            	card.appendChild(detailsLink);

            	// 카드 요소를 hotelInfoDiv에 추가
            	hotelInfoDiv.appendChild(card);
                
            });
        }
        </script>

    </body>
    </html>