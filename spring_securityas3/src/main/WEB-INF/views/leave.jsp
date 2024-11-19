<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Cozy Pick</title>
    <link rel="stylesheet" href="/css/leave.css">
    <style>
        .password-status {
            margin-top: 10px;
            font-size: 0.9em;
        }
        .password-status.match {
            color: green;
        }
        .password-status.mismatch {
            color: red;
        }
        .confirm-button {
            margin-top: 10px;
            padding: 8px 16px;
            background-color: #333;
            color: white;
            border: none;
            cursor: pointer;
        }
        .confirm-button:disabled {
            background-color: #888;
            cursor: not-allowed;
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
            <h2 class="withdrawal-title">회원탈퇴(카카오,네이버 로그인 사용시 비밀번호 cozypick 입력)</h2>
            <p class="withdrawal-guide">회원탈퇴를 하시려면 안내 및 동의가 필요합니다.</p>
            <p class="warning-message">정말로 회원탈퇴를 진행하시겠습니까?</p>
            
            <div class="password-input">
                <label for="password">비밀번호</label>
                <input type="password" id="password" placeholder="비밀번호를 입력하세요" oninput="checkPassword()">
                <button id="confirm-button" class="confirm-button" onclick="deleteUser()" disabled>확인</button>
            </div>
            
            <p id="password-status" class="password-status"></p>
        </div>
    </div>

    <script>
        // 전역 변수로 선언하여 모든 함수에서 접근할 수 있도록 합니다.
        let userEmail;

        // 페이지 로드 시 사용자 이메일을 가져옵니다.
        window.onload = function() {
            fetch('/api/user-info', {
                method: 'GET',
                credentials: 'include'
            })
            .then(response => response.json())
            .then(userInfo => {
                userEmail = userInfo.mail; // 전역 변수에 사용자 이메일 저장
            })
            .catch(error => {
                console.error('Error fetching user info:', error);
            });
        };

        // 비밀번호 체크 함수
        function checkPassword() {
            const password = document.getElementById("password").value;
            const statusMessage = document.getElementById("password-status");
            const confirmButton = document.getElementById("confirm-button");

            if (password === "") {
                statusMessage.textContent = "";
                confirmButton.disabled = true;
                return;
            }

            fetch('/password/check', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `email=${encodeURIComponent(userEmail)}&currentPassword=${encodeURIComponent(password)}`,
            })
            .then(response => response.text())
            .then(result => {
                if (result === "match") {
                    statusMessage.textContent = "비밀번호가 일치합니다.";
                    statusMessage.classList.remove("mismatch");
                    statusMessage.classList.add("match");
                    confirmButton.disabled = false;
                } else {
                    statusMessage.textContent = "비밀번호가 일치하지 않습니다.";
                    statusMessage.classList.remove("match");
                    statusMessage.classList.add("mismatch");
                    confirmButton.disabled = true;
                }
            })
            .catch(error => {
                console.error('Error checking password:', error);
                statusMessage.textContent = "비밀번호 확인 중 오류가 발생했습니다.";
                statusMessage.classList.remove("match");
                statusMessage.classList.add("mismatch");
                confirmButton.disabled = true;
            });
        }

        // 비밀번호가 일치할 경우 /deleteuser로 POST 요청 보내기
        function deleteUser() {
            const password = document.getElementById("password").value;

            fetch('/deleteuser', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `email=${encodeURIComponent(userEmail)}&password=${encodeURIComponent(password)}`,
            })
            .then(response => {
                if (response.ok) {
                    alert("회원탈퇴가 완료되었습니다.");
                    window.location.href = "/";
                } else {
                    alert("탈퇴 중 오류가 발생했습니다.");
                }
            })
            .catch(error => {
                console.error('Error during user deletion:', error);
                alert("탈퇴 중 오류가 발생했습니다.");
            });
        }
    </script>
</body>
</html>
