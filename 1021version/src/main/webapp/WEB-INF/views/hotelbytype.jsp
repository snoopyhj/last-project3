<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>타입별 숙소 선택</title>
    <link rel="stylesheet" type="text/css"
        href="${pageContext.request.contextPath}/css/hotelbytype.css">
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

            hotels.forEach(hotel => {            
                const card = 
                	hotel.name;        
                hotelInfoDiv.innerHTML += card;
            });
        }
    </script>
</body>
</html>