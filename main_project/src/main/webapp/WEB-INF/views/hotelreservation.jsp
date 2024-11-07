<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset = "UTF-8">
	<meta name = "viewport" content = "width=device-width, initial-scale=1.0">
    <title>숙소 예약 페이지</title>
	<link rel = "stylesheet" href = "https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
	<!-- JQuery -->
	<script type = "text/javascript" src = "https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<!-- iamport.payment.js -->
	<script type = "text/javascript" src = "https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
	<script src = "https://cdn.jsdelivr.net/npm/moment@2.29.1/min/moment.min.js"></script>
	<script src = "https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
	<style>
		/* 여기에 스타일을 적용해줍니다. */
		body {
			font-family : Arial, sans-serif;
	        background-color : #f8f9fa;
			margin : 0;
			padding : 0;
			display : flex;
			justify-content : center;
			align-items : center;
			min-height : 100vh;
		}
		
		.container {
			width : 60%;
			background-color : #fff;
			padding : 30px;
			border-radius : 10px;
			box-shadow : 0 6px 20px rgba(0, 0, 0, 0.1);
		}
		
		h1 {
			color : #333;
			text-align : center;
			font-size : 26px;
			margin-bottom : 25px;
		}
		
		.reserve-button {
			display : block;
			width : 100%;
			padding : 15px;
			font-size : 18px;
			background-color : #28a745;
			color : #fff;
			border : none;
			border-radius : 5px;
			cursor : pointer;
	        text-align : center;
			margin-top : 30px;
			transition : background-color 0.3s;
		}
		
		.reserve-button:hover {
			background-color : #218838;
		}
	</style>
</head>
<body>
    <h1>${hotelInfo.name} 예약 페이지</h1>
    <p>주소 : ${hotelInfo.address}</p>
    <p>전화번호 : ${hotelInfo.tel}</p>

    <h2>예약 정보</h2>
    <p id = "roomType">객실 유형 : ${roomType}</p>
    <p id = "price">가격 : ${price}원</p>
	
	<!-- 숙박일, 인원 수, 가격 등의 입력 폼 -->
	<div class = "form-group">
			<label for = "dateRange">체크인 ~ 체크아웃 날짜 : </label>
			<input type = "text" id = "dateRange" name = "dateRange" required>
	</div>
	
	<div class = "form-group">
		<label for = "adults">인원 수 : </label>
		<input type = "number" id = "person" name = "person" min = "1" required>
	</div>
	
	<div class = "form-group">
		<label for = "totalPrice">총 가격 : </label>
		<p id = "cost"></p>
	</div>
	
	<div>
        <input type = "hidden" id = "name" name = "name" value = "${hotelInfo.name}">
        <input type = "hidden" id = "roomType" name = "roomType" value = "${roomType}">
        <input type = "hidden" id = "price" name = "price" value = "${price}">
        <button type = "button" class = "reserve_button" onclick = "requestPay()">결제하기</button>
    </div>
	
	<script>
		var IMP = window.IMP;
		IMP.init("imp76885677");
		
		var name = document.getElementById("name").value;
		var type = document.getElementById("roomType").value;
		var product = name.concat(', ', type);
		var date_range = document.getElementById("dateRange").value;
		var person_count = document.getElementById("person").value;
		var totalPrice = 0;
		//var cost = document.getElementById("price").value;
		//var price = Number(cost.replace(",", ""));
		
		// Date Range Picker 초기화
		$(function() {
			$('#dateRange').daterangepicker({
				locale : {
					format : 'YYYY-MM-DD',
					separator : ' ~ ',
					applyLabel : '적용',
					cancelLabel : '취소',
					daysOfWeek : ['일', '월', '화', '수', '목', '금', '토'],
					monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
					firstDay : 0
				},
				minDate : moment().format('YYYY-MM-DD'),
				maxSpan : {
					days : 3
				}
			}, function(start, end, label) {
				const diffDays = end.diff(start, 'days') - 1; // 숙박 일수를 체크아웃 포함하지 않도록 -1
				if(diffDays > 2) {
					$('#dateError').text('체크아웃 날짜는 체크인 날짜로부터 최대 3일 이내여야 합니다.');
				} else {
					$('#dateError').text('');
				}
				
				updateTotalPrice(diffDays + 1); // 수정된 숙박 일수를 넘깁니다.
			});
		});

		// 총 가격 계산 함수
		function updateTotalPrice(nights) {
			var pricePerNight = Number($("#price").text().replace("가격 : ", "").replace(",", "").replace("원", ""));
			totalPrice = nights * pricePerNight;
			
			console.log(totalPrice);
			
			document.getElementById('cost').textContent = totalPrice.toLocaleString() + "원";
		}
			
		function requestPay() { // IMP.request_pay(param, callback) 호출
			IMP.request_pay({ // param
				pg : "kakaopay", // PG사 선택
				pay_method : "card", // 지불 수단
				merchant_uid : "merchant_" + new Date().getTime(), // 가맹점에서 구별할 수 있는 고유한 ID
				name : product, // 상품명
				amount : totalPrice, // 가격
				buyer_email : "test@portone.io", // 구매자 email
				buyer_name : "구매자이름", // 구매자 이름
				buyer_tel : "010-1234-5678", // 구매자 전화번호
				buyer_addr : "서울특별시 강남구 삼성동", // 구매자 주소
				buyer_postcode : "123-456" // 구매자 우편번호
			},
			function(rsp) {
				const dateRange = document.getElementById("dateRange").value; // 숙박 기간
				const date = new Date(rsp.paid_at * 1000);
				const year = date.getFullYear();
				const month = ('0' + (date.getMonth() + 1)).slice(-2);
				const day = ('0' + date.getDate()).slice(-2);
				const dateStr = year + "-" + month + "-" + day; // 결제 날짜
				const person = document.getElementById("person").value + "명"; // 숙박 인원 수
				
				if(rsp.success) {
					var form = document.createElement("form");
						form.setAttribute("method", "POST"); // POST 방식
						form.setAttribute("action", "/payment_success"); // 요청 보낼 주소
					
					var hidden_field = document.createElement("input");
						hidden_field.setAttribute("type", "hidden");
						hidden_field.setAttribute("name", "imp_uid");
						hidden_field.setAttribute("value", rsp.imp_uid);
						
					form.appendChild(hidden_field);
					
					var hidden_field = document.createElement("input");
						hidden_field.setAttribute("type", "hidden");
						hidden_field.setAttribute("name", "product_name");
						hidden_field.setAttribute("value", rsp.name);
															
					form.appendChild(hidden_field);
											
					var hidden_field = document.createElement("input");
						hidden_field.setAttribute("type", "hidden");
						hidden_field.setAttribute("name", "cost");
						hidden_field.setAttribute("value", rsp.paid_amount);
																							
					form.appendChild(hidden_field);
											
					var hidden_field = document.createElement("input");
						hidden_field.setAttribute("type", "hidden");
						hidden_field.setAttribute("name", "email");
						hidden_field.setAttribute("value", rsp.buyer_email);
																							
					form.appendChild(hidden_field);
											
					var hidden_field = document.createElement("input");
						hidden_field.setAttribute("type", "hidden");
						hidden_field.setAttribute("name", "name");
						hidden_field.setAttribute("value", rsp.buyer_name);
																							
					form.appendChild(hidden_field);
											
					var hidden_field = document.createElement("input");
						hidden_field.setAttribute("type", "hidden");
						hidden_field.setAttribute("name", "tel");
						hidden_field.setAttribute("value", rsp.buyer_tel);
																							
					form.appendChild(hidden_field);
											
					var hidden_field = document.createElement("input");
						hidden_field.setAttribute("type", "hidden");
						hidden_field.setAttribute("name", "address");
						hidden_field.setAttribute("value", rsp.buyer_addr);
																							
					form.appendChild(hidden_field);
					
					var hidden_field = document.createElement("input");
						hidden_field.setAttribute("type", "hidden");
						hidden_field.setAttribute("name", "dateRange");
						hidden_field.setAttribute("value", dateRange);
																												
					form.appendChild(hidden_field);
					
					var hidden_field = document.createElement("input");
						hidden_field.setAttribute("type", "hidden");
						hidden_field.setAttribute("name", "dateStr");
						hidden_field.setAttribute("value", dateStr);
																												
					form.appendChild(hidden_field);
					
					var hidden_field = document.createElement("input");
						hidden_field.setAttribute("type", "hidden");
						hidden_field.setAttribute("name", "person");
						hidden_field.setAttribute("value", person);
																																	
					form.appendChild(hidden_field);
											
					document.body.appendChild(form);
											
					form.submit();
				}
			});
		}
	</script>
</body>
</html>
