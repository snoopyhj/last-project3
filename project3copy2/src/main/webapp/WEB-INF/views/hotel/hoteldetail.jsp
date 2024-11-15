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
	    <a href="https://localhost:8444" class="logo">cozypick</a>
	    <nav class="nav">
	        <a href="https://localhost:8444">HOME</a>
	        <a href="https://localhost:8444/#ABOUTUS">ABOUT US</a>
	        <a href="https://localhost:8444/#RESERVATION">RESERVATION</a>
	        <a href="https://localhost:8444/#REVIEW">REVIEW</a>
	        <a href="https://localhost:8444/#CONTACT">CONTACT</a>
	    </nav>
	    <div class="auth-buttons">
	        <a href="https://localhost:8443/register" class="register">회원가입</a>
	        <a href="https://localhost:8443/login" class="login">LOGIN</a>
	    </div>
		<div id="loading-message" class="loading">Loading user information...</div>
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
		<button class="favorite-btn" data-default-num="${hotel.default_num}">♥</button>
	</div>

	
	<div class="review-section">
	
	    <!-- 가로 스크롤 컨테이너 -->
	    <div class="review-list" id="reviewList">
	        <c:forEach items="${reviews}" var="review">
	            <div class="review-item" onclick="toggleReviewExpansion(this)">
	                <div class="rating-stars">
	                    <c:forEach begin="1" end="5" var="i">
	                        <span class="${i <= review.rating ? 'filled-star' : 'empty-star'}">&#9733;</span>
	                    </c:forEach>
	                </div>
	                <p><strong>작성자:</strong> ${review.userId}</p>
	                <p><strong>작성일:</strong> 
	                    <fmt:formatDate value="${review.createdAt}" pattern="yyyy-MM-dd"/>
	                </p>
	                <p class="review-content">${review.reviewText}</p>
	            </div>
	        </c:forEach>
	    </div>
	</div>
	
	
	<!-- 객실 정보 섹션 -->
	<!-- 객실 정보 섹션 -->
	<div class="room-types">
	    <h2>객실 종류 및 요금</h2>
	    
	    <!-- 스탠다드룸 -->
	    <div class="room">
	        <h3>스탠다드룸</h3>
	        <p>기본적인 편의시설을 갖춘 스탠다드룸입니다.</p>
	        <p class="room-price">${hotel.standard}원</p>
	        <form action="/chooseRoom" method="POST">
	            <input type="hidden" name="roomType" value="스탠다드룸">
	            <input type="hidden" name="hotelName" value="${hotel.name}">
	            <input type="hidden" name="price" value="${hotel.standard}">
				<input type="hidden" name="defaultNum" value="${defaultNum}">
	            <button type="submit" class="btn book-btn">예약하기</button>
	        </form>
	    </div>

	    <!-- 디럭스룸 -->
	    <div class="room">
	        <h3>디럭스룸</h3>
	        <p>넓은 공간과 고급 침구를 갖춘 디럭스룸입니다.</p>
	        <p class="room-price">${hotel.deluxe}원</p>
	        <form action="/chooseRoom" method="POST">
	            <input type="hidden" name="roomType" value="디럭스룸">
	            <input type="hidden" name="hotelName" value="${hotel.name}">
	            <input type="hidden" name="price" value="${hotel.deluxe}">
				<input type="hidden" name="defaultNum" value="${defaultNum}">
	            <button type="submit" class="btn book-btn">예약하기</button>
	        </form>
	    </div>

	    <!-- 스위트룸 -->
	    <div class="room">
	        <h3>스위트룸</h3>
	        <p>럭셔리한 인테리어와 최고의 편안함을 제공하는 스위트룸입니다.</p>
	        <p class="room-price">${hotel.suite}원</p>
	        <form action="/chooseRoom" method="POST">
	            <input type="hidden" name="roomType" value="스위트룸">
	            <input type="hidden" name="hotelName" value="${hotel.name}">
	            <input type="hidden" name="price" value="${hotel.suite}">
				<input type="hidden" name="defaultNum" value="${defaultNum}">
	            <button type="submit" class="btn book-btn">예약하기</button>
	        </form>
	    </div>
	</div>

	<!-- 리뷰 작성 및 목록 섹션 -->
	<div class="review-section">
			<div class="review-form">
			    <h2>리뷰 작성하기</h2>
				<form id="reviewForm" action="/addReview" method="post">
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



	<!-- 지도 좌표 정보 -->
	<input type="hidden" id="map_x" value="${hotel.mapx}">
	
	<input type="hidden" id="map_y" value="${hotel.mapy}">
	
</div>


<!-- 호텔 정보 섹션 -->
<!-- 호텔 정보 섹션 -->
<div class="hotel-info-section">
    <h3 class="hotel-info-title">호텔 이용 정보</h3>
    
    <!-- 서비스 및 부대시설 -->
    <div class="hotel-info-category">
        <h4>서비스 및 부대시설</h4>
        <p>피트니스, 반려견 동반 가능, 사우나, 무선 인터넷, 욕실용품, 레스토랑, 금연 객실, TV, 에어컨, 짐 보관 가능, 샤워실, 무료 주차, 드라이기, 카드 결제 가능, 금고, 전기 주전자, 커피 머신, 주차장</p>
    </div>

    <!-- 숙소 이용 정보 -->
    <div class="hotel-info-category">
        <h4>숙소 이용 정보</h4>
        <p>자원재활용법에 따라 2024년 3월 29일부터 일부 숙소에서는 일회용 어메니티가 무료로 제공되지 않습니다. 일회용 어메니티 별도 구매는 숙소에 문의해주세요.</p>
    </div>
    
    <!-- 기본정보 -->
    <div class="hotel-info-category">
        <h4>기본 정보</h4>
        <p><strong>체크인:</strong> 16:00 | <strong>체크아웃:</strong> 11:00</p>
        <p>무료 Wi-Fi | 전 객실 금연 | 주차 무료 (1박 1대 무료/초과 시 차량 박당 1만원)</p>
        <p>호텔 내부 주차장 만차 시 외부 주차장 이용 가능 (강릉시 해안로 298-7)</p>
        <p>샴푸, 컨디셔너, 바디워시, 핸드워시는 친환경 다회용 제품으로 제공</p>
        <p>칫솔, 치약, 슬리퍼는 호텔 내 자판기에서 구매 가능</p>
    </div>
    
    <!-- 반려견 이용 정책 -->
    <div class="hotel-info-category">
        <h4>반려견 이용 정책</h4>
        <p>반려견 동반 객실 외 입실 불가 (위반 시 벌금 30만원)</p>
        <p>15kg 이상의 반려견은 공용 공간에서 입마개 착용 필수</p>
        <p>반려견 추가 시 1마리당 35,000원 추가 비용 발생</p>
        <p>반려견 어메니티: 배변패드, 배변봉투, 수건, 밥그릇 제공</p>
        <p>케이지 또는 견모차 이용 필수 | 펫모차 대여 가능</p>
        <p>반려견 동반 규정 위반 시 퇴실 조치 가능</p>
    </div>
    
    <!-- 인피니티 풀 안내 -->
    <div class="hotel-info-category">
        <h4>수영장 안내</h4>
        <p>수영장 : 08:00~22:00, 반려견 동반 가능</p>

    </div>


    <!-- 조식 정보 -->
    <div class="hotel-info-category">
        <h4>조식 정보</h4>
        <p> 식당/07:00~10:00</p>
        <p>성인 1인 25,000원, 소인 1인 10,000원, 유아 무료</p>
    </div>

    <!-- 취소 및 환불 규정 -->
    <div class="hotel-info-category">
        <h4>취소 및 환불 규정</h4>
        <p>체크인 3일 전: 100% 환불</p>
        <p>체크인 2일 전: 70% 환불</p>
        <p>체크인 당일 및 No-show: 환불 불가</p>
    </div>

    <!-- 확인 사항 및 기타 -->
    <div class="hotel-info-category">
        <h4>확인 사항 및 기타</h4>
        <p>최대 인원 초과 시 입실 불가</p>
        <p>미성년자는 보호자 동반 없이 이용 불가</p>
    </div>
</div>
    
    <!-- 기본정보 -->

<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=b8314e6d575584c7e23cae7bdbb3bc39"></script>
<script>
	document.addEventListener('DOMContentLoaded', async function () {
	    console.log('페이지가 로드되었습니다!');
	    const userInfo = await fetchUserInfo();
	    if (userInfo) {
	        changeLoginButtonToMyPage(userInfo);
	        await syncFavoriteButtons(userInfo.username);
	    }
	    
	    document.querySelectorAll('.favorite-btn').forEach(btn => {
	        btn.addEventListener('click', function (event) {
	            event.stopPropagation();
	            const defaultNum = this.getAttribute('data-default-num');
	            toggleFavorite(defaultNum);
	        });
	    });
	}); // <- 중괄호가 여기서 닫혀야 합니다.

						async function fetchUserInfo() {
						    try {
								const loadingMessage = document.getElementById('loading-message');
															loadingMessage.style.display = 'block';	
															const loginBtn = document.querySelector('.login');
															const registerBtn = document.querySelector('.register');
															loginBtn.style.display = 'none';
															registerBtn.style.display = 'none';
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
								function showLoginRegisterButtons() {
														const loginBtn = document.querySelector('.login');
														const registerBtn = document.querySelector('.register');
														loginBtn.style.display = 'inline-block';
														registerBtn.style.display = 'inline-block';
																			
														}
						        const userInfo = await response.json();
								
								if (response.status === 401) {
																loadingMessage.style.display = 'none';	
																console.log("비로그인 상태입니다.");
																showLoginRegisterButtons();
																															
															}
															loginBtn.style.display = 'inline-block';
															registerBtn.style.display = 'inline-block';
													        changeLoginButtonToMyPage(userInfo);
								return userInfo; // 반환 추가
						    } catch (error) {
								const loadingMessage = document.getElementById('loading-message');
								loadingMessage.style.display = 'none';	
								console.log("비로그인 상태입니다.");
								showLoginRegisterButtons();
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
							const loadingMessage = document.getElementById('loading-message');
																				loadingMessage.style.display = 'none';	
												    const loginBtn = document.querySelector('.login');
												    const registerBtn = document.querySelector('.register');
						    if (loginBtn) {
						        loginBtn.innerHTML = '마이 페이지';
						        loginBtn.href = 'https://localhost:8443/mypage';
						        registerBtn.style.display = 'none';

						        if (userInfo.admin) {
									if (!document.querySelector('.admin-mode')) {
						            const adminLink = document.createElement('a');
						            adminLink.href = 'https://localhost:8443/admin';
						            adminLink.classList.add('admin-mode');
						            adminLink.innerText = '관리자 모드 접속';

						            const nav = document.querySelector('.nav');
						            nav.appendChild(adminLink);
									}
						        }
						    } else {
						        console.error("로그인 버튼이 없습니다.");
						    }
						}

						
							
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
							
							const reviewList = document.getElementById("reviewList");

							let isDragging = false;
							let startX, scrollLeft;

							reviewList.addEventListener("mousedown", (e) => {
							    isDragging = true;
							    startX = e.pageX - reviewList.offsetLeft;
							    scrollLeft = reviewList.scrollLeft;
							    reviewList.style.cursor = "grabbing";
							});

							reviewList.addEventListener("mouseleave", () => {
							    isDragging = false;
							    reviewList.style.cursor = "grab";
							});

							reviewList.addEventListener("mouseup", () => {
							    isDragging = false;
							    reviewList.style.cursor = "grab";
							});

							reviewList.addEventListener("mousemove	", (e) => {
							    if (!isDragging) return;
							    e.preventDefault();
							    const x = e.pageX - reviewList.offsetLeft;
							    const walk = (x - startX) * 2; // 드래그 속도 조절
							    reviewList.scrollLeft = scrollLeft - walk;
							});
							document.getElementById('reviewForm').addEventListener('submit', async function(event) {
							    event.preventDefault(); // 기본 form 제출 막기

							    const form = event.target;
							    const formData = new FormData(form); // FormData 객체 생성
								
							    try {
							        // userInfo 가져오기
							        const userInfo = await fetchUserInfo();
									if (typeof userInfo === 'undefined' || userInfo === null) {
									    alert('로그인이 필요한 서비스 입니다.');
									    return;
									}
									const rating = document.getElementById('rating').value;
									    if (!rating) {
									        alert('별을 선택해주세요.');
									        return; // 별점이 없으면 제출 중단
									    }
							        if (userInfo && userInfo.username) {
							            formData.append('username', userInfo.username); // username 추가
							        }

							        // 동적 POST 요청
							        const response = await fetch(form.action, {
							            method: 'POST',
							            body: formData
							        });

							        if (!response.ok) {
							            throw new Error('리뷰 제출 실패');
							        }

							        alert('리뷰가 성공적으로 제출되었습니다.');
							        location.reload(); // 성공 시 페이지 새로고침 또는 다른 동작 수행
							    } catch (error) {
							        console.error('리뷰 제출 중 오류:', error);
							        alert('리뷰 제출 중 오류가 발생했습니다.');
							    }
							});
							var mapContainer = document.getElementById('map'),
														    mapOption = { 
														        center: new kakao.maps.LatLng(parseFloat(document.getElementById('map_y').value), parseFloat(document.getElementById('map_x').value)),
														        level: 2 
														    };
														var map = new kakao.maps.Map(mapContainer, mapOption); 
														var marker = new kakao.maps.Marker({
														    position: new kakao.maps.LatLng(parseFloat(document.getElementById('map_y').value), parseFloat(document.getElementById('map_x').value)) 
														});
														marker.setMap(map);
														
															async function syncFavoriteButtons(username) {
															    try {
															        const response = await fetch('/getFavorites', {
															            method: 'POST',
															            headers: {
															                'Content-Type': 'application/json'
															            },
															            body: JSON.stringify({ username: username }),
															            credentials: 'include'
															        });

															        if (!response.ok) {
															            throw new Error('즐겨찾기 정보를 가져오는 데 실패했습니다.');
															        }

															        const favorites = await response.json();

															        // 즐겨찾기 상태를 동기화
															        document.querySelectorAll('.favorite-btn').forEach(btn => {
															            const defaultNum = btn.getAttribute('data-default-num');
															            if (favorites.includes(defaultNum)) {
															                btn.classList.add('favorited');
															            } else {
															                btn.classList.remove('favorited');
															            }
															        });
															    } catch (error) {
															        console.error('즐겨찾기 동기화 중 오류:', error);
															    }
															}
														async function toggleFavorite(defaultNum) {
																	    try {
																	        const userInfo = await fetchUserInfo();

																	        if (!userInfo || !userInfo.username) {
																	            alert('로그인이 필요합니다.');
																	            return;
																	        }

																	        const response = await fetch('/toggleFavorite', {
																	            method: 'POST',
																	            headers: {
																	                'Content-Type': 'application/json'
																	            },
																	            body: JSON.stringify({ default_num: defaultNum, username: userInfo.username }),
																	            credentials: 'include'
																	        });
																			
																			console.log(response)
																			
																	        if (!response.ok) {
																	            throw new Error('즐겨찾기 처리 실패');
																	        }
																			
																	        const result = await response.json();
																	        // 해당 버튼의 상태를 토글
																	        document.querySelector(`.favorite-btn[data-default-num="`+ defaultNum + `"]`).classList.toggle('favorited', result.favorited);
																	        alert(result.favorited ? '즐겨찾기에 추가되었습니다.' : '즐겨찾기에서 제거되었습니다.');
																	    } catch (error) {
																	        console.error('즐겨찾기 처리 중 오류:', error);
																	        alert('즐겨찾기 처리 중 오류가 발생했습니다.');
																	    }
																	}

																	function toggleReviewExpansion(reviewItem) {
																	    reviewItem.classList.toggle('expanded');
																	}

							
</script>

</body>
</html>