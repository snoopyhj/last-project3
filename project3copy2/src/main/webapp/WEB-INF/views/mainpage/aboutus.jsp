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
	        <a href="https://localhost:8444/" class="logo">cozypick</a>
	        <div class="nav">
	            <a href="https://localhost:8444/#">HOME</a> 
	            <a href="#RESERVATION" onclick="scrollToReservation(event)">RESERVATION</a>
	            <a href="#CONTACT">CONTACT</a>
	            <a href="#FAQ" onclick="scrollToReservation2(event)">FAQ's</a>
	            <a href="https://localhost:8444/aboutus">ABOUT US</a> 
	        </div>
	        <div>
	            <a href="https://localhost:8443/register" class="register">회원가입</a>
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
                        <p>Cozy Pick은 고객의 휴식과 만족을 위해 최고의 숙소를 선별하여 제공합니다. 편안한 여행을 위해 다양한 테마 숙소를 만나보세요.</p>
                    </div>
                    <div id="history" class="content-box hidden">
                        <p>Cozy Pick은 2018년에 설립되어 지속적인 성장과 발전을 이루어왔습니다. 매년 고객 만족도를 높이기 위해 노력하고 있습니다.</p>
                    </div>
                    <div id="business" class="content-box hidden">
                        <p>Cozy Pick의 사업 영역은 국내외 숙소 예약 플랫폼입니다. 다양한 파트너들과 협력하여 폭넓은 선택지를 제공합니다.</p>
                    </div>
                    <div id="contact" class="content-box hidden">
                        <div id="contact-map" class="hotel-map" style="width: 100%; height: 350px; border-radius: 8px;"></div>
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
		document.addEventListener('DOMContentLoaded', async function () {
								    console.log('페이지가 로드되었습니다!');
								    await fetchUserInfo();
									
								});

								async function fetchUserInfo() {
								    try {
								        const rememberMeChecked = getCookie('rememberMe') === 'true';
								        let response = await fetch('https://localhost:8443/userinfo', {
								            method: 'GET',
								            credentials: 'include'
								        });

								        if (response.status === 401 && rememberMeChecked) {
								            console.log("엑세스 토큰 만료 - 리프레시 토큰으로 재발급 요청");
								            await refreshAccessToken();
								            response = await fetch('https://localhost:8443/userinfo', {
								                method: 'GET',
								                credentials: 'include'
								            });
								        }

								        if (!response.ok) {
								            throw new Error('사용자 정보를 가져오는 데 실패했습니다.');
								        }

								        const userInfo = await response.json();
										
								        changeLoginButtonToMyPage(userInfo);
										return userInfo; // 반환 추가
								    } catch (error) {
								        console.error('사용자 정보를 가져오는 중 오류 발생:', error);
								    }
								}
								function getCookie(name) {
								    const cookieValue = document.cookie
								        .split('; ')
								        .find(row => row.startsWith(name + '='));
								    
								    return cookieValue ? cookieValue.split('=')[1] : null;
								}


								async function refreshAccessToken() {
								    try {
								        const response = await fetch('https://localhost:8443/refresh-token', {
								            method: 'POST',
								            credentials: 'include'
								        });

								        if (!response.ok) {
								            throw new Error('리프레시 토큰이 유효하지 않거나 만료되었습니다.');
								        }

								        console.log("새로운 엑세스 토큰이 쿠키에 저장되었습니다.");
								    } catch (error) {
								        console.error('액세스 토큰 재발급 실패:', error);
								        alert('세션이 만료되었습니다. 다시 로그인해 주세요.');
								        window.location.href = 'https://localhost:8443/login';
								    }
								}

								function changeLoginButtonToMyPage(userInfo) {
								    const loginBtn = document.querySelector('.login');
								    const registerBtn = document.querySelector('.register');
								    if (loginBtn) {
								        loginBtn.innerHTML = '마이 페이지';
								        loginBtn.href = 'https://localhost:8443/mypage';
								        registerBtn.style.display = 'none';

								        if (userInfo.admin) {
								            const adminLink = document.createElement('a');
								            adminLink.href = 'https://localhost:8443/admin';
								            adminLink.classList.add('admin-mode');
								            adminLink.innerText = '관리자 모드 접속';

								            const nav = document.querySelector('.nav');
								            nav.appendChild(adminLink);
								        }
								    } else {
								        console.error("로그인 버튼이 없습니다.");
								    }
								}
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