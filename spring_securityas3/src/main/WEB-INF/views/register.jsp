<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" type="text/css" href="/css/register.css">
	<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

</head>

<body>
    <div class="form-container">
        <h2>회원가입</h2>
        <form id="registrationForm" action="insert_member" method="POST" onsubmit="return showSuccessAlert();">
            <div class="form-group">
                <label for="id">아이디 입력</label>
                <input type="text" id="id" name="id" required>
                <button type="button" id="checkDuplicate" class="duplicate-check-btn">중복 체크</button>
            </div>
            <div id="duplicateMessage" style="color: red; display: none;">아이디가 이미 사용 중입니다.</div>
            
            <div class="form-group">
                <label for="email">이메일 입력</label>
                <input type="email" id="email" name="email" required>
                <button type="button" id="sendEmailButton">인증 번호 보내기</button>
                <div id="emailMessage" style="color: red; display: none;"></div>
            </div>

            <div class="form-group" id="verificationGroup" style="display: none;">
                <label for="verificationCode">인증 번호 입력</label>
                <input type="text" id="verificationCode" name="verificationCode" required>
                <button type="button" id="verifyCodeButton">인증하기</button>
                <div id="verificationMessage" style="color: red; display: none;"></div>
            </div>

            <div class="form-group">
                <label for="pwd">비밀번호 입력</label>
                <input type="password" id="pwd" name="pwd" required>
                <div id="passwordMessage" style="color: red; display: none;">비밀번호 조건을 충족하지 않았습니다.</div>
            </div>

            <div class="form-group">
                <label for="name">이름 입력</label>
                <input type="text" id="name" name="name" required>
            </div>

			<div class="form-group">
			    <label for="birthday">생년월일 입력 (8자리 숫자, 예: 19900101)</label>
			    <input type="text" id="birthday" name="birthday" required>
			    <div id="birthdayMessage" style="color: red; display: none;">생년월일은 8자리 숫자여야 합니다.</div>
			</div>

            <div class="form-group">
                <label for="tel">전화번호 입력 (010-XXXX-XXXX)</label>
                <input type="text" id="tel" name="tel" required>
                <div id="telMessage" style="color: red; display: none;">전화번호는 010으로 시작하는 11자리여야 합니다.</div>
            </div>

			<div class="form-group">
			    <label for="address">주소 입력</label>
			    <input type="text" id="postcode" name="postcode" placeholder="우편번호" required readonly>
			    <input type="button" id="addressSearchBtn" onclick="execDaumPostcode()" value="주소 검색"><br>
			    <input type="text" id="address" name="address" placeholder="주소" required readonly>
			    <input type="text" id="detailAddress" name="detailAddress" placeholder="상세 주소" required>
			</div>


            <div class="form-group">
                <label>성별을 선택해주세요:</label>
                <input type="radio" id="male" name="gender" value="남자" required> 남자
                <input type="radio" id="female" name="gender" value="여자" required> 여자
            </div>

            <div class="form-group">
                <label>가입 경로를 선택해주세요:</label>
                <input type="checkbox" name="signupRoute" value="지인추천"> 지인추천
                <input type="checkbox" name="signupRoute" value="네이버검색"> 네이버검색
                <input type="checkbox" name="signupRoute" value="구글검색"> 구글검색
                <input type="checkbox" name="signupRoute" value="온라인광고"> 온라인광고
                <input type="checkbox" name="signupRoute" value="전단지"> 전단지
            </div>

            <div class="form-group">
                <label>원하시는 숙소 테마를 선택해주세요:</label>
                <input type="checkbox" name="signupRoute" value="글램핑"> 글램핑
                <input type="checkbox" name="signupRoute" value="키즈펜션"> 키즈펜션
                <input type="checkbox" name="signupRoute" value="반려동물 동반"> 반려동물 동반
                <input type="checkbox" name="signupRoute" value="풀빌라"> 풀빌라
                <input type="checkbox" name="signupRoute" value="스파"> 스파
                <input type="checkbox" name="signupRoute" value="오션뷰"> 오션뷰
                <input type="checkbox" name="signupRoute" value="반나절 호캉스"> 반나절 호캉스
            </div>

            <div class="form-actions">
                <input type="submit" value="저장" id="submitBtn" disabled />
                <a href=""><input type="reset" value="취소" onclick="location.href='/'"/></a>
            </div>
        </form>
    </div>

    <script>
        let isUsernameAvailable = false; // 중복 체크 상태
        let isPasswordValid = false; // 비밀번호 체크 상태
        let isEmailVerified = false; // 이메일 인증 상태
        let isPhoneNumberValid = false; // 전화번호 체크 상태
		function execDaumPostcode() {
		        new daum.Postcode({
		            oncomplete: function(data) {
		                // 검색 결과로 나온 데이터를 각 필드에 넣음
		                document.getElementById('postcode').value = data.zonecode; // 우편번호
		                document.getElementById('address').value = data.address; // 주소
		                
		                // 상세 주소 입력란으로 포커스를 이동
		                document.getElementById('detailAddress').focus();
		            }
		        }).open();
		    }
        document.getElementById('checkDuplicate').addEventListener('click', function () {
            const username = document.getElementById('id').value;

            if (!username || username.length < 8) {
                alert('아이디를 8자 이상 입력하세요.');
                return;
            }

            fetch(`/check-duplicate?username=${encodeURIComponent(username)}`)
                .then(response => response.json())
                .then(data => {
                    const duplicateMessage = document.getElementById('duplicateMessage');
                    if (data.exists) {
                        duplicateMessage.style.display = 'block';
                        duplicateMessage.textContent = '아이디가 이미 사용 중입니다.';
                        isUsernameAvailable = false; // 아이디 중복
                        document.getElementById('submitBtn').disabled = true; // 버튼 비활성화
                    } else {
                        duplicateMessage.style.display = 'block';
                        duplicateMessage.textContent = '사용 가능한 아이디입니다.';
                        duplicateMessage.style.color = 'green';
                        isUsernameAvailable = true; // 아이디 사용 가능
                        document.getElementById('submitBtn').disabled = !(isUsernameAvailable && isPasswordValid && isEmailVerified && isPhoneNumberValid); // 버튼 활성화
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                });
        });

        // 이메일 인증 처리
        document.getElementById('sendEmailButton').addEventListener('click', function () {
            const email = document.getElementById('email').value;

            if (!email) {
                alert('이메일을 입력하세요.');
                return;
            }

            fetch('/send-email', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ email: email })
            })
            .then(response => response.json())
            .then(data => {
                const emailMessage = document.getElementById('emailMessage');
                if (data.success) {
                    emailMessage.style.color = 'green';
                    emailMessage.textContent = '인증 번호가 이메일로 전송되었습니다.';
                    emailMessage.style.display = 'block';

                    // 인증 번호 입력란 표시
                    document.getElementById('verificationGroup').style.display = 'block';
                } else {
                    emailMessage.style.color = 'red';
                    emailMessage.textContent = '이메일 전송에 실패했습니다.';
                    emailMessage.style.display = 'block';
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
        });

        // 인증 코드 검증 처리
        document.getElementById('verifyCodeButton').addEventListener('click', function () {
            const code = document.getElementById('verificationCode').value;

            if (!code) {
                alert('인증 번호를 입력하세요.');
                return;
            }

            fetch('/verify-code', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ code: code })
            })
            .then(response => response.json())
            .then(data => {
                const verificationMessage = document.getElementById('verificationMessage');
                if (data.success) {
                    verificationMessage.style.color = 'green';
                    verificationMessage.textContent = '인증 성공';
                    isEmailVerified = true; // 인증 성공
                } else {
                    verificationMessage.style.color = 'red';
                    verificationMessage.textContent = '인증 실패';
                    isEmailVerified = false; // 인증 실패
                }
                verificationMessage.style.display = 'block'; // 메시지 표시

                // 버튼 활성화 여부 체크
                document.getElementById('submitBtn').disabled = !(isUsernameAvailable && isPasswordValid && isEmailVerified && isPhoneNumberValid); // 버튼 활성화
            })
            .catch(error => {
                console.error('Error:', error);
            });
        });

        // 전화번호 검증
        document.getElementById('tel').addEventListener('input', function () {
            const tel = this.value;
            const telMessage = document.getElementById('telMessage');
            const regex = /^010-\d{4}-\d{4}$/;

            if (!regex.test(tel)) {
                telMessage.style.display = 'block';
                isPhoneNumberValid = false;
            } else {
                telMessage.style.display = 'none';
                isPhoneNumberValid = true;
            }

            // 버튼 활성화 여부 체크
            document.getElementById('submitBtn').disabled = !(isUsernameAvailable && isPasswordValid && isEmailVerified && isPhoneNumberValid); // 버튼 활성화
        });

        // 비밀번호 검증
		// 비밀번호 검증
		document.getElementById('pwd').addEventListener('input', function () {
		    const pwd = this.value;
		    const passwordMessage = document.getElementById('passwordMessage');

		    // 비밀번호 조건: 8자 이상, 숫자 포함, 문자 포함, 특수문자 포함
		    const isValid = pwd.length >= 8 && /[0-9]/.test(pwd) && /[a-zA-Z]/.test(pwd) && /[!@#$%^&*(),.?":{}|<>]/.test(pwd);
		    if (!isValid) {
		        passwordMessage.style.display = 'block';
		        isPasswordValid = false;
		    } else {
		        passwordMessage.style.display = 'none';
		        isPasswordValid = true;
		    }

            // 버튼 활성화 여부 체크
            document.getElementById('submitBtn').disabled = !(isUsernameAvailable && isPasswordValid && isEmailVerified && isPhoneNumberValid); // 버튼 활성화
        });
		document.getElementById('birthday').addEventListener('input', function () {
		        const birthday = this.value;
		        const birthdayMessage = document.getElementById('birthdayMessage');
		        const regex = /^\d{8}$/; // 8자리 숫자만 허용

		        if (!regex.test(birthday)) {
		            birthdayMessage.style.display = 'block';
		            birthdayMessage.textContent = '생년월일은 8자리 숫자여야 합니다.';
		        } else {
		            birthdayMessage.style.display = 'none';
		        }
		    });
			function showSuccessAlert() {
			    alert('회원가입 성공!');
			    return true; // 폼 제출을 계속 진행합니다.
			}
    </script>
</body>
</html>
