<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/contact.css">
</head>
<body>
	<div class="wrap">
	    <div class="header">
	        <a href="https://localhost:8444/" class="logo">cozypick</a>
	        <div class="nav">
	            <a href="https://localhost:8444/#">HOME</a> 
	            <a href="#RESERVATION" onclick="scrollToReservation(event)">RESERVATION</a>
	            <a href="#CONTACT">CONTACT</a>
	            <a href="#FAQ" onclick="scrollToReservation2(event)">FAQ's</a>
	            <a href="https://localhost:8444/aboutus">ABOUT US</a> 
	        </div>
	        <div>
	            <a href="https://localhost:8443/register" class="register">회원가입</a>
	            <a href="https://localhost:8443/login" class="login">LOGIN</a>
	        </div>
	    </div>   
	 
	    <main>
			<div class="CONTACT" id="CONTACT">
			         <h2>고객센터</h2>
			         <p>고객행복센터(전화): 오전 9시 ~ 새벽 3시 운영</p>
			         <p>카카오톡 문의: 24시간 운영</p>
			         <div class="contact-buttons">
			             <button class="phone-btn">📞 1670-6250</button>
			             <button class="kakao-btn"><a href="#" onclick = "chatbotpopup()">💬 chatbot</a></button>
			             <button class="email-btn"><a href="/email">📧 이메일 문의</a></button>
			             <button class="question-btn"><a href="/question">자주 묻는 질문</a></button>
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

		</script>
</body>
</html>