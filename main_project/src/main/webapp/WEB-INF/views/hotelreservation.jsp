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
				amount : price, // 가격
				buyer_email : "test@portone.io", // 구매자 email
				buyer_name : "구매자이름", // 구매자 이름
				buyer_tel : "010-1234-5678", // 구매자 전화번호
				buyer_addr : "서울특별시 강남구 삼성동", // 구매자 주소
				buyer_postcode : "123-456" // 구매자 우편번호
			},
			function(rsp) {
				console.log(rsp);
				
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
											
					document.body.appendChild(form);
											
					form.submit();
				}
			});
		}
	</script>
</body>
</html>
