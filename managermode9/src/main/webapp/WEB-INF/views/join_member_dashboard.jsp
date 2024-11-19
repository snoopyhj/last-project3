<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>CozyPick 관리자 모드</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/css/join_member_dashboard.css">
<script src="https://code.highcharts.com/highcharts.js"></script>
<script src="https://code.highcharts.com/modules/accessibility.js"></script>
<!-- Highcharts CDN -->
</head>
<script>
document.addEventListener("DOMContentLoaded", function() {
    // 서버에서 전달된 JSON 데이터를 파싱하여 JavaScript 변수에 저장
    const jsonArray1 = JSON.parse('${jsonArray1}'.replace(/&quot;/g, '"'));
    const jsonArray2 = JSON.parse('${jsonArray2}'.replace(/&quot;/g, '"'));
    const jsonArray3 = JSON.parse('${jsonArray3}'.replace(/&quot;/g, '"'));

    // 첫 번째 차트: 월별 회원 가입자 수
    const categories1 = jsonArray1.map(item => item[0]); // 월 (가로축)
    const data1 = jsonArray1.map(item => item[1]);       // 가입자 수 (세로축)

    Highcharts.chart('chart', {
        chart: { 
            type: 'column',
            style: { fontFamily: 'Arial, sans-serif' }
        },
        title: { 
            text: '2024년 월별 회원 가입자 수',
            style: { fontSize: '18px', fontWeight: 'bold', color: '#333' }
        },
        xAxis: { 
            categories: categories1,
            title: { 
                style: { fontSize: '14px', color: '#666' }
            },
            labels: { style: { fontSize: '12px', color: '#666' } }
        },
        yAxis: {
            min: 0,
            title: { 
                text: '가입자 수',
                style: { fontSize: '14px', color: '#666' }
            },
            labels: { style: { fontSize: '12px', color: '#666' } }
        },
        series: [{
            name: '가입자 수',
            data: data1,
            color: '#B0BEC5', // 회색 색상으로 설정
            dataLabels: {
                enabled: true,
                align: 'center',
                verticalAlign: 'bottom',
                style: { fontSize: '12px', color: '#333' },
                formatter: function() {
                    return this.y;
                },
                y: -10 // 막대 위로 위치 조정
            }
        }],
        plotOptions: {
            column: {
                dataLabels: { enabled: true } // 데이터 레이블 활성화
            }
        },
        accessibility: { enabled: false }
    });

// 두 번째 차트: 분기별 회원 가입자 수
const categories2 = jsonArray2.map(item => item[0]); // 분기 (Q1, Q2, Q3, Q4)
const data2 = jsonArray2.map(item => item[1]);       // 각 분기의 가입자 수

Highcharts.chart('chart1', {
    chart: { 
        type: 'column',
        style: { fontFamily: 'Arial, sans-serif' }
    },
    title: { 
        text: '2024년 분기별 회원 가입자 수',
        style: { fontSize: '18px', fontWeight: 'bold', color: '#333' }
    },
    xAxis: { 
        categories: categories2,
        title: { 
            style: { fontSize: '14px', color: '#666' }
        },
        labels: { style: { fontSize: '12px', color: '#666' } }
    },
    yAxis: {
        min: 0,
        title: { 
            text: '가입자 수',
            style: { fontSize: '14px', color: '#666' }
        },
        labels: { style: { fontSize: '12px', color: '#666' } }
    },
    series: [{
        name: '가입자 수',
        data: data2,
        color: '#B0BEC5', // 회색 계열 색상으로 설정
        dataLabels: {
            enabled: true,
            align: 'center',
            verticalAlign: 'bottom',
            style: { fontSize: '12px', color: '#333' },
            formatter: function() {
                return this.y;
            },
            y: -10 // 막대 위로 위치 조정
        }
    }],
    plotOptions: {
        column: {
            dataLabels: { enabled: true } // 데이터 레이블 활성화
        }
    },
    accessibility: { enabled: false }
});

    // 세 번째 차트: 주간 회원 가입자 수
    const categories3 = jsonArray3.map(item => item[0]); // 날짜 (가로축)
    const data3 = jsonArray3.map(item => item[1]);       // 가입자 수 (세로축)

    Highcharts.chart('chart2', {
        chart: { type: 'column' },
        title: { text: '주간 회원 가입자 수' },
        xAxis: { 
            categories: categories3,
        },
        yAxis: {
            min: 0,
            title: { text: '가입자 수' }
        },
        
        series: [{
            name: '가입자 수',
            data: data3,
            color: '#B0BEC5', // 회색 계열 색상으로 설정
            dataLabels: {
                enabled: true,
                align: 'center',
                verticalAlign: 'bottom',
                style: { fontSize: '12px', color: '#333' },
                formatter: function() {
                    return this.y;
                },
                y: -10 // 막대 위로 위치 조정
            }
        }],
        plotOptions: {
            column: {
                dataLabels: { enabled: true } // 데이터 레이블 활성화
            }
        },
        accessibility: { enabled: false }
        
    });

    // 요약 텍스트 추가 (chart3 영역)
    const summaryContent = document.getElementById('chart3');
    let summaryText = `<h3>Business Summary</h3><br>`;

/*     // 각 날짜별 가입자 수 요약 텍스트 생성
    categories3.forEach((label, index) => {
        const count = data3[index];
        summaryText += label + `의 가입자 수는 `+ count + `명 입니다.`;
    }); */

    // 가입자가 가장 많은 날과 적은 날 정보 추가
    const maxCount = Math.max(...data3);
    const maxIndex = data3.indexOf(maxCount);
    const maxDay = categories3[maxIndex];
    
    const minCount = Math.min(...data3);
    const minIndex = data3.indexOf(minCount);
    const minDay = categories3[minIndex];

    summaryText += `가장 가입자가 많았던 날은 ` + maxDay + `로, 총 `+ maxCount + `명이 가입했으며,`;
    summaryText += ` 가장 가입자가 적었던 날은 ` + minDay+ `로, 총 ` + minCount + `명이 가입했습니다.<br>`;

    // 전체 평균 가입자 수 추가
    const totalSignUps = data3.reduce((sum, count) => sum + count, 0);
    const averageSignUps = (totalSignUps / data3.length).toFixed(2);
    summaryText += `<br>해당 기간 동안의 평균 가입자 수는 `+ averageSignUps + `명입니다.`;

    // 상승세 또는 하락세 분석 추가
    const increasingDays = data3.filter((count, index, array) => index > 0 && count > array[index - 1]).length;
    const decreasingDays = data3.length - increasingDays;
    summaryText += `<br>주간 통계에 따르면, 가입자 수가 전날 대비 증가한 날은 `+ increasingDays + `일, 감소한 날은 ` + decreasingDays + `일입니다.</p>`;

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
// 스케줄 목록을 todo-list 영역에 표시하는 함수
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

// 선택된 할 일을 삭제하는 함수
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

// 페이지 로드 시 기존 일정을 불러와 화면에 표시
window.onload = loadEvents;

</script>

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
    </main>


</body>

</html>