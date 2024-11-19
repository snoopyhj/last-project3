<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Daily Dashboard</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/daily_dashboard.css">
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>
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
				<a href ="/update_hotelInfo"><button class="content">호텔정보 수정</button></a>
				</div>
				<button class="user_management">사용자 관리</button>
				<button class="settings">환경설정</button>
			</div>
		</aside>

        <section class="manager-memo">
            <h3>Manager Memo</h3>
            <button onclick="saveMemoAsText()" class="savememo">메모 저장</button>
            <textarea id="memo-text" class="lined-textarea" placeholder="메모 내용을 입력하세요..."></textarea>

            <h3 class="todolisth3">To-do List</h3>
            <button id="add-event-button" class="add-event-button" onclick="showEventForm()">할일 추가</button>
            <div id="event-form" class="event-form" style="display:none;">
                <input type="date" id="event-date" required>
                <input type="text" class="event-title" id="event-title" placeholder="일정 내용" required>
                <button id="add_button" class="add_button">추가</button>
            </div>
            <div class="todolist" id="todo-list"></div>
        </section>

<main class="main-content">
    <div class="content-area" id="content-area">
        <table class="data-table">
            <thead>
                <tr>
                    <th class="haha">항목</th>
                    <th class="haha">어제</th>
                    <th class="haha">오늘</th>
                    <th class="haha">전일比</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="haha">가입자 수</td>
                    <td id="yesterdaySignupCount"></td>
                    <td id="todaySignupCount"></td>
                    <td id="signupChangeRate"></td>
                </tr>
                <tr>
                    <td class="haha">탈퇴자 수</td>
                    <td id="yesterdayWithdrawCount">15명</td>
                    <td id="todayWithdrawCount">21명</td>
                    <td id="withdrawChangeRate" ><span style="color: #e74c3c;">▲ 40%</span></td>
                </tr>
                <tr>
                    <td class="haha">예약 건수</td>
                    <td id="yesterdayReservationCount">10명</td>
                    <td id="todayReservatihonCount">20명</td>
                    <td id="reservationChangeRate"><span style="color: #e74c3c;">▲ 50%</span></td>
                </tr>
                <tr>
                    <td class="haha">총 결제 금액</td>
                    <td id="yesterdayTotalPayment"></td>
                    <td id="todayTotalPayment"></td>
                    <td id="paymentChangeRate"></td>
                </tr>
                <tr>
                    <td class="haha">자사 수수료</td>
                    <td id="yesterdayCommission"></td>
                    <td id="todayCommission"></td>
                    <td id="commissionChangeRate"></td>
                </tr>
                <tr>
                    <td class="haha">등록 리뷰 건수</td>
                    <td id="yesterdayReviewCount"></td>
                    <td id="todayReviewCount"></td>
                    <td id="reviewChangeRate"></td>
                </tr>
            </tbody>
        </table>
    </div>
</main>
    </div>

<script>
document.addEventListener("DOMContentLoaded", function () {

    // 가입자수 
	const yesterdaySignupCount = ${yesterdaySignupCount};
    const todaySignupCount = ${todaySignupCount};
    let signupChangeRate = parseFloat("${signupChangeRate}");

	// 예약건수
    const yesterdayReservationCount = ${yesterdayReservationCount};
    const todayReservationCount = ${todayReservationCount};
    let reservationChangeRate = parseFloat("${reservationChangeRate}");

    // 총 결제금액
    const yesterdayTotalPayment = ${yesterdayTotalPayment};
    const todayTotalPayment = ${todayTotalPayment};
    let paymentChangeRate = parseFloat("${paymentChangeRate}");
    
 	// 자사 수수료 계산 (12.5% 곱하기) 
    const yesterdayCommission = (yesterdayTotalPayment * 0.125).toFixed(2);
    const todayCommission = (todayTotalPayment * 0.125).toFixed(2);
    
    let commissionChangeRate = 0;
    if (yesterdayCommission > 0) {
        commissionChangeRate = ((todayCommission - yesterdayCommission) / yesterdayCommission * 100).toFixed(2);
    } else if (todayCommission > 0) {
        commissionChangeRate = 100.0;
    }
    
    // 리뷰 건수
    const yesterdayReviewCount = ${yesterdayReviewCount};
    const todayReviewCount = ${todayReviewCount};
    let reviewChangeRate = 0;
    if (yesterdayReviewCount > 0) {
        reviewChangeRate = ((todayReviewCount - yesterdayReviewCount) / yesterdayReviewCount * 100).toFixed(2);
    } else if (todayReviewCount > 0) {
        reviewChangeRate = 100.0;
    }

    
    // 증감률 기호 추가
    signupChangeRate = (signupChangeRate > 0 ? "▲ " : signupChangeRate < 0 ? "▼ " : "") + Math.abs(signupChangeRate) + "%";
    reservationChangeRate = (reservationChangeRate > 0 ? "▲ " : reservationChangeRate < 0 ? "▼ " : "") + Math.abs(reservationChangeRate) + "%";
    paymentChangeRate = (paymentChangeRate > 0 ? "▲ " : paymentChangeRate < 0 ? "▼ " : "") + Math.abs(paymentChangeRate) + "%";
    commissionChangeRate = (commissionChangeRate > 0 ? "▲ " : commissionChangeRate < 0 ? "▼ " : "") + Math.abs(commissionChangeRate) + "%";
    reviewChangeRate = (reviewChangeRate > 0 ? "▲ " : reviewChangeRate < 0 ? "▼ " : "") + Math.abs(reviewChangeRate) + "%";


    //가입자수
    document.getElementById("yesterdaySignupCount").textContent = yesterdaySignupCount + "명";
    document.getElementById("todaySignupCount").textContent = todaySignupCount + "명";
    document.getElementById("signupChangeRate").textContent = signupChangeRate;

	// 예약건수
    document.getElementById("yesterdayReservationCount").textContent = yesterdayReservationCount + "건";
    document.getElementById("todayReservationCount").textContent = todayReservationCount + "건";
    document.getElementById("reservationChangeRate").textContent = reservationChangeRate;

    // 총 결제금액
    document.getElementById("yesterdayTotalPayment").textContent = yesterdayTotalPayment + "원";
    document.getElementById("todayTotalPayment").textContent = todayTotalPayment + "원";
    document.getElementById("paymentChangeRate").textContent = paymentChangeRate;
    
    // 수수료
    document.getElementById("yesterdayCommission").textContent = yesterdayCommission + "원";
    document.getElementById("todayCommission").textContent = todayCommission + "원";
    document.getElementById("commissionChangeRate").textContent = commissionChangeRate;

    // 리뷰 건수
    document.getElementById("yesterdayReviewCount").textContent = yesterdayReviewCount + "건";
    document.getElementById("todayReviewCount").textContent = todayReviewCount + "건";
    document.getElementById("reviewChangeRate").textContent = reviewChangeRate;
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
        eventForm.style.display = eventForm.style.display === "block" ? "none" : "block";
    }

    const add_button = document.getElementById("add_button");
    add_button.addEventListener("click", () => {
        const date = document.getElementById("event-date").value;
        const title = document.getElementById("event-title").value;

        if (!date || !title) {
            alert("날짜와 일정을 입력해주세요.");
            return;
        }

        let schedules = JSON.parse(localStorage.getItem("schedules")) || [];
        schedules.push({ date, title });
        localStorage.setItem("schedules", JSON.stringify(schedules));
        loadEvents();

        document.getElementById("event-form").style.display = "none";
        document.getElementById("event-date").value = '';
        document.getElementById("event-title").value = '';
    });

    function loadEvents() {
        const todoList = document.getElementById("todo-list");
        todoList.innerHTML = "";

        let schedules = JSON.parse(localStorage.getItem("schedules")) || [];
        schedules.forEach((schedule, index) => {
            const listItem = document.createElement("div");
            listItem.className = "todo-item";
            listItem.innerHTML =  `날짜: ` + schedule.date;
            listItem.innerHTML += `<br>일정: ` + schedule.title;
            
            const deleteButton = document.createElement("button");
            deleteButton.textContent = "삭제";
            deleteButton.onclick = () => deleteEvent(index);
            listItem.appendChild(deleteButton);

            todoList.appendChild(listItem);
        });
    }

    function deleteEvent(index) {
        let schedules = JSON.parse(localStorage.getItem("schedules")) || [];
        schedules.splice(index, 1);
        localStorage.setItem("schedules", JSON.stringify(schedules));
        loadEvents();
    }

    window.onload = loadEvents;
});
</script>
</body>
</html>
