<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Cozy Pick</title>
    <link rel="stylesheet" href="/css/MyInformation.css"> <!-- CSS 파일 경로 확인 -->
    <style>
        /* 간격을 줄이는 CSS */
        .container {
            margin-bottom: 10px; /* 각 섹션 간격 조절 */
        }

        .details {
            margin-bottom: 8px; /* 개별 요소 간격 줄이기 */
        }

        .edit-button {
            margin-left: 5px; /* 버튼과 텍스트 사이 간격 */
        }

        /* 비밀번호 필드에 대한 스타일 */
        .masked-password {
            font-family: 'Courier New', Courier, monospace;
            letter-spacing: 2px; /* 마스킹된 비밀번호처럼 보이게 */
        }
    </style>
</head>
<body>
    <div class="wrap">
        <div class="intro_bg">
            <div class="header">
                <h1 class="logo">cozypick</h1>
                <div class="nav">
                    <a href="#">HOME</a>
                    <a href="#ABOUTUS">ABOUT US</a>
                    <a href="#RESERVATION">RESERVATION</a>
                    <a href="#REVIEW">REVIEW</a>
                    <a href="#CONTACT">CONTACT</a>
                </div>
            </div>
        </div>
        <h2 class="info-title">내 정보 관리</h2>

        <div class="container">
            <div class="user-info">
                <img src="/image/user-3331257_1280.png" alt="Profile Picture" class="profile-picture">
                <div class="user-name">
                    <span id="username">사용자 이름</span>
                    <span class="edit-icon" onclick="editName()">✏️</span>
                </div>
                <span class="mail" id="mail">user@example.com</span>
            </div>
        </div>

        <div class="container">
            <div class="personal-info">개인정보</div>
            <div class="details">
                <span>아이디 :</span><span id="id">아이디</span>
            </div>
            <div class="details">
                이메일 : <span id="email">이메일</span>
            </div>
            <div class="details">
                비밀번호 : <span id="password" class="masked-password">********</span>
                <button class="edit-button" onclick="location.href='/change-pw/email'">수정하기</button>
            </div>
            <div class="details">
                휴대번호 : <span id="tel">휴대번호</span>
                <button class="edit-button" onclick="location.href='/leave'">수정하기</button>
            </div>
        </div>

        <div class="container">
            <button class="button small-button" onclick="location.href='/leave'">
                <span>회원탈퇴</span><span class="arrow"></span>
            </button>
        </div>

        <script>
            fetch('/api/user-info', {
                method: 'GET',
                credentials: 'include' // 쿠키를 포함하여 요청
            })
            .then(response => response.json())
            .then(userInfo => {
                // 사용자 정보를 화면에 출력
                document.getElementById('username').textContent = userInfo.name;
                document.getElementById('id').textContent = userInfo.username;
                document.getElementById('mail').textContent = userInfo.mail;
                document.getElementById('email').textContent = userInfo.mail;
                document.getElementById('tel').textContent = userInfo.tel;
            })
            .catch(error => {
                console.error('Error fetching user info:', error);
            });

            // 비밀번호 표시/숨기기 토글 기능
            document.getElementById('togglePassword').addEventListener('click', function () {
                var passwordField = document.getElementById('password');
                if (passwordField.textContent === '********') {
                    passwordField.textContent = 'myrealpassword'; // 실제 비밀번호로 변경
                    this.textContent = '숨기기';
                } else {
                    passwordField.textContent = '********'; // 다시 마스킹 처리
                    this.textContent = '표시하기';
                }
            });

            function editName() {
                var userName = prompt("새로운 사용자 이름을 입력하세요.");
                if (userName) {
                    document.getElementById("username").textContent = userName;
                }
            }

            function editPassword() {
                var newPassword = prompt("새로운 비밀번호를 입력하세요.");
                if (newPassword) {
                    alert("비밀번호가 성공적으로 변경되었습니다.");
                }
            }

            function editPhone() {
                var newPhone = prompt("새로운 휴대번호를 입력하세요.");
                if (newPhone) {
                    alert("휴대번호가 성공적으로 변경되었습니다.");
                }
            }

            function confirmDelete() {
                if (confirm("정말로 회원 탈퇴하시겠습니까?")) {
                    alert("회원 탈퇴가 완료되었습니다.");
                }
            }
        </script>
</body>
</html>
