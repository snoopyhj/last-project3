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
	            <a href="#FAQ" onclick="scrollToReservation2(event)">FAQ's</a>
				<a href="https://localhost:8444/contact">CONTACT</a>
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
														    <h2>Our History</h2>
														    <div class="timeline">
														        <div class="timeline-item">
														            <div class="timeline-year">2018</div>
														            <div class="timeline-content">
														                <p>Cozy Pick 설립.</p>
														            </div>
														        </div>
														        <div class="timeline-item">
														            <div class="timeline-year">2019</div>
														            <div class="timeline-content">
														                <p>국내 숙박업체와의 파트너십 강화.</p>
														            </div>
														        </div>
														        <div class="timeline-item">
														            <div class="timeline-year">2020</div>
														            <div class="timeline-content">
														                <p>리뷰 시스템 및 맞춤형 추천 기능 도입.</p>
														            </div>
														        </div>
														        <div class="timeline-item">
														            <div class="timeline-year">2021</div>
														            <div class="timeline-content">
														                <p>글로벌 확장과 함께 'One World, Connecting Smiles.' 비전 선언.</p>
														            </div>
														        </div>
														        <div class="timeline-item">
														            <div class="timeline-year">2023</div>
														            <div class="timeline-content">
														                <p>이벤트 및 행사 기획 서비스 확장.</p>
														            </div>
														        </div>
														    </div>
														</div>

									<div id="business" class="content-box hidden">
									    <!-- 사업 영역 섹션 -->
									    <h2>Our Business Areas</h2>
									    <div class="business-area">
									        <div class="business-item">
									            <img src="https://cdn.pixabay.com/photo/2016/11/17/09/28/hotel-1831072_1280.jpg" alt="숙박 사업" class="business-image">
									            <h3>숙박 사업</h3>
									            <p>국내외 숙소 예약 서비스를 제공하여 다양한 선택지를 제공합니다.</p>
									        </div>
									        <div class="business-item">
									            <img src="https://media.istockphoto.com/id/1829241109/ko/%EC%82%AC%EC%A7%84/%ED%95%A8%EA%BB%98-%EB%B8%8C%EB%9F%B0%EC%B9%98%EB%A5%BC-%EC%A6%90%EA%B8%B0%EA%B8%B0.jpg?s=2048x2048&w=is&k=20&c=fIciWUwBtW0EjucdVKTmdnHtWbIGrb_n8Ln7OT9_z1M=" alt="식음료 서비스" class="business-image">
									            <h3>식음료 서비스</h3>
									            <p>고객의 편의를 위해 다양한 지역 음식 및 음료를 제공합니다.</p>
									        </div>
									        <div class="business-item">
									            <img src="https://cdn.pixabay.com/photo/2020/01/15/17/38/fireworks-4768501_640.jpg" alt="이벤트 및 행사" class="business-image">
									            <h3>이벤트 및 행사</h3>
									            <p>고객을 위한 특별한 이벤트와 행사를 기획하고 운영합니다.</p>
									        </div>
									        <div class="business-item">
									            <img src="https://media.istockphoto.com/id/1169551209/ko/%EC%82%AC%EC%A7%84/%EA%B0%80%EC%9E%A5-%EC%B9%9C%ED%95%9C-%EC%B9%9C%EA%B5%AC%EC%99%80-%ED%95%A8%EA%BB%98-%EC%B6%94%EC%96%B5-%EB%A7%8C%EB%93%A4%EA%B8%B0.jpg?s=2048x2048&w=is&k=20&c=s9U7MS6Sv4-VsnH3O_X0BWL3Zy98f6lNcUjAuDhsDOw=" alt="교통 서비스" class="business-image">
									            <h3>교통 서비스</h3>
									            <p>편리한 여행을 위해 다양한 교통 서비스를 제공합니다.</p>
									        </div>
									    </div>
									</div>
                    <div id="contact" class="content-box hidden">
                        <div id="contact-map" class="hotel-map" style="width: 100%; height: 350px; border-radius: 8px;"></div>
						<div id="location">
						    <h2>오시는 길</h2>
						    <p>서울시 동작구 장승배기로 171 2층, 3층 코지픽<br>COZYPICK Co., Ltd., 171, Jangseungbaegi-ro, Dongjak-gu, Seoul, Republic of Korea</p>
						    <h2>Email</h2>
						    <p>webmaster@sanriokorea.co.kr</p>
						    <h2>Tel</h2>
						    <p>+82 (0) 2 543 3810</p>
						    <h2>Fax</h2>
						    <p>+82 (0) 2 543 2904</p>
						</div>
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