<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Cozy Pick</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>
    <div class="wrap">
        <div class="wrap">
            <div class="intro_bg">
                <!-- 헤더: 중앙 상단 배치 -->
                <div class="header">
                    <div class="nav">
                        <a href="#">HOME</a> <a href="#ABOUTUS">ABOUT US</a> <a href="#RESERVATION">RESERVATION</a> <a
                            href="#REVIEW">REVIEW</a>
                        <a href="#CONTACT">CONTACT</a>
                    </div>
                    <a href="/login" class="login">LOGIN</a>
                </div>

                <!-- Intro 텍스트: 가로 세로 중앙 배치 -->
                <div class="intro_text">
                    <h1>Cozy Pick</h1>
                    <h4>편안한 숙소를 제공합니다.</h4>
                    <div class="search_container">
                        <input type="search" class="search_input" placeholder="호텔을 검색해주세요.">
                        <button class="search_button">검색</button>
                    </div>
                </div>
            </div>
        </div>

        <ul class="amount">
            <li>오늘 예약건 수: 2,350건</li>
            <li>총 회원수: 6,852명</li>
            <li>국내 제휴호텔 수: 3,250개</li>
            <li>해외 제휴호텔 수: 389개</li>
        </ul>

        <div class="ABOUTUS" id="ABOUTUS">
            <h1>ABOUT US</h1>
            <div class="aboutus-content">
                <img src="hotel.jpg" alt="About Us Image">
                <p>
                    지친 일상 속에서 나만의 아늑한 쉼터를 찾고 싶으신가요? Cozy Pick은 당신의 소중한 순간을 위해 선별된 특별한 숙소를 제공합니다. 감각적인 인테리어와 편안한 공간이 조화를
                    이루는 곳에서 진정한 휴식을 경험하세요. 바쁜 도시의 일상을 벗어나 자연 속 평온함을 느끼고, 특별한 날을 더 특별하게 만들어 줄 숙소들을 엄선했습니다. 지금 바로 Cozy
                    Pick과 함께 여러분만의 완벽한 여행을 계획해보세요!
                </p>
                <div class="button-container">
                    <button class="learn-more-button" onclick="location.href='/aboutus'">
                        더 알아보기
                    </button>
                </div>
            </div>
        </div>

        <div class="RESERVATION" id="RESERVATION">
            <h1>RESERVATION</h1>
            <ul class="icons">
                <li><a href="/regionfilter">지역별 숙소예약</a></li>
                <li><a href="/hotelbytype">테마별 숙소예약</a></li>
                <li><a href="/hotellist">인기 숙소 보기</a></li>
            </ul>
        </div>

        <div class="REVIEW" id="REVIEW">
            <div class="cutomer_review">회원 만족 리뷰 사진들 편집해서 넣기</div>
            <div class="gotojoin">
                <a href="/register">지금 바로 회원가입하러 가기</a>
            </div>
        </div>

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
		
        <footer>
            <div>CEO. 배현우</div>
            <div>서울시 동작구 노량진동 장승배기로 171 3층 302호</div>
            <div>02-0000-000</div>
        </footer>
    </div>
</body>
</html>