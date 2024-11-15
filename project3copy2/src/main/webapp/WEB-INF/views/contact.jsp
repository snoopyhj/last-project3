<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/contact.css">
</head>
<body>
	<div class="wrap">
	    <div class="header">
	        <a href="https://localhost:8444/#" class="logo">cozypick</a>
	        <div class="nav">
	            <a href="https://localhost:8444/#">HOME</a> 
	            <a href="#RESERVATION" onclick="scrollToReservation(event)">RESERVATION</a>
	            <a href="#CONTACT">CONTACT</a>
	            <a href="#FAQ" onclick="scrollToReservation2(event)">FAQ's</a>
	            <a href="http://localhost:8084/aboutus">ABOUT US</a> 
	        </div>
	        <div>
	            <a href="https://localhost:8443/register" class="login">회원가입</a>
	            <a href="https://localhost:8443/login" class="login">LOGIN</a>
	        </div>
	    </div>   
	 
	    <main>
			<div class="CONTACT" id="CONTACT">
			         <h2>고객센터</h2>
			         <p>고객행복센터(전화): 오전 9시 ~ 새벽 3시 운영</p>
			         <p>카카오톡 문의: 24시간 운영</p>
			         <div class="contact-buttons">
			             <button class="phone-btn">📞 1670-6250</button>
			             <button class="kakao-btn"><a href="#" onclick = "chatbotpopup()">💬 chatbot</a></button>
			             <button class="email-btn"><a href="/email">📧 이메일 문의</a></button>
			             <button class="question-btn"><a href="/question">자주 묻는 질문</a></button>
			         </div>
			        </div>
	    </main>
	    <footer>
	        <pre>
	            Some hotels require cancellation at least 24 hours before check-in.
	            © 2024 COZYPICK. All rights reserved.
	            Dispute Settlement: Tel: 010-4717-2540 | Email: dica200@paran.com
	            COZYPICK Co., Ltd., 171, Jangseungbaegi-ro, Dongjak-gu, Seoul, Republic of Korea
	            Company Representative: Hyunwoo Bae
	        </pre>
	    </footer>
	</div>

    <!-- Kakao Map API Script (API 키 확인 필요) -->
    <script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b8314e6d575584c7e23cae7bdbb3bc39"></script>
    <script>
		function showContent(id, button) {
		    // 모든 콘텐츠 박스를 숨깁니다.
		    const contentBoxes = document.querySelectorAll('.content-box');
		    contentBoxes.forEach((box) => box.classList.add('hidden'));

		    // 선택된 콘텐츠 박스를 표시합니다.
		    const selectedBox = document.getElementById(id);
		    selectedBox.classList.remove('hidden');

		    // 모든 버튼을 기본 스타일로 되돌립니다.
		    const buttons = document.querySelectorAll('.buttons-container button');
		    buttons.forEach((btn) => {
		        btn.classList.remove('filled-button');
		        btn.classList.add('outline-button');
		    });

		    // 클릭된 버튼을 활성화된 스타일로 변경합니다.
		    button.classList.remove('outline-button');
		    button.classList.add('filled-button');

		    // CONTACT US 버튼을 클릭할 때 지도를 초기화합니다.
		    if (id === 'contact') {
		        initializeContactMap();
		    }
		}

		// CONTACT US 위치 지도 초기화 함수
		function initializeContactMap() {
		    const container = document.getElementById('contact-map');
		    const options = {
		        center: new kakao.maps.LatLng(37.513027, 126.939915),
		        level: 4
		    };

		    // 지도 생성
		    const map = new kakao.maps.Map(container, options);

		    // 마커 생성 및 지도에 추가
		    const markerPosition = new kakao.maps.LatLng(37.513027, 126.939915);
		    const marker = new kakao.maps.Marker({
		        position: markerPosition
		    });
		    marker.setMap(map);
		}

        // 페이지 로드 시 기본 콘텐츠 표시
        document.addEventListener("DOMContentLoaded", function() {
            // 'intro' 콘텐츠 표시 및 해당 버튼 활성화
            const introButton = document.querySelector('.buttons-container button');
            showContent('intro', introButton);
        });
	</script>
</body>
</html>