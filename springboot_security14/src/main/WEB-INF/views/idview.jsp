<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>아이디 찾기 결과</title>
    <link rel="stylesheet" type="text/css" href="/css/id-view.css">
</head>
<body>
<div class="container">
    <h2>아이디 찾기 결과</h2>
    <p id="displayId" style="font-size: 18px; font-weight: bold;"></p> <!-- 아이디를 표시할 곳 -->

    <div class="form-actions">
        <button onclick="location.href='/login'">로그인하기</button>
    </div>
</div>

<script>
    // 서버에서 ID를 전달받아 화면에 표시
    document.addEventListener('DOMContentLoaded', function () {
        // AJAX 요청을 통해 서버에서 ID를 가져옴
        fetch('/get-found-id', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            const displayIdElement = document.getElementById('displayId');
            if (data.success && data.id) {
                displayIdElement.textContent = `찾은 아이디: ${data.id}`; // 아이디를 화면에 표시
            } else {
                displayIdElement.textContent = '아이디를 찾을 수 없습니다.'; // 아이디가 없을 경우
            }
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('displayId').textContent = '아이디를 찾을 수 없습니다.';
        });
    });
</script>
</body>
</html>
