<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 페이지</title>
    <link rel="stylesheet" type="text/css" href="/css/login.css">
</head>
<body>
<div class="container">
    <h2>로그인</h2>
    <form id="loginForm">
        <div class="input-group">
            <label for="username">아이디</label>
            <input type="text" id="username" name="username" placeholder="아이디를 입력하세요" required>
        </div>
        
        <div class="input-group">
            <label for="password">패스워드</label>
            <input type="password" id="password" name="password" placeholder="패스워드를 입력하세요" required>
        </div>
        <button type="submit" class="login-btn">로그인</button>
    </form>
    <div class="input-group">
        <input type="checkbox" id="rememberMe" name="rememberMe">
        <label for="rememberMe">로그인 유지</label>
    </div>

    <div class="button-section">
        <button id="findIdButton" class="secondary-btn">아이디 찾기</button>
        <button id="resetPasswordButton" class="secondary-btn">비밀번호 재설정</button>
    </div>

    <div class="signup-section">
        <p>아직 회원이 아니신가요? <a href="/register">지금 바로 회원가입하기</a></p>
    </div>

    <div class="divider"></div>

    <div class="social-login-section">
        <h3>간편가입</h3>
        <div class="social-buttons">
            <button class="social-kakao" id="kakaoLoginButton">카카오로 가입</button>
            <button class="social-naver" id="naverLoginButton">네이버로 가입</button>
        </div>
    </div>
</div>

<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.2/kakao.min.js" integrity="sha384-TiCUE00h649CAMonG018J2ujOgDKW/kVWlChEuu4jK2vxfAAD0eZxzCKakxg55G4" crossorigin="anonymous"></script>
<script>
    Kakao.init('823fc9943d97c4e15c751cddc501be43'); // 사용하려는 앱의 JavaScript 키 입력

    // 쿠키에서 rememberMe 값을 읽어 로그인 유지 체크박스 설정
    document.addEventListener('DOMContentLoaded', () => {
        const rememberMeChecked = getCookie('rememberMe') === 'true';
        document.getElementById('rememberMe').checked = rememberMeChecked;
    });

    document.getElementById('loginForm').addEventListener('submit', function(e) {
        e.preventDefault();
        
        const username = document.getElementById('username').value;
        const password = document.getElementById('password').value;
        const rememberMe = document.getElementById('rememberMe').checked;

        // 로그인 유지 체크 여부를 쿠키에 저장
        setCookie('rememberMe', rememberMe, 30); // 30일 동안 유지

        // 로그인 요청
        fetch(`/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ username, password })
        })
        .then(response => {
            if (response.ok) {
                loadHomePage();
            } else {
                alert('로그인 실패. 다시 시도해 주세요.');
            }
        })
        .catch(error => console.error('로그인 실패:', error));
    });

    function loadHomePage() {
        fetchWithToken('/')
            .then(response => response.ok ? response.text() : Promise.reject())
            .then(data => window.location.href = '/')
            .catch(() => {
                alert('로그인 페이지로 이동합니다.');
                window.location.href = '/login';
            });
    }

    // 엑세스 토큰 만료 시 리프레시 토큰으로 재발급 요청
    async function fetchWithToken(url, options = {}) {
        options.credentials = 'include';

        let response = await fetch(url, options);

        if (response.status === 401) { // 만료 시
            const refreshToken = prompt("세션이 만료되었습니다. 리프레시 토큰을 입력해 주세요:");
            
            const refreshResponse = await fetch('/refresh-token', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ refreshToken })
            });

            if (refreshResponse.ok) {
                response = await fetch(url, options); // 재요청
            } else {
                alert("세션 만료, 다시 로그인 해주세요.");
                window.location.href = '/login';
            }
        }

        return response;
    }

    // 쿠키 설정 함수
    function setCookie(name, value, days) {
        let expires = "";
        if (days) {
            const date = new Date();
            date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
            expires = "; expires=" + date.toUTCString();
        }
        document.cookie = name + "=" + (value || "") + expires + "; path=/";
    }

    // 쿠키 가져오기 함수
    function getCookie(name) {
        const nameEQ = name + "=";
        const ca = document.cookie.split(';');
        for (let i = 0; i < ca.length; i++) {
            let c = ca[i];
            while (c.charAt(0) == ' ') c = c.substring(1, c.length);
            if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
        }
        return null;
    }

    // 카카오 로그인 함수
    function loginWithKakao() {
        Kakao.Auth.authorize({
            redirectUri: 'https://localhost:8443/oauth2/success',
            scope: 'account_email profile_nickname name gender birthday birthyear phone_number', // 요청할 스코프 추가
        });
    }

    // 네이버 로그인 함수
    function loginWithNaver() {
        const clientId = 'ZCu6SjlzSG3mKIvbTW1e'; // 네이버 앱의 클라이언트 ID를 입력하세요.
        const redirectUri = encodeURIComponent('https://localhost:8443/naver/success'); // 리다이렉트 URI
        const naverLoginUrl = `https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=${clientId}&redirect_uri=${redirectUri}`;
        window.location.href = naverLoginUrl; // 네이버 로그인 페이지로 이동
    }

    // 버튼 클릭 시 카카오 로그인 처리
    document.getElementById('kakaoLoginButton').addEventListener('click', loginWithKakao);

    // 버튼 클릭 시 네이버 로그인 처리
    document.getElementById('naverLoginButton').addEventListener('click', loginWithNaver);

    // 아이디 찾기 버튼 클릭 이벤트
    document.getElementById('findIdButton').addEventListener('click', function() {
        window.location.href = '/find-id/email'; // 아이디 찾기 페이지의 URL
    });

    // 비밀번호 재설정 버튼 클릭 이벤트
    document.getElementById('resetPasswordButton').addEventListener('click', function() {
        window.location.href = '/change-pw/email'; // 비밀번호 재설정 페이지의 URL
    });
</script>
</body>
</html>
