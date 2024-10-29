<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/aboutus.css">
</head>
<script>

function showContent(id) {
    // 모든 콘텐츠 박스를 숨깁니다.
    const contentBoxes = document.querySelectorAll('.content-box');
    contentBoxes.forEach((box) => box.classList.add('hidden'));

    // 선택된 콘텐츠 박스를 표시합니다.
    const selectedBox = document.getElementById(id);
    selectedBox.classList.remove('hidden');
}


</script>
<body>
    <div class="company-section">
        <h1>COMPANY</h1>
        <div class="buttons-container">
            <button class="outline-button" onclick="showContent('intro')">회사소개</button>
            <button class="filled-button" onclick="showContent('history')">회사연혁</button>
            <button class="outline-button" onclick="showContent('business')">사업영역</button>
            <button class="outline-button" onclick="showContent('contact')">CONTACT US</button>
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
            <div id="location" class="content-box hidden">
                <p>궁w지도</p>
            </div>
            
            <div class="back-to-main">
            <button onclick="location.href='/'" class="back-button">메인으로 돌아가기</button>
        </div>
        </div>

        <div class="social-icons">
            <a href="#"><img src="instagram.png" alt="Instagram"></a>
            <a href="#"><img src="youtube.png" alt="YouTube"></a>
        </div>
    </div>

    <script src="script.js"></script>
</body>
</html>