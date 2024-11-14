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
    <a href="https://localhost:8444" class="logo">cozypick</a>
    <nav class="nav">
        <a href="https://localhost:8444">HOME</a>
        <a href="https://localhost:8444/#ABOUTUS">ABOUT US</a>
        <a href="https://localhost:8444/#RESERVATION">RESERVATION</a>
        <a href="https://localhost:8444/#REVIEW">REVIEW</a>
        <a href="https://localhost:8444/#CONTACT">CONTACT</a>
    </nav>
	<div id="loading-message" class="loading">Loading user information...</div>
    <div class="auth-buttons">
        <a href="https://localhost:8443/register" class="register">회원가입</a>
        <a href="https://localhost:8443/login" class="login">LOGIN</a>
    </div>
</header>

<!-- Main Content -->
<main class="main-content">

    <aside class="filter-bar">
		<div class="search-bar">
				    <input 
				        type="text" 
				        id="search-input" 
				        class="search-input" 
				        placeholder="🔍 여행지나 숙소를 검색"
				        onkeypress="handleEnter(event)" 
				    />
				</div>
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
		          <!-- 반복문 추가 -->
		          <c:forEach var="eachhotel" items="${hotel_list}">
		              <div class="hotel-card" onclick="searchByDefaultNum('${eachhotel.default_num}')">
		                  <img src="${eachhotel.img1}" alt="${eachhotel.name}" class="hotel-img">
		                  <!-- 하트 버튼 위치 -->
							<button class="favorite-btn" data-default-num="${eachhotel.default_num}">♥</button>
		                  <div class="hotel-info">
		                      <h3>${eachhotel.name}</h3>						  
		                      <p>주소: ${eachhotel.address}</p>
		                      <p>전화번호:
		                          <c:choose>
		                              <c:when test="${empty eachhotel.tel or eachhotel.tel eq 'nan'}">-</c:when>
		                              <c:otherwise>${eachhotel.tel}</c:otherwise>
		                          </c:choose>
		                      </p>
		                      <p class="price">${eachhotel.standard} ~</p>
		                      <p class="resevations" style="display: none;">${eachhotel.reservation_count}</p>
		                      <p class="type" style="display: none;">${eachhotel.type}</p>
		                  </div>
		              </div>
		              <div class="divider"></div>
		          </c:forEach>
		      </div>
		  </section>
</main>

<script>
	document.addEventListener('DOMContentLoaded', async function () {
	    console.log('페이지가 로드되었습니다!');
	    const userInfo = await fetchUserInfo();
	    if (userInfo) {
	        changeLoginButtonToMyPage(userInfo);
	    }
	    
	    // 모든 즐겨찾기 버튼에 클릭 이벤트 리스너 추가
	    document.querySelectorAll('.favorite-btn').forEach(btn => {
	        btn.addEventListener('click', function (event) {
	            event.stopPropagation(); // 부모 요소 클릭 방지
	            const defaultNum = this.getAttribute('data-default-num');
	            toggleFavorite(defaultNum);
	        });
	    });
	});

	async function fetchUserInfo() {
	    try {
	        const response = await fetch('https://localhost:8443/userinfo', {
	            method: 'GET',
	            credentials: 'include'
	        });

	        if (response.ok) {
	            const userInfo = await response.json();
	            return userInfo;
	        } else {
	            console.error('사용자 정보를 가져오는 데 실패했습니다.');
	        }
	    } catch (error) {
	        console.error('사용자 정보를 가져오는 중 오류 발생:', error);
	    }
	    return null;
	}
						fetchUserInfo();
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
		function handleEnter(event) {
			    if (event.key === "Enter") {
			        const searchcode = document.getElementById("search-input").value;
			        if (searchcode) {
			            location.href = "/regionsearch3?search=" + encodeURIComponent(searchcode);
			        } else {
			            alert("검색어를 입력해주세요.");
			        }
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


</script>

</body>
</html>