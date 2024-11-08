	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
	
	<!DOCTYPE html>
	<html>
	<head>
	    <meta charset="UTF-8">
		<title>숙소 예약 페이지</title>
			<link rel = "stylesheet" href = "https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
	
	    <!-- JQuery -->
	    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	    <!-- iamport.payment.js -->
	    <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
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
	    <p>주소: ${hotelInfo.address}</p>
	    <p>전화번호: ${hotelInfo.tel}</p>
	
	    <h2>예약 정보</h2>
	    <p>객실 유형: ${roomType}</p>
	    <p>가격: ${price}원</p> 
		<div class = "form-group">
					<label for = "dateRange">체크인 ~ 체크아웃 날짜 : </label>
					<input type = "text" id = "dateRange" name = "dateRange" required>
			</div>
			<div class = "form-group">
					<label for = "adults">인원 수 : </label>
					<input type = "number" id = "person" name = "person" min = "1" required>
				</div>
	    <div>
	        <input type="hidden" id="name" value="${hotelInfo.name}">
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
									             window.location.href = "/session-expired?name=${hotelInfo.name}"; // 세션 만료 안내 페이지로 이동
									        }
	
							syncSessionWithServer(); // 초기 동기화 호출
							setInterval(syncSessionWithServer, syncInterval); // 주기적 동기화
							});
			
	        var IMP = window.IMP;
	        IMP.init("imp76885677"); // 가맹점 식별코드
			var name = document.getElementById("name").value;
					var type = document.getElementById("roomType").value;
					var product = name.concat(', ', type);
					var date_range = document.getElementById("dateRange").value;
					var person_count = document.getElementById("person").value;
					var totalPrice = 0;
					$(function() {
					    $('#dateRange').daterangepicker({
					        locale: {
					            format: 'YYYY-MM-DD',
					            separator: ' ~ ',
					            applyLabel: '적용',
					            cancelLabel: '취소',
					            daysOfWeek: ['일', '월', '화', '수', '목', '금', '토'],
					            monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
					            firstDay: 0
					        },
					        minDate: moment().format('YYYY-MM-DD'),
					        maxSpan: {
					            days: 3
					        }
					    }).on('apply.daterangepicker', function(ev, picker) {
					        const start = picker.startDate;
					        const end = picker.endDate;
					        const diffDays = end.diff(start, 'days');
					        
					        // 날짜가 설정된 후 총 가격 업데이트
					        if (diffDays > 2) {
					            $('#dateError').text('체크아웃 날짜는 체크인 날짜로부터 최대 3일 이내여야 합니다.');
					        } else {
					            $('#dateError').text('');
					            updateTotalPrice(diffDays + 1); // 숙박 일수 반영
					        }
					    });
					});

							function updateTotalPrice(nights) {
										var pricePerNight = Number($("#price").text().replace("가격 : ", "").replace(",", "").replace("원", ""));
										totalPrice = nights * pricePerNight;
										
										console.log(totalPrice);
										
										document.getElementById('cost').textContent = totalPrice.toLocaleString() + "원";
									}
	        function fetchUserInfoAndRequestPay() {
				
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
					const dateRange = document.getElementById("dateRange").value; // 숙박 기간
									const date = new Date(rsp.paid_at * 1000);
									const year = date.getFullYear();
									const month = ('0' + (date.getMonth() + 1)).slice(-2);
									const day = ('0' + date.getDate()).slice(-2);
									const dateStr = year + "-" + month + "-" + day; // 결제 날짜
									const person = document.getElementById("person").value + "명"; // 숙박 인원 수
	                if (rsp.success) {
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
	                } else {
	                    alert("결제가 실패했습니다. 다시 시도해주세요.");
	                }
	            });
	        }
	
	        
	    </script>
	</body>
	</html>
		
	
	
