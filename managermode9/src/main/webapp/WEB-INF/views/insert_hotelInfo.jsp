<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/insert_hotelInfo.css">
</head>
<body>
	<div class="container">
		<header class="header">
            <div class="header-content">
            	<a href="https://localhost:8444" class="cozypick">cozypick</a>
               <button class="logout-btn" onclick="location.href='https://localhost:8443/logout'">로그아웃</button>
            </div>
        </header>



		<aside class="sidebar">
			<div class="sidebar-content">
				<button class="dashboard_button">Dash Board</button>
				<div class="dashboard_section">
				<a href = "/join_member_dashboard"><button class="dashboard">회원가입 현황</button></a>
				<a href = "/member_analysis_dashboard"><button class="dashboard">회원 분석</button></a>
				<a href = "/daily_dashboard"><button class="dashboard">실시간 Daily현황</button></a>

				</div>
				<button class="content_button">호텔 관리</button>
				<div class="content-management">
					<a href ="/insert_hotelInfo"><button class="content">호텔정보 등록</button></a>
					<a href ="/update_hotelInfo"><button class="content1">호텔정보 수정</button></a>
				</div>
				<button class="user_management">사용자 관리</button>
				<button class="settings">환경설정</button>
			</div>
		</aside>

<section class="manager-memo">
    <h3>Manager Memo</h3><button onclick="saveMemoAsText()" class="savememo">메모 저장</button>
    <textarea id="memo-text" class="lined-textarea" placeholder="메모 내용을 입력하세요..."></textarea>

    <h3 class = "todolisth3">To-do List</h3>
    <button id="add-event-button" class = "add-event-button" onclick="showEventForm()">할일 추가</button>
    <div id="event-form" class ="event-form" style="display:none;">
    	<input type="date" id="event-date" required>
    	<input type="text" class = "event-title" id="event-title" placeholder="일정 내용" required>
    	<button id ="add_button" class = "add_button">추가</button>
    </div>
    <div class="todolist" id="todo-list"></div> <!-- 할 일 목록 표시 영역 -->
</section>

<main class="main-content">
	<h5>추가하실 호텔 정보를 입력해주세요.</h5>
	<div id="hotel-registration-form">
    <form id="hotelForm" action="${pageContext.request.contextPath}/default_num_check" method="post">

        <div class="form-row">
            <div class="form-group">
                <label for="name">숙소 이름<span class="required">*</span></label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="form-group">
                <label for="address">숙소 주소<span class="required">*</span></label>
                <input type="text" id="address" name="address" required>
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="mapx">숙소 위도<span class="required">*</span></label>
                <input type="text" id="mapx" name="mapx" required>
            </div>
            <div class="form-group">
                <label for="mapy">숙소 경도<span class="required">*</span></label>
                <input type="text" id="mapy" name="mapy" required>
            </div>
        </div>
        
        <div class="form-row">
            <div class="form-group">
                <label for="region">Region 코드</label>
                <select id="region" name="region">

                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="31">31</option>
                    <option value="32">32</option>
                    <option value="33">33</option>
                    <option value="34">34</option>
                    <option value="35">35</option>
                    <option value="36">36</option>
                    <option value="37">37</option>
                    <option value="38">38</option>
                    <option value="39">39</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="subregion">Subregion 코드</label>
                <select id="subregion" name="subregion">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                    <option value="6">6</option>
                    <option value="7">7</option>
                    <option value="8">8</option>
                    <option value="9">9</option>
                    <option value="10">10</option>
                    <option value="11">11</option>
                    <option value="12">12</option>
                    <option value="13">13</option>
                    <option value="14">14</option>
                    <option value="15">15</option>
                    <option value="16">16</option>
                    <option value="17">17</option>
                    <option value="18">18</option>
                    <option value="19">19</option>
                    <option value="20">20</option>
                    <option value="21">21</option>
                    <option value="22">22</option>
                    <option value="23">23</option>
                    <option value="24">24</option>
                    <option value="25">25</option>
                    <option value="26">26</option>
                    <option value="27">27</option>
                    <option value="28">28</option>
                    <option value="29">29</option>
                    <option value="31">31</option>
                    </select>
            </div>
        </div>


        <div class="form-row">
            <div class="form-group">
                <label for="type">숙소 타입</label>
                <select id="type" name="type">
                    <option value="hotel">호텔</option>
                    <option value="motel">모텔</option>
                    <option value="pension">펜션</option>
                    <option value="hanok">한옥</option>
                    <option value="guesthouse">게스트하우스</option>
                </select>
            </div>
            <div class="form-group">
                <label for="img_auth">이미지 권한 타입</label>
                <select id="img_auth" name="img_auth">
                    <option value="Type1">Type1</option>
                    <option value="Type2">Type2</option>
                    <option value="Type3">Type3</option>
                </select>
            </div>
        </div>


       <div class="form-row">
            <div class="form-group">
                <label for="person">최대 숙박 인원수</label>
                <input type="text" id="person" name="person">
            </div>
            <div class="form-group">
                <label for="STANDARD">STANDARD룸 가격</label>
                <input type="text" id="standard" name="standard">
            </div>
        </div>


        <div class="form-row">
            <div class="form-group">
                <label for="DELUXE">DELUXE룸 가격</label>
                <input type="text" id="deluxe" name="deluxe">
            </div>
            <div class="form-group">
                <label for="SUITE">SUITE룸 가격</label>
                <input type="text" id="suite" name="suite">
            </div>
        </div>


        <div class="form-row">
            <div class="form-group">
                <label for="tel">숙소 전화번호</label>
                <input type="text" id="tel" name="tel">
            </div>
            <div class="form-group">
                <label for="default_num">호텔 고유번호 (영어대소문자 & 숫자 필수포함 5자리)</label>
                <input type="text" id="default_num_insert" name="default_num" pattern="[A-Za-z0-9]{1,5}" title="영어 소문자, 대문자, 숫자로 이루어진 5글자를 입력하세요.">
            </div>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="img1">이미지 경로1</label>
                <input type="text" id="img1" name="img1">
            </div>
            <div class="form-group">
                <label for="img2">이미지 경로2</label>
                <input type="text" id="img2" name="img2">
            </div>
        </div>

        <div class="form-row">
            <label for="coment">comment</label>
            <textarea id="coment" name="coment" rows="4"></textarea>
        </div>

        <div class="form-buttons">
            <button type="submit" id="saveHotelButton">저장</button>
            <button type="button" id="cancelButton">초기화</button>
        </div>
    </form>
</div>
</body>
<script>
// ================================ 메모장 저장 =============================================

	function saveMemoAsText() {
const memoContent = document.getElementById('memo-text').value;
const blob = new Blob([memoContent], { type: 'text/plain' });
const url = URL.createObjectURL(blob);
const link = document.createElement('a');
link.href = url;
link.download = 'memo.txt';
link.click();
URL.revokeObjectURL(url); // 메모리 해제
}
	
	// ================================ todo-list  =============================================
function showEventForm() {
const eventForm = document.getElementById("event-form");
// 현재 display가 "block"인지 확인하고, "none"으로 변경하거나, "block"으로 설정
if (eventForm.style.display === "block") {
    eventForm.style.display = "none";
} else {
    eventForm.style.display = "block";
}
}

document.addEventListener("DOMContentLoaded", function() {
// 페이지가 완전히 로드된 후 이벤트 리스너를 추가합니다.
const add_button = document.getElementById("add_button");
if (add_button) {
    add_button.addEventListener("click", () => {
        const date = document.getElementById("event-date").value;
        const title = document.getElementById("event-title").value;

        if (!date || !title) {
            alert("날짜와 일정을 입력해주세요.");
            return;
        }

        // localStorage에서 기존 일정 배열 가져오기 (없으면 빈 배열 생성)
        let schedules = JSON.parse(localStorage.getItem("schedules")) || [];

        // 새로운 일정 객체 생성 후 배열에 추가
        let schedule = { date, title };
        schedules.push(schedule);

        // 업데이트된 배열을 localStorage에 저장
        localStorage.setItem("schedules", JSON.stringify(schedules));

        // 화면에 일정을 표시하는 함수 호출
        loadEvents();

        // event-form을 숨기기 및 입력 초기화
        document.getElementById("event-form").style.display = "none";
        document.getElementById("event-date").value = '';
        document.getElementById("event-title").value = '';
    });
}
});
//스케줄 목록을 todo-list 영역에 표시하는 함수
function loadEvents() {
const todoList = document.getElementById("todo-list");
todoList.innerHTML = ""; // 기존 내용 초기화

// localStorage에서 일정 배열 가져오기
let schedules = JSON.parse(localStorage.getItem("schedules")) || [];

// 일정이 존재할 경우 화면에 추가
schedules.forEach((schedule, index) => {
    const listItem = document.createElement("div");
    listItem.className = "todo-item";
    listItem.innerHTML =  `날짜: ` + schedule.date;
    listItem.innerHTML += `<br>일정: ` + schedule.title;
    
    // 삭제 버튼 생성 및 추가
    const deleteButton = document.createElement("button");
    deleteButton.textContent = "삭제";
    deleteButton.onclick = () => deleteEvent(index); // 클릭 시 deleteEvent 함수 호출
    listItem.appendChild(deleteButton);

    todoList.appendChild(listItem);
});
}

//선택된 할 일을 삭제하는 함수
function deleteEvent(index) {
// localStorage에서 일정 배열 가져오기
let schedules = JSON.parse(localStorage.getItem("schedules")) || [];

// 해당 인덱스의 일정 삭제
schedules.splice(index, 1);

// 업데이트된 배열을 localStorage에 저장
localStorage.setItem("schedules", JSON.stringify(schedules));

// 화면에 일정을 다시 로드하여 업데이트
loadEvents();
}

//페이지 로드 시 기존 일정을 불러와 화면에 표시
window.onload = loadEvents;

</script>
</html>