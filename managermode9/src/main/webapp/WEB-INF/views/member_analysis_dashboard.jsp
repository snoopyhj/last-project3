<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/member_analysis_dashboard.css">
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
    <div class="content-area" id="content-area">
        <div id="chart" class="chart-container"></div>
        <div id="chart1" class="chart-container"></div>
        <div id="chart2" class="chart-container"></div>
        <div id="chart3" class="chart-container"></div>
    </div>

</body>

<script>

document.addEventListener("DOMContentLoaded", function() {
    // 서버에서 전달된 JSON 데이터를 파싱하여 JavaScript 변수에 저장
    const jsonArray1 = JSON.parse('${jsonArray1}'.replace(/&quot;/g, '"')); // 연령별 회원 비율 데이터
    const jsonArray2 = JSON.parse('${jsonArray2}'.replace(/&quot;/g, '"')); // 가입경로별 회원 수 데이터
    const jsonArray3 = JSON.parse('${jsonArray3}'.replace(/&quot;/g, '"')); // 성별 회원 비율 데이터

    // 첫 번째 차트 (도넛형 차트): 연령별 회원 비율
    const chartData1 = jsonArray1.map(item => {
        return {
            name: item.ageGroup,
            y: item.count
        };
    });

    Highcharts.chart('chart', {
        chart: {
            type: 'pie'
        },
        title: {
            text: '연령별 회원 비율'
        },
        plotOptions: {
            pie: {
                innerSize: '50%', // 도넛형으로 만들기 위한 속성
                depth: 45,
                dataLabels: {
                    enabled: true,
                    format: '{point.name}: {point.y}명'
                }
            }
        },
        series: [{
            name: '회원 수',
            data: chartData1
        }],
        accessibility: { enabled: false } // 접근성 경고 비활성화
    });

    // 두 번째 차트 (막대형 차트): 가입경로별 회원 분류
    const categories2 = jsonArray2.map(item => item[0]); // 가입경로 이름 (가로축)
    const data2 = jsonArray2.map(item => item[1]);       // 가입자 수 (세로축)

    Highcharts.chart('chart1', {
        chart: { type: 'column' },
        title: { text: '가입경로별 회원수' },
        xAxis: { 
            categories: categories2,
        },
        yAxis: {
            min: 0,
            title: { text: '가입자 수' }
        },
        series: [{
            name: '가입자 수',
            data: data2, // 가입경로별 가입자 수 데이터
            color: '#B0BEC5' // 막대 색상을 회색으로 설정
        }],
        
        plotOptions: {
            column: {
                dataLabels: { enabled: true } // 데이터 레이블 활성화
            }
        },
        accessibility: { enabled: false } // 접근성 경고 비활성화
    });

    // 세 번째 차트 (도넛형 차트): 성별 회원 비율
    const chartData3 = jsonArray3.map(item => {
        return {
            name: item.gender,
            y: item.count
        };
    });

    Highcharts.chart('chart2', {
        chart: {
            type: 'pie'
        },
        title: {
            text: '성별 회원 비율'
        },
        plotOptions: {
            pie: {
                innerSize: '50%', // 도넛형으로 만들기 위한 속성
                depth: 45,
                dataLabels: {
                    enabled: true,
                    format: '{point.name}: {point.y}명'
                }
            }
        },
        series: [{
            name: '회원 수',
            data: chartData3
        }],
        accessibility: { enabled: false } // 접근성 경고 비활성화
    });

    // Business Summary 요약 텍스트 추가 (chart3 영역)
    const summaryContent = document.getElementById('chart3');
    let summaryText = `<h3>Business Summary</h3><br>`;

    // 연령별 회원 비율 요약
    const totalAgeGroupCount = chartData1.reduce((sum, item) => sum + item.y, 0);
    const maxAgeGroup = chartData1.reduce((prev, current) => (prev.y > current.y) ? prev : current);
    summaryText += `<span style="font-weight: bold;">[연령대 분석]</span><br>`
    summaryText += `전체 회원 수는 ` + totalAgeGroupCount + `명이며, 가장 많은 연령대는 ` + maxAgeGroup.name + `로, 전체의 ` + (maxAgeGroup.y / totalAgeGroupCount * 100).toFixed(2) + `%인 ` + maxAgeGroup.y + `명입니다.<br><br>`;

 	// 가입경로별 회원 분류 요약
    const totalSignups = data2.reduce((sum, count) => sum + count, 0);
    const maxSignupRouteIndex = data2.indexOf(Math.max(...data2));
    const signupRouteSummary = data2.map((count, i) => {
        const percentage = ((count / totalSignups) * 100).toFixed(2);
        return categories2[i] + `: ` + count + `명 ` + percentage + `%`;
    }).join(', ');
    
    summaryText += `<span style="font-weight: bold;">[가입경로 분석]</span><br>`;
    summaryText += `가장 많이 이용된 가입 경로는 ` + categories2[maxSignupRouteIndex] + `로, 전체의 ` + (data2[maxSignupRouteIndex] / totalSignups * 100).toFixed(2) + `%인 ` + data2[maxSignupRouteIndex] + `명이 이 경로를 통해 가입했습니다. <br>'` +  categories2[maxSignupRouteIndex] + `'를 통한 마케팅 전략을 고려해보는 것이 좋겠습니다.<br><br>`;

    // 성별 회원 비율 요약
const totalGenderCount = chartData3.reduce((sum, item) => sum + item.y, 0);
const genderSummary = chartData3.map(item => {
    const percentage = ((item.y / totalGenderCount) * 100).toFixed(2);
    return item.name + `: ` + item.y + `명 ` + percentage +`%`;
}).join(', ');

// 요약 텍스트에 추가
summaryText += `<span style="font-weight: bold;">[성별 요약]</span><br>`
summaryText += genderSummary + `<br>`;

    // 요약 텍스트를 chart3 영역에 추가
    summaryContent.innerHTML = summaryText;
});
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

//add_button 클릭 이벤트 리스너
const add_button = document.getElementById("add_button");

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