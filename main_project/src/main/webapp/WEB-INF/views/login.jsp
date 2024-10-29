<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/login.css">
</head>
<body>
	<div class="container">
		<h2>로그인</h2>
		<form action="/login" method="POST">
			<div class="input-group">
				<label for="username">아이디</label> <input type="text" id="username"
					name="username" placeholder="아이디를 입력하세요" required>
			</div>
			<div class="input-group">
				<label for="password">패스워드</label> <input type="password"
					id="password" name="password" placeholder="패스워드를 입력하세요" required>
			</div>
			<button type="submit" class="login-btn">로그인</button>
		</form>

		<div class="signup-section">
			<p>
				아직 회원이 아니신가요? <a href="/register">지금 바로 회원가입하기</a>
			</p>
		</div>

		<div class="divider"></div>

		<div class="social-login-section">
			<h3>간편가입</h3>
			<div class="social-buttons">
				<button class="social-kakao">카카오로 가입</button>
				<button class="social-naver">네이버로 가입</button>
			</div>
		</div>
	</div>
</body>
</html>