<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/register.css">

</head>

<body>
    <div class="form-container">
        <h2>회원가입</h2>
        <form action="insert_member" method="POST">
            <div class="form-group">
                <label for="id">아이디 입력</label>
                <input type="text" id="id" name="id" required>
            </div>

            <div class="form-group">
                <label for="pwd">비밀번호 입력</label>
                <input type="password" id="pwd" name="pwd" required>
            </div>

            <div class="form-group">
                <label for="name">이름 입력</label>
                <input type="text" id="name" name="name" required>
            </div>

            <div class="form-group">
                <label for="birthday">생년월일 입력</label>
                <input type="text" id="birthday" name="birthday" required>
            </div>

            <div class="form-group">
                <label for="tel">전화번호 입력</label>
                <input type="text" id="tel" name="tel" required>
            </div>

            <div class="form-group">
                <label for="address">주소 입력</label>
                <input type="text" id="address" name="address" required>
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
				    <a href="/login"> <input type="submit" value="저장" /> </a>
				    <a href=""> <input type="reset" value="취소" onclick="location.href='/'"/> </a>
				</div>
        </form>
    </div>
</body>

</html>