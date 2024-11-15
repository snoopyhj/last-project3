<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/aboutus.css">
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
	        <div class="company-section">
	            <h1>COMPANY</h1>
		        <div class="buttons-container">
		            <button class="outline-button" onclick="showContent('intro', this)">회사소개</button>
		            <button class="outline-button" onclick="showContent('history', this)">회사연혁</button>
		            <button class="outline-button" onclick="showContent('business', this)">사업영역</button>
		            <button class="outline-button" onclick="showContent('contact', this)">CONTACT US</button>
		        </div>

                <div class="content-container">
                    <div id="intro" class="content-box hidden">
						<div class="intro-section">
										        <h2>Cozy Pick 창업자, 조현지</h2>
										        <p>“Cozy Pick은 단순한 호텔 예약 사이트가 아닙니다. 고객의 여행 경험을 더욱 특별하게 만들기 위해 탄생한 플랫폼입니다. Cozy Pick이라는 이름에는 '따뜻하고 아늑한 장소를 선택하다'라는 의미가 담겨 있으며, 고객 여러분이 머무는 순간마다 편안함을 느낄 수 있도록 최선을 다하고자 합니다. 세상을 여행하면서 얻는 휴식의 의미는 사람마다 다르지만, 우리는 그 각기 다른 의미를 소중히 여깁니다. 그래서 Cozy Pick은 다양한 테마의 숙소를 엄선하여 제공함으로써 고객 개개인의 여행 경험이 더욱 뜻깊어지기를 희망합니다.</p>
										        <p>우리가 세심하게 고른 숙소는 단지 숙박을 위한 장소가 아니라, 고객님이 일상의 피로를 풀고 재충전할 수 있는 진정한 안식처입니다. 바쁜 일상을 떠나 편안한 휴식을 취하고 싶은 순간에, Cozy Pick은 가장 안심하고 머물 수 있는 공간을 제공하는 것을 목표로 삼고 있습니다. 더불어, 고객의 다양한 요구를 충족시키기 위해 다채로운 결제 옵션을 마련해, 누구나 편리하게 예약할 수 있는 시스템을 갖추고 있습니다. 우리에게 가장 중요한 것은 고객이 Cozy Pick을 통해 여행지에서 진정한 휴식을 찾을 수 있도록 돕는 것입니다.”</p>
										    </div>
										    <div class="intro-section">
										        <h2>Cozy Pick 대표이사 배현우</h2>
										        <p>“항상 Cozy Pick을 신뢰해 주시고, 저희와 함께해 주시는 모든 고객님께 진심으로 감사드립니다. Cozy Pick은 설립 초기부터 ‘고객의 만족과 행복을 최우선으로’라는 가치를 기반으로 운영되고 있습니다. 우리는 고객 여러분께 신뢰성 높은 리뷰 시스템을 제공하여 다른 이용자의 솔직한 경험을 공유하고자 합니다. 공정하고 투명한 리뷰 시스템은 고객이 실제 후기를 바탕으로 선택할 수 있도록 돕고, Cozy Pick만의 신뢰도를 높이는 중요한 요소입니다. 또한, 고객님의 선호도와 예약 이력을 바탕으로 한 맞춤형 추천 시스템을 통해 더욱 효율적이고 즐거운 예약 경험을 제공합니다.</p>
										        <p>2021년에 새롭게 설정한 비전인 'One World, Connecting Smiles.'은 Cozy Pick이 전 세계 고객들과 더 깊은 유대감을 형성하고, 여행지마다 미소가 가득할 수 있도록 노력하겠다는 약속입니다. Cozy Pick은 고객님의 소중한 여행 순간마다 함께하며, 온 마음을 다해 진심 어린 서비스를 제공하고자 합니다. 이 비전을 위해 우리는 숙소와 서비스의 품질을 지속적으로 개선하며, 새로운 트렌드와 고객의 목소리에 귀 기울이겠습니다. Cozy Pick과 함께라면 고객님의 여정이 더욱 특별해질 것입니다. 전 세계의 고객님이 Cozy Pick을 통해 진정한 행복과 휴식을 찾을 수 있도록, 앞으로도 최선을 다하겠습니다.”</p>
										    </div>
										</div>
                    <div id="history" class="content-box hidden">
                        <p>Cozy Pick은 2018년에 설립되어 지속적인 성장과 발전을 이루어왔습니다. 매년 고객 만족도를 높이기 위해 노력하고 있습니다.</p>
                    </div>
                    <div id="business" class="content-box hidden">
                        <p>Cozy Pick의 사업 영역은 국내외 숙소 예약 플랫폼입니다. 다양한 파트너들과 협력하여 폭넓은 선택지를 제공합니다.</p>
                    </div>
                    <div id="contact" class="content-box hidden">
                        <div id="contact-map" class="hotel-map" style="width: 100%; height: 300px; border-radius: 8px;"></div>
                    </div>
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