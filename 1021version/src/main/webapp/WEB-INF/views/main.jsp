<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Cozy Pick</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body
    <div class="wrap">
        
            
<!-- ================================================= header ======================================== -->
                <div class="header">
               <a href="#" class="logo">cozypick</a>
                    <div class="nav">
                        <a href="#">HOME</a> <a href="#ABOUTUS">ABOUT US</a> 
                        <a href="#RESERVATION">RESERVATION</a> 
                        <a href="#REVIEW">REVIEW</a>
                        <a href="#CONTACT">CONTACT</a>
                    </div>
               <div>
               <a href="/register" class="login">회원가입</a>
                    <a href="http://localhost:8083/login" class="login">LOGIN</a>
               </div>
                </div>   
<!-- ================================================= main ======================================== -->
<!-- ================================================= search ======================================== -->
         <main>
            <div class="box-container">
            <div class="intro_bg">   
                <div class="intro_text">
                    <p class="search_main">국내여행엔<br> cozypick</p>
                    <button class="search-reservation-box" onclick="location.href='/호텔페이'">
                        🔍 여행지나 숙소를 검색해보세요
                    </button>
                </div>
            </div>

<!-- ================================================= main1 ======================================== -->
 
  <div class="RESERVATION" id="RESERVATION"><br><br><br>
      <h1>국내 대표 여행지</h1><br>
 <div class="reservation_wrapper"> 
	<div class="reservation_count2">
	    <button class="image-button" onclick="location.href='/seoul'">
	        <img src="/image/seoul2.jpg" alt="서울">
	        <p>서울</p>
	    </button>

	    <button class="image-button" onclick="location.href='/busan'">
	        <img src="/image/busan.jpg" alt="부산">
	        <p>부산</p>
	    </button>

	    <button class="image-button" onclick="location.href='/jeju'">
	        <img src="/image/jeju.jpg" alt="제주">
	        <p>제주</p>
	    </button>

	    <button class="image-button" onclick="location.href='/sokcho'">
	        <img src="/image/sokcho.jpg" alt="속초">
	        <p>속초</p>
	    </button>

	    <button class="image-button" onclick="location.href='/mokpo'">
	        <img src="/image/mokpo.jpg" alt="목포">
	        <p>목포</p>
	    </button>
	</div>
          <h1>국내인기숙박시설</h1><br>
         <div class="reservation_count ">
			<div>사진1</div>
			<div>사진2</div>
			<div>사진3</div>
			<div>사진4</div>
			<div>사진5</div>
			<div>사진6</div>
			<div>사진7</div>
			<div>사진8</div>
			<div>사진9</div>
			<div>사진10</div>
			<div>사진11</div>
			<div>사진12</div>
			<div>사진13</div>
			<div>사진14</div>
			<div>사진15</div>			
			</div>
         </div>   

			  
         <br><br><br>
		 <h1>RESERVATION</h1>
          <div class="reservation-options">
              <div class="reservation-item">
                  <a href="/regionfilter">🏙️ 지역별 숙소예약</a>
              </div>
              <div class="reservation-item">
                  <a href="/hotelbytype">🎨 테마별 숙소예약</a>
              </div>
              <div class="reservation-item">
                  <a href="/hotellist">🔥 인기 숙소 보기</a>
              </div>
          </div>
      </div>
<!-- ================================================= main2 ======================================== -->
      <div class="REVIEW" id="REVIEW">
          <div class="customer-review">
              <h2>회원 만족 리뷰</h2>
              <p>회원들이 남긴 다양한 리뷰 사진을 확인해보세요!</p>
          </div>
         <br><br><br><br>

      </div>
<!-- ================================================= main3 ======================================== -->
      <div class="CONTACT" id="CONTACT">
          <h2>고객센터</h2>
          <p>고객행복센터(전화): 오전 9시 ~ 새벽 3시 운영</p>
          <p>카카오톡 문의: 24시간 운영</p>
          <div class="contact-buttons">
              <button class="phone-btn">📞 1670-6250</button>
              <button class="kakao-btn">💬 카카오 문의</button>
              <button class="email-btn"><a href="/email">📧 이메일 문의</a></button>
              <button class="question-btn"><a href="/question">자주 묻는 질문</a></button>
          </div>
         </div>

        <hr><br><br>
<!-- ================================================= main4 ======================================== -->
        <div class="ABOUTUS" id="ABOUTUS">
            <h1>ABOUT US</h1>
            <div class="aboutus-content">
                <p>지친 일상 속에서 나만의 아늑한 쉼터를 찾고 싶으신가요? Cozy Pick은 당신의 소중한 순간을 위해 선별된 특별한 숙소를 제공합니다.</p>
                <div class="button-container">
                    <button class="learn-more-button" onclick="location.href='/aboutus'">더 알아보기</button>
                </div>
            </div>
        </div>

      <hr><br><br>
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
   
<!-- ================================================= script ======================================== -->
    <script>
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
	  
    </script>
</body>
</html>
