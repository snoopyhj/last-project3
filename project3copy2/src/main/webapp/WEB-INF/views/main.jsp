<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cozy Pick</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
	<script>
		function chatbotpopup() {
			let options = "toolbar=no,scrollbars=no,resizable=yes,status=no,menubar=no,width=500, height=700, top=300,left=300";
		
			window.open("http://localhost:8085","_blank", options)
		}
	</script>
    <div class="wrap">
        
            
<!-- ================================================= header ======================================== -->
                <div class="header">
               <a href="#" class="logo">cozypick</a>
                    <div class="nav">
                        <a href="#">HOME</a> 
                        <a href="#RESERVATION" onclick="scrollToReservation(event)">RESERVATION</a>                     
						<a href="#FAQ" onclick="scrollToReservation2(event)">FAQ's</a>
						<a href="https://localhost:8444/contact">CONTACT</a>
						<a href="https://localhost:8444/aboutus">ABOUT US</a> 
                    </div>
					<div id="loading-message" class="loading">Loading user information...</div>
               <div>
               <a href="https://localhost:8443/register" class="register">회원가입</a>
                    <a href="https://localhost:8443/login" class="login">LOGIN</a>
               </div>
                </div>   
<!-- ================================================= main ======================================== -->
<!-- ================================================= search ======================================== -->
         <main>
            <div class="box-container">
            <div class="intro_bg">   
                <div class="intro_text">
                    <p class="search_main">국내여행! 최고의 선택은<br> cozypick</p>
					    <input 
					        type="text" 
					        id="search-input" 
					        class="search-reservation-box" 
					        placeholder="🔍 여행지나 숙소를 검색해보세요"
					        onkeypress="handleEnter(event)" 
					    />
					</div>
                </div>
            </div>

<!-- ================================================= main1 ======================================== -->
 
  <div class="RESERVATION" id="RESERVATION"><br><br>
      <h1>국내 대표 여행지</h1>
	  <p class="subject1">국내를 대표하는 5곳의 여행지에서 최고의 경험을 만들어보세요.</p>
 <div class="reservation_wrapper"> 
	<div class="reservation_count2">
	    <button class="image-button" onclick="search2(1)">
	        <img src="/image/seoul2.jpg" alt="서울">
	        <p class="mainname">서울</p>
	    </button>

	    <button class="image-button" onclick="search2(6)">	
	        <img src="/image/busan.jpg" alt="부산">
	        <p class="mainname">부산</p>
	    </button>

	    <button class="image-button" onclick="search2(39)">	
	        <img src="/image/jeju.jpg" alt="제주">
	        <p class="mainname">제주</p>
	    </button>

	    <button class="image-button" onclick="search(32,5)">	
	        <img src="/image/sokcho.jpg" alt="속초">
	        <p class="mainname">속초</p>
	    </button>

	    <button class="image-button" onclick="search(38,8)">	
	        <img src="/image/mokpo.jpg" alt="목포">
	        <p class="mainname">목포</p>
	    </button>
	</div>
	<h1>국내 최고 인기 숙소에서 특별한 하루를 맞이해보세요.</h1>
	<p class="subject1">여행의 다채로움을 더할 다양한 숙소들이 준비되어 있습니다. 각기 다른 테마와 특별한 경험을 선사하는 숙소에서 하루를 채워보세요.</p>
	<div class="hotel-scroll-wrapper">
	    <div class="hotel-container">
	        <c:forEach var="eachhotel" items="${hotel_list}">
	            <div class="hotel-item" onclick="searchByDefaultNum('${eachhotel.default_num}')">
	                <img src="${eachhotel.img1 != null ? eachhotel.img1 : '/path/to/default_image.jpg'}" 
	                     alt="${eachhotel.name}" width="200" height="150">
						 <p class="hotel-name">&nbsp;&nbsp;${eachhotel.name}</p>
						 <p class="hotel-address">${eachhotel.address}</p>
						 <br>
						 <p class="hotel-name2">${eachhotel.standard}원 ~</p>

	            </div>
	        </c:forEach>
	    </div>
	</div>
	<div class="hotel-container2">
	    <h1>다양한 테마별 유형의 숙소를 확인해보세요.</h1>
	    <p class="subject1">여행의 목적과 분위기에 맞춰 최고의 숙소를 선택해 보세요. 도시의 편리함을 누릴 수 있는 호텔, 자연과 가까이할 수 있는 캠핑장 등 다채로운 옵션이 준비되어 있습니다.</p>
	    <div class="grid-container">
	        <div class="grid-item" onclick="search3('호텔')">
	            <img src="/image/호텔.jpg" alt="호텔">
	            <p>호텔</p>
	        </div>
	        <div class="grid-item" onclick="search3('리조트')">
	            <img src="/image/리조트.jpg" alt="리조트">
	            <p>리조트</p>
	        </div>
	        <div class="grid-item" onclick="search3('한옥')">
	            <img src="/image/한옥.jpg" alt="한옥">
	            <p>한옥</p>
	        </div>
	        <div class="grid-item" onclick="search3('펜션')">
	            <img src="/image/펜션.jpg" alt="펜션">
	            <p>펜션</p>
	        </div>
	        <div class="grid-item" onclick="search3('게스트하우스')">
	            <img src="/image/게스트하우스.jpg" alt="게스트하우스">
	            <p>게스트하우스</p>
	        </div>
	        <div class="grid-item" onclick="search3('민박')">
	            <img src="/image/민박.jpg" alt="민박">
	            <p>민박</p>
	        </div>
	        <div class="grid-item" onclick="search3('모텔')">
	            <img src="/image/모텔.jpg" alt="모텔">
	            <p>모텔</p>
	        </div>
	        <div class="grid-item" onclick="search3('유스호스텔')">
	            <img src="/image/유스호스텔.jpg" alt="유스호스텔">
	            <p>유스호스텔</p>
	        </div>
	        <div class="grid-item" onclick="search3('레지던스')">
	            <img src="/image/레지던스.jpg" alt="레지던스">
	            <p>레지던스</p>
	        </div>
	        <div class="grid-item" onclick="search3('콘도')">
	            <img src="/image/콘도.jpg" alt="콘도">
	            <p>콘도</p>
	        </div>
	    </div>
	</div

	<!-- 배너 이미지 영역 -->
	<div class="banner-container">
	    <img src="/image/배너.jpg" alt="배너 이미지">
		<img src="/image/배너2.jpg" alt="배너 이미지">
	</div>
          </div>
      </div>
<!-- ================================================= main2 ======================================== -->


<!-- ================================================= main3 ======================================== -->
<hr>     

<!-- ================================================= main5 ======================================== -->      
      <div class="FAQ" id="FAQ">
          <h1 class="faq-title">FAQ's</h1>
             <div class="faq-container">
              <div class="faq-item">
                  <div class="faq-header">
                      <h3>예약을 취소하고 환불받을 수 있나요?</h3>
                      <span class="arrow">▼</span>
                  </div>
                  <p class="faq-answer">호텔 예약을 취소하고 환불받는 조건은 호텔의 취소 정책에 따라 다릅니다. 일부 호텔은 체크인 24시간 전까지 무료 취소를 허용하지만, 특정 호텔의 경우 환불 불가 요금제가 적용될 수 있습니다. 예약 시 확인한 예약 조건과 취소 정책을 꼭 확인하시기 바랍니다. 또한, 취소 시점에 따라 수수료가 부과될 수 있습니다. 비수기에는 유연한 취소가 가능하지만, 성수기나 할인 요금제에서는 취소 정책이 더 엄격할 수 있습니다. 만약 취소가 불가한 예약이라면, 고객센터를 통해 예약 변경이나 일정을 조정할 수 있는지 확인해보세요. 또한, 항공권과 숙박을 함께 예약한 경우, 항공사의 취소 규정도 별도로 확인해야 합니다.</p>
              </div>

              <div class="faq-item">
                  <div class="faq-header">
                      <h3>체크인 시간은 언제부터인가요?</h3>
                      <span class="arrow">▼</span>
                  </div>
                  <p class="faq-answer">대부분의 호텔에서는 체크인 시간이 오후 3시부터이며, 체크아웃 시간은 오전 11시 또는 **정오(12시)**입니다. 그러나 호텔마다 정책이 다를 수 있으므로 예약 확인 시 체크인 및 체크아웃 시간을 반드시 확인하시기 바랍니다. 만약 이른 체크인이나 늦은 체크아웃이 필요한 경우, 호텔에 사전에 요청하거나 추가 요금이 발생할 수 있습니다. 일부 호텔은 상황에 따라 무료로 일찍 체크인할 수 있는 경우도 있지만, 예약 상태나 객실 가용 여부에 따라 달라질 수 있습니다. 공항 근처 호텔이나 도심의 비즈니스 호텔의 경우, 유연한 체크아웃 옵션이 제공되기도 합니다. 체크아웃 시간을 놓치면 추가 요금이 부과될 수 있으니 주의가 필요합니다.</p>
              </div>

              <div class="faq-item">
                  <div class="faq-header">
                      <h3>조식이 포함되나요?</h3>
                      <span class="arrow">▼</span>
                  </div>
                  <p class="faq-answer">조식 제공 여부는 호텔의 정책과 예약 유형에 따라 다릅니다. 일부 호텔은 조식 포함 요금제와 조식 미포함 요금제를 구분하여 운영하며, 예약 시 이를 선택할 수 있습니다. 조식이 포함된 경우, 일반적으로 뷔페 형태의 조식이 제공되며, 일부 호텔은 룸서비스 조식도 옵션으로 제공합니다. 조식 비용은 호텔마다 다르며, 성인과 어린이 요금이 별도로 부과될 수 있습니다. 예약 완료 후 조식을 추가하고자 할 경우, 호텔에 직접 문의하거나 체크인 시 추가 결제가 가능합니다. 조식 이용 시간은 보통 아침 6시부터 10시까지이니 일정에 맞게 이용하시길 권장합니다. 조식이 포함된 숙소를 선택하면 여행 중 편리함과 비용 절감을 동시에 누릴 수 있습니다.</p>
              </div>

              <div class="faq-item">
                  <div class="faq-header">
                      <h3>반려동물 동반이 가능한가요?</h3>
                      <span class="arrow">▼</span>
                  </div>
                  <p class="faq-answer">반려동물 동반 가능 여부는 호텔의 정책에 따라 다릅니다. 일부 호텔은 반려동물 친화적인 서비스를 제공하며, 추가 요금을 부과하는 경우도 있습니다. 숙박 가능한 반려동물의 종류와 크기, 수에 제한이 있을 수 있으니 예약 전 호텔에 문의하는 것이 좋습니다. 또한, 반려동물과 함께 이용할 수 있는 전용 객실이나 산책 공간이 마련된 호텔도 있습니다. 반대로, 일부 고급 호텔이나 리조트는 반려동물의 출입을 제한하고 있습니다. 반려동물과 함께 투숙할 경우, 호텔 내 규정을 준수하고, 공공장소에서는 목줄을 착용해야 합니다. 예약 전, 호텔의 반려동물 동반 정책과 추가 요금을 꼭 확인하시기 바랍니다.</p>
              </div>

              <div class="faq-item">
                  <div class="faq-header">
                      <h3>결제는 어떻게 할 수 있나요?</h3>
                      <span class="arrow">▼</span>
                  </div>
                  <p class="faq-answer">대부분의 호텔은 신용카드, 체크카드, 모바일 결제(예: 카카오페이, 네이버페이) 등 다양한 결제 수단을 제공합니다. 일부 호텔은 현장 결제를 지원하지만, 예약 시 카드 정보를 미리 입력해야 하는 경우도 있습니다. 예약 시 결제와 도착 후 결제 방식은 호텔마다 다르므로, 예약 페이지에서 결제 조건을 꼼꼼히 확인하는 것이 중요합니다. 환불 불가 예약의 경우 예약 시점에 전액 결제가 이루어지며, 유연한 예약은 체크인 시 결제가 가능할 수 있습니다. 또한, 일부 호텔에서는 외화 결제가 가능하므로 해외여행 시 편리하게 이용할 수 있습니다. 결제 시 추가 수수료가 부과될 수 있는지 미리 확인하는 것도 중요합니다.</p>
              </div>

              <div class="faq-item">
                  <div class="faq-header">
                      <h3>추가 요청은 어떻게 하나요?</h3>
                      <span class="arrow">▼</span>
                  </div>
                  <p class="faq-answer">추가 요청 사항은 예약 시 비고란에 기재하거나 체크인 전 호텔에 직접 연락하여 요청할 수 있습니다. 고객이 자주 요청하는 사항으로는 추가 침대, 유아용 침대, 조식 추가, 객실 업그레이드 등이 있습니다. 일부 요청은 추가 요금이 발생할 수 있으며, 호텔의 객실 가용 여부에 따라 제공이 제한될 수 있습니다. 또한, 생일이나 기념일 같은 특별한 날을 위해 와인, 케이크, 객실 장식 서비스를 요청할 수도 있습니다. 체크인 시 로비에서 직접 추가 요청을 하는 것도 가능하지만, 원활한 서비스 제공을 위해 사전에 요청하는 것이 좋습니다. 예약 후 고객센터나 호텔 프런트와 직접 연락해 요청 사항을 확인하는 것도 추천합니다.</p>
              </div>
          </div>
      </div>
   <br><br>
   </div>
            </main>
            
<!-- ================================================= footer ======================================== -->

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
	<button id="scrollToTopBtn" title="맨 위로"><span style="font-size: 24px;">▲</span></button>
<!-- ================================================= script ======================================== -->
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
					        loginBtn.href = 'https://localhost:8443/mypage'
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
      document.querySelectorAll('.faq-header').forEach(header => {
          header.addEventListener('click', () => {
              const faqItem = header.parentElement;
              const isOpen = faqItem.classList.contains('open');
              
              // 모든 항목 닫기
              document.querySelectorAll('.faq-item').forEach(item => item.classList.remove('open'));
              
              // 클릭한 항목 열기 (이미 열려 있다면 닫기)
              if (!isOpen) {
                  faqItem.classList.add('open');
              }
          });
      });
	  
	  
	    window.onload = function () {
	        window.scrollTo(0, 0);
	    };
		

		
		function search(regionCode, subregionCode) {
		    if (regionCode && subregionCode) {
		        // 선택한 지역 코드를 포함한 URL로 이동
		        location.href = "/regionsearch?region=" + regionCode + "&subregion=" + subregionCode;
		    } else {
		        alert("유효한 지역을 선택해주세요.");
		    }
		}	
		
			function search2(regionCode2) {
			    if (regionCode2) {
			        // 선택한 지역 코드를 포함한 URL로 이동
			        location.href = "/regionsearch2?region=" + regionCode2;
			    } else {
			        alert("유효한 지역을 선택해주세요.");
			    }
			}
	
			function search3(regionCode6) {
			    if (regionCode6) {
			        // 선택한 지역 코드를 포함한 URL로 이동
			        location.href = "/regionsearch6?type=" + regionCode6;
			    } else {
			        alert("유효한 지역을 선택해주세요.");
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
			function searchByDefaultNum(default_num) {
			    if (default_num) {
			        location.href = "/regionsearch5?default_num=" + encodeURIComponent(default_num);
			    } else {
			        alert("유효한 숙소를 선택해주세요.");
			    }
			}
			function scrollToReservation(event) {
			    event.preventDefault(); // 기본 링크 이동 방지

			    // 원하는 위치로 부드럽게 스크롤
			    const targetPosition = document.querySelector("#RESERVATION").offsetTop +390; // 조정된 위치
			    window.scrollTo({
			        top: targetPosition,
			        behavior: "smooth"
			    });
			}
			
			function scrollToReservation2(event) {
			    event.preventDefault(); // 기본 링크 이동 방지

			    // 원하는 위치로 부드럽게 스크롤
			    const targetPosition = document.querySelector("#FAQ").offsetTop +1000; // 조정된 위치
			    window.scrollTo({
			        top: targetPosition,
			        behavior: "smooth"
			    });
			}
			
			function scrollToReservation3(event) {
			    event.preventDefault(); // 기본 링크 이동 방지

			    // 원하는 위치로 부드럽게 스크롤
			    const targetPosition = document.querySelector("#CONTACT").offsetTop -280; // 조정된 위치
			    window.scrollTo({
			        top: targetPosition,
			        behavior: "smooth"
			    });
			}
			
			const scrollToTopBtn = document.getElementById("scrollToTopBtn");

			    // 스크롤 이벤트 감지
			    window.addEventListener("scroll", function() {
			        if (document.body.scrollTop > 100 || document.documentElement.scrollTop > 100) {
			            scrollToTopBtn.style.display = "block"; // 스크롤 위치가 100px 이상일 때 버튼 표시
			        } else {
			            scrollToTopBtn.style.display = "none"; // 스크롤 위치가 100px 미만일 때 버튼 숨김
			        }
			    });

			    // 버튼 클릭 시 맨 위로 부드럽게 스크롤
			    scrollToTopBtn.addEventListener("click", function() {
			        window.scrollTo({
			            top: 0,
			            behavior: "smooth" // 부드러운 스크롤
			        });
			    });
		
    </script>
</body>
</html>