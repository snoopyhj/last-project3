<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/email.css">
</head>
<body>
	<div class="inquiry-form">
		<div class="header">
			<h2>이용 중에 생긴 불편한 점이나 문의사항을 보내주세요.</h2>
			<p>확인 후 이메일로 답변드리겠습니다.</p>
			<img src="icon.png" alt="문의 아이콘">
		</div>

		<form action="#" method="POST">
			<!-- 유형 선택 -->
			<select class="input-field" required>
				<option value="" disabled selected>유형을 선택해주세요.</option>
				<option value="1">예약 관련</option>
				<option value="2">결제 관련</option>
				<option value="3">회원 정보 변경</option>
			</select>

			<!-- 내용 작성 -->
			<textarea class="input-field" rows="10" placeholder="내용을 작성해주세요."
				required></textarea>

			<!-- 이메일 입력 -->
			<div class="email-section">
				<input type="email" class="input-field" value="god61**@naver.com"
					readonly>
				<button type="button" class="change-button">변경하기</button>
			</div>

			<!-- 제출 버튼 -->
			<button type="submit" class="submit-button">보내기</button>

			<!-- 메인으로 돌아가기 버튼 -->
			<div class="back-to-main">
				<button onclick="location.href='/'" class="back-button">메인으로
					돌아가기</button>
			</div>
		</form>
	</div>
</body>
</html>