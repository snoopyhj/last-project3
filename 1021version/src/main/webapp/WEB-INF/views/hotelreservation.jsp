<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix = "c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset = "UTF-8">
    <title>예약 페이지</title>
	<!-- JQuery -->
	<script type = "text/javascript" src = "https://code.jquery.com/jquery-1.12.4.min.js"></script>
	<!-- iamport.payment.js -->
	<script type = "text/javascript" src = "https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
</head>
<body>
    <h1>${hotelInfo.name} 예약 페이지</h1>
    <p>주소 : ${hotelInfo.address}</p>
    <p>전화번호 : ${hotelInfo.tel}</p>

    <h2>예약 정보</h2>
    <p>객실 유형 : ${roomType}</p>
    <p>가격 : ${price}원</p>

    <div>
        <input type = "hidden" id = "name" name = "name" value = "${hotelInfo.name}">
        <input type = "hidden" id = "roomType" name = "roomType" value = "${roomType}">
        <input type = "hidden" id = "price" name = "price" value = "${price}">
        <button onclick = "requestPay()">결제하기</button>
    </div>
	
	<script>
		var IMP = window.IMP;
		IMP.init("imp76885677");
		
		var name = document.getElementById("name").value;
		var type = document.getElementById("roomType").value;
		var product = name.concat(', ', type);
		var cost = document.getElementById("price").value;
		var price = Number(cost.replace(",", ""));
			
		function requestPay() { // IMP.request_pay(param, callback) 호출
			IMP.request_pay({ // param
				pg : "kakaopay", // PG사 선택
				pay_method : "card", // 지불 수단
				merchant_uid : "merchant_" + new Date().getTime(), // 가맹점에서 구별할 수 있는 고유한 ID
				name : product, // 상품명
				amount : price // 가격
				// buyer_email : "test@naver.com",
				// buyer_name : "tester", // 구매자 이름
				// buyer_tel : "010-1234-5678", // 구매자 연락처
				// buyer_addr : ""
			},
			function(rsp) {
				$.ajax({
					url : "/reservation_clear",
					method : "POST",
					headers : {"Content-Type" : "application/json"},
					data : {imp_uid : rsp.imp_uid}
				}).done(function() {
					
				});
			});
		}
	</script>
</body>
</html>
