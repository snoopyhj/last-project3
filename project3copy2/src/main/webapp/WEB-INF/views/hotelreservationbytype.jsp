<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>예약 페이지</title>
    <!-- JQuery -->
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <!-- iamport.payment.js -->
    <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
</head>
<body>
    <h1>${hotelInfobytpye.name} 예약 페이지</h1>
    <p>주소: ${hotelInfobytpye.address}</p>
    <p>전화번호: ${hotelInfobytpye.tel}</p>

    <h2>예약 정보</h2>
    <p>객실 유형: ${roomType}</p>
    <p>가격: ${price}원</p> 

    <div>
        <input type="hidden" id="name" value="${hotelInfobytpye.name}">
        <input type="hidden" id="roomType" value="${roomType}">
        <input type="hidden" id="price" value="${price}">
        <button onclick="fetchUserInfoAndRequestPay()">결제하기</button>
    </div>
	<p id="session-timer">남은 시간: --초</p>
    <script>
		document.addEventListener('DOMContentLoaded', () => {
				        const sessionTimerElement = document.getElementById('session-timer');
				        if (!sessionTimerElement) {
				            console.error('session-timer 요소를 찾을 수 없습니다.');
				            return;
				        }

						let localTimeLeft = 0;
						let lastSyncedTime = Date.now(); // 마지막 동기화 시점

						function syncSessionWithServer() {
						    fetch('/api/main-session-time-left')
						        .then(response => response.text())
						        .then(serverTimeLeft => {
						            console.log('서버에서 받은 남은 세션 시간(ms):'+serverTimeLeft);
						            const now = Date.now();
						            const timeSinceLastSync = (now - lastSyncedTime) / 1000;

						            // 서버에서 받은 시간 - 클라이언트에서 지난 시간 보정
						            localTimeLeft = Math.max(Math.floor(serverTimeLeft / 1000) - timeSinceLastSync, 0);
						            lastSyncedTime = now;

						            updateTimerDisplay(localTimeLeft);
						        })
						        .catch(error => {
						            console.error("세션 동기화 중 오류:", error);
						        });
						}

						function updateTimerDisplay(secondsLeft) {
						    sessionTimerElement.innerText = '남은 시간:'+Math.floor(secondsLeft)+'초';

						    if (secondsLeft <= 0) {
						        handleSessionExpired();
						    } else {
						        setTimeout(() => {
						            localTimeLeft--;
						            updateTimerDisplay(localTimeLeft);
						        }, 1000);
						    }
						}
						function handleSessionExpired() {
								            
								            alert("세션이 만료되었습니다. 결제를 다시 시도해 주세요.");
								             window.location.href = "/session-expired1?name=${hotelInfobytpye.name}"; // 세션 만료 안내 페이지로 이동
								        }

						syncSessionWithServer(); // 초기 동기화 호출
						setInterval(syncSessionWithServer, syncInterval); // 주기적 동기화
						});
		
        var IMP = window.IMP;
        IMP.init("imp76885677"); // 가맹점 식별코드
		
        function fetchUserInfoAndRequestPay() {
			alert("sdasdasdsad");
            fetch('https://localhost:8443/api/user-info', {
                method: 'GET',
                credentials: 'include'
            })
            .then(response => response.json())
            .then(userInfo => {
                const buyerInfo = {
                    name: document.getElementById("name").value,
                    roomType: document.getElementById("roomType").value,
                    price: Number(document.getElementById("price").value.replace(",", "")),
                    buyer_name: userInfo.username,
                    buyer_email: userInfo.mail,
                    buyer_tel: userInfo.tel,
                    buyer_addr: userInfo.address,
                    buyer_postcode: "123-456" // 기본값 설정 가능
                };
				alert(userInfo.username);

                requestPay(buyerInfo);
            })
            .catch(error => {
                console.error('Error fetching user info:', error);
                alert("사용자 정보를 가져오는 중 오류가 발생했습니다. 다시 시도해주세요.");
            });
        }

        function requestPay(buyerInfo) {
            const product = [buyerInfo.name, buyerInfo.roomType].filter(Boolean).join(", ");
			alert(buyerInfo.buyer_email);
			alert(buyerInfo.buyer_addr);
            IMP.request_pay({
                pg: "kakaopay",
                pay_method: "card",
                merchant_uid: "merchant_" + new Date().getTime(),
                name: product,
                amount: buyerInfo.price,
                buyer_email: buyerInfo.buyer_email,
                buyer_name: buyerInfo.buyer_name,
                buyer_tel: buyerInfo.buyer_tel,
                buyer_addr: buyerInfo.buyer_addr,
                buyer_postcode: buyerInfo.buyer_postcode
            }, function(rsp) {
                if (rsp.success) {
                    submitPaymentData(rsp);
                } else {
                    alert("결제가 실패했습니다. 다시 시도해주세요.");
                }
            });
        }

        function submitPaymentData(rsp) {
            $.ajax({
                url: "/reservation_clear",
                method: "POST",
                headers: { "Content-Type": "application/json" },
                data: JSON.stringify({
                    imp_uid: rsp.imp_uid,
                    product_name: rsp.name,
                    cost: rsp.paid_amount,
                    email: rsp.buyer_email,
                    name: rsp.buyer_name,
                    tel: rsp.buyer_tel,
                    address: rsp.buyer_addr
                }),
                success: function() {
                    alert("결제가 성공적으로 완료되었습니다.");
					submitPaymentData(rsp);
                },
                error: function(xhr, status, error) {
                    console.error("Error during payment submission:", error);
                    alert("결제 정보 전송 중 오류가 발생했습니다.");
                }
            });
        }
		function submitPaymentData(rsp) {
		    $.ajax({
		        url: "/reservation_clear",
		        method: "POST",
		        headers: { "Content-Type": "application/json" },
		        data: JSON.stringify({
		            imp_uid: rsp.imp_uid,
		            product_name: rsp.name,
		            cost: rsp.paid_amount,
		            email: rsp.buyer_email,
		            name: rsp.buyer_name,
		            tel: rsp.buyer_tel,
		            address: rsp.buyer_addr
		        }),
		        success: function() {
		            alert("결제가 성공적으로 완료되었습니다.");
		            
		            // POST 요청으로 payment_success 경로로 이동하기 위해 Form 생성
		            const form = document.createElement("form");
		            form.method = "POST";
		            form.action = "/payment_success";
					alert(rsp.name)
		            // 필요한 데이터 필드를 각각 폼에 추가
		            const fields = [
		                { name: "imp_uid", value: rsp.imp_uid },
		                { name: "product_name", value: rsp.name },
		                { name: "cost", value: rsp.paid_amount },
		                { name: "email", value: rsp.buyer_email },
		                { name: "name", value: rsp.buyer_name },
		                { name: "tel", value: rsp.buyer_tel },
		                { name: "address", value: rsp.buyer_addr }
		            ];

		            fields.forEach(field => {
		                const input = document.createElement("input");
		                input.type = "hidden";
		                input.name = field.name;
		                input.value = field.value;
		                form.appendChild(input);
		            });

		            // 폼을 DOM에 추가하고 제출하여 POST 요청 전송
		            document.body.appendChild(form);
		            form.submit();
		        },
		        error: function(xhr, status, error) {
		            console.error("Error during payment submission:", error);
		            alert("결제 정보 전송 중 오류가 발생했습니다.");
		        }
		    });
		}
    </script>
</body>
</html>
	


