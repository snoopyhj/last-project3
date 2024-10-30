<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>지역별 필터 화면</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/regionfilter.css">
</head>
<body>
	<h1>지역 선택</h1>

	<!-- 대분류 카테고리 -->
	<div class="region-container">
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('1')">서울특별시</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('6')">부산광역시</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('4')">대구광역시</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('2')">인천광역시</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('5')">광주광역시</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('3')">대전광역시</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('7')">울산광역시</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('8')">세종특별자치시</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('31')">경기도</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('32')">강원도</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('33')">충청북도</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('34')">충청남도</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('37')">전라북도</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('38')">전라남도</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('35')">경상북도</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('36')">경상남도</button>
		<button id = "region-box" class = "region-box"" onclick="toggleSubregion('39')">제주도</button>
	</div>

	<!-- 서울시 -->
	<div id="subregion-1" class="subregion" style="display: none;">
		<h2>세부 지역</h2>
		<div class="subregion-container">
			<div class="subregion-container">
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">강남구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">강동구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">강북구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">강서구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">관악구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('6')">광진구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('7')">구로구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('8')">금천구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('9')">노원구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('10')">도봉구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('11')">동대문구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('12')">동작구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('13')">마포구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('14')">서대문구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('15')">서초구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('16')">성동구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('17')">성북구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('18')">송파구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('19')">양천구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('20')">영등포구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('21')">용산구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('22')">은평구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('23')">종로구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('24')">중구</button>
				<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('25')">중랑구</button>
			</div>
		</div>
	</div>

	<!-- 부산시 -->
	<div id="subregion-6" class="subregion" style="display: none;">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">강서구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">금정구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">기장군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">남구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">동구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('6')">동래구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('7')">부산진구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('8')">북구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('9')">사상구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('10')">사하구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('11')">서구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('12')">수영구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('13')">연제구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('14')">영도구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('15')">중구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('16')">해운대구</button>
	</div>

	<!-- 대구광역시 -->
	<div id="subregion-4" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">남구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">달서구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">달성군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">동구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">북구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('6')">서구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('7')">수성구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('8')">중구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('9')">군위구</button>
	</div>

	<!-- 인천광역시 -->
	<div id="subregion-2" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">강화군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">계양구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">남동구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">동구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">미추홀구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('6')">부평구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('7')">서구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('8')">연수구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('9')">옹진군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('10')">중구</button>
	</div>

	<!-- 광주광역시 -->
	<div id="subregion-5" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">광산구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">남구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">동구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">북구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">서구</button>
	</div>

	<!-- 대전광역시 -->
	<div id="subregion-3" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">대덕구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">동구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">서구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">유성구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">중구</button>
	</div>

	<!-- 울산광역시 -->
	<div id="subregion-7" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">중구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">남구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">동구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">북구</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">울주군</button>
	</div>

	<!-- 세종특별자치시 -->
	<div id="subregion-8" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">세종시</button>
	</div>

	<!-- 경기도 -->
	<div id="subregion-31" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">가평군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">고양시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">과천시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">광명시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">광주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('6')">구리시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('7')">군포시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('8')">김포시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('9')">남양주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('10')">동두천시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('11')">부천시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('12')">성남시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('13')">수원시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('14')">시흥시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('15')">안산시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('16')">안성시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('17')">안양시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('18')">양주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('19')">양평군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('20')">여주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('21')">연천군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('22')">오산시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('23')">용인시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('24')">의왕시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('25')">의정부시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('26')">이천시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('27')">파주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('28')">평택시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('29')">포천시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('30')">하남시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('31')">화성시</button>
	</div>

	<!-- 강원도 -->
	<div id="subregion-32" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">강릉시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">고성군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">동해시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">삼척시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">속초시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('6')">양구군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('7')">양양군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('8')">영월군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('9')">원주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('10')">인제군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('11')">정선군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('12')">철원군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('13')">춘천시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('14')">태백시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('15')">평창군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('16')">홍천군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('17')">화천군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('18')">횡성군</button>
	</div>

	<!-- 충청북도 -->
	<div id="subregion-33" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">괴산군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">단양군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">보은군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">영동군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">옥천군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('6')">음성군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('7')">제천시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('8')">진천군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('9')">청원군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('10')">청주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('11')">충주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('12')">증평군</button>
	</div>

	<!-- 충청남도 -->
	<div id="subregion-34" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">공주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">금산군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">논산시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">당진시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">보령시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('7')">서산시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('8')">서천군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('9')">아산시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('12')">천안시</button>
	 	<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('13')">청양군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('14')">태안군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('15')">홍성군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('16')">계룡시</button>
	</div>

	<!-- 전라북도 -->
	<div id="subregion-37" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">고창군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">군산시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">김제시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">남원시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">무주군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('6')">부안군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('7')">순창군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('8')">완주군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('9')">익산시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('10')">임실군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('11')">장수군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('12')">전주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('13')">정읍시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('14')">진안군</button>
	</div>

	<!-- 전라남도 -->
	<div id="subregion-38" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">강진군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">고흥군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">곡성군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">광양시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">구례군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('6')">나주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('7')">담양군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('8')">목포시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('9')">무안군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('10')">보성군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('11')">순천시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('12')">신안군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('13')">여수시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('16')">영광군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('17')">영암군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('18')">완도군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('19')">장성군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('20')">장흥군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('21')">진도군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('22')">함평군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('23')">해남군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('24')">화순군</button>
	</div>

	<!-- 경상북도 -->
	<div id="subregion-35" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">경산시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">경주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">고령군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">구미시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">군위군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('6')">김천시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('7')">문경시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('8')">봉화군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('9')">상주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('10')">성주군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('11')">안동시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('12')">영덕군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('13')">영양군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('14')">영주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('15')">영천시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('16')">예천군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('17')">울릉군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('18')">울진군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('19')">의성군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('20')">청도군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('21')">청송군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('22')">칠곡군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('23')">포항시</button>

	</div>

	<!-- 경상남도 -->
	<div id="subregion-36" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">거제시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">거창군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">고성군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">김해시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('5')">남해군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('6')">마산시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('7')">밀양시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('8')">사천시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('9')">산천군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('10')">양산시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('12')">의령군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('13')">진주시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('14')">진해시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('15')">창녕군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('16')">창원시<button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('17')">통영시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('18')">하동군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('19')">함안군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('20')">함양군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('21')">합천군</button>
	</div>
	 
	<!-- 제주도 -->
	<div id="subregion-39" class="subregion">
		<h2>세부 지역</h2>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('1')">남제주군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('2')">북제주군</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('3')">서귀포시</button>
		<button id = "subregion-box" class = "subregion-box" onclick="selectSubregion('4')">제주시</button>
	</div>
	
	<!-- 검색 버튼 -->
	<div id="search-button-container" style="text-align: center; margin-top: 10px; display: none;">
		<button onclick="search()">검색</button>
	</div>

	<script>
	let currentVisible = null; // 현재 보이는 중분류 저장
	let selectedRegion = null; // 대분류 지역 선택 값 저장
	let selectedSubregion = null; // 세부 지역 선택 값 저장
	
	document.getElementById("region-box").addEventListener("focus", () => {
		document.getElementById("region-box").style.backgroundColor = "grey";
	});
		
	document.getElementById("region-box").addEventListener("blur", () => {
		document.getElementById("region-box").style.backgroundColor = "#D0D0D0";
	});

	// 대분류 지역 선택
	function toggleSubregion(region) {
	    const subregionDiv = document.getElementById('subregion-' + region);
	    const searchButtonContainer = document.getElementById('search-button-container');
		
	    if (currentVisible === subregionDiv) {
	        subregionDiv.style.display = 'none';
	        currentVisible = null;
	        searchButtonContainer.style.display = 'none';
	    } else {
	        if (currentVisible) {
	            currentVisible.style.display = 'none';
	        }
	        subregionDiv.style.display = 'block';
	        currentVisible = subregionDiv;
	        searchButtonContainer.style.display = 'block';
	    }

	    selectedRegion = region; // 선택된 대분류 지역 값 저장
	}
	
	document.getElementById("subregion-box").addEventListener("focus", () => {
		document.getElementById("subregion-box").style.backgroundColor = "grey";
	});
			
	document.getElementById("subregion-box").addEventListener("blur", () => {
		document.getElementById("subregion-box").style.backgroundColor = "#D0D0D0";
	});

	// 세부 지역 선택
	function selectSubregion(subregion) {
	    selectedSubregion = subregion; // 선택된 세부 지역 값 저장
	}

	// 검색 버튼 클릭 시 실행되는 함수
	function search() {

	    if (selectedRegion && selectedSubregion) {
	        alert("호텔 페이지로 이동합니다.");
	        location.href="/regionsearch?region=" + selectedRegion + "&subregion=" + selectedSubregion;
	        
	    } else {
	        alert("대분류와 세부 지역을 모두 선택해주세요.");
	    }
	}
	</script>
</body>
</html>