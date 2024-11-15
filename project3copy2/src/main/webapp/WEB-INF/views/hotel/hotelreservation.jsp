<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>숙소 예약 페이지</title>
	<link rel="stylesheet" href="/css/daterangepicker.css" />	

    

    <!-- JQuery -->
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <!-- iamport.payment.js -->
    <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/moment@2.29.1/min/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .container {
            width: 60%;
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

        h1 {
            color: #333;
            text-align: center;
            font-size: 26px;
            margin-bottom: 25px;
        }

        .reserve-button {
            display: block;
            width: 100%;
            padding: 15px;
            font-size: 18px;
            background-color: #28a745;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
            margin-top: 30px;
            transition: background-color 0.3s;
        }

        .reserve-button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

    <h1>${hotelInfo.name} 예약 페이지</h1>
    <p>주소: ${hotelInfo.address}</p>
    <p>전화번호: ${hotelInfo.tel}</p>

    <h2>예약 정보</h2>
    <p>객실 유형: ${RoomType}</p>
    <p>가격: ${Price}원</p> 
	
    <div class="form-group">
        <label for="dateRange">체크인 ~ 체크아웃 날짜 : </label>
        <input type="text" id="dateRange" name="dateRange" required>
    </div>
    <div class="form-group">
        <label for="adults">인원 수 : </label>
        <input type="number" id="person" name="person" min="1" required>
    </div>
    <div>
        <input type="hidden" id="name" value="${hotelname}">
        <input type="hidden" id="roomType" value="${roomType}">
        <input type="hidden" id="price" value="${price}">
		<input type="hidden" name="signature" value="${signature}">
		
        <button onclick="fetchUserInfoAndRequestPay()" class="reserve-button">결제하기</button>
    </div>
    <p id="session-timer">남은 시간: --초</p>

    <script>
		const sessionTimerElement = document.getElementById('session-timer');
		document.addEventListener('DOMContentLoaded', () => {
		    
		    if (!sessionTimerElement) {
		        console.error('session-timer 요소를 찾을 수 없습니다.');
		        return;
		    }

		    

		    syncSessionWithServer(); // 페이지 로드 시 즉시 서버 동기화
		    startSyncTimer();        // 동기화 타이머 시작
		    startLocalTimer(); // 로컬 타이머 시작
		});

		let localTimeLeft = 0;
				    let lastSyncedTime = Date.now();
					let syncInterval; // 서버 동기화 Interval 변수
					let timerInterval; // 로컬 타이머 Interval 변수

					function syncSessionWithServer() {
					    return fetch('/api/main-session-time-left')
					        .then(response => response.text())
					        .then(serverTimeLeft => {
					            const serverTimeInSeconds = Math.floor(serverTimeLeft / 1000);
					            console.log('서버에서 받은 남은 세션 시간(ms): ' + serverTimeLeft);

					            // 최신 서버 시간을 로컬 타이머에 즉시 반영
					            localTimeLeft = serverTimeInSeconds;
					            lastSyncedTime = Date.now(); // 동기화 시점을 갱신

					            updateTimerDisplay(localTimeLeft);
					        })
					        .catch(error => {
					            console.error("세션 동기화 중 오류:", error);
					        });
					}



				    function updateTimerDisplay(secondsLeft) {
				        sessionTimerElement.innerText = '남은 시간: ' + Math.max(0, secondsLeft) + '초';

				        if (secondsLeft <= 0) {
				            handleSessionExpired();
				        }
				    }
					function startSyncTimer() {
					    if (!syncInterval) {  // 중복 방지를 위해 체크
					        syncInterval = setInterval(syncSessionWithServer, 10000); // 10초마다 동기화
					    }
					}

					function startLocalTimer() {
					    if (!timerInterval) {  // 중복 방지
					        timerInterval = setInterval(() => {
					            const now = Date.now();
					            const elapsedSeconds = Math.floor((now - lastSyncedTime) / 1000);
					            const newTimeLeft = localTimeLeft - elapsedSeconds;

					            updateTimerDisplay(newTimeLeft);

					            if (newTimeLeft <= 0) {
					                handleSessionExpired();
					            }
					        }, 1000);
					    }
					}

				    function handleSessionExpired() {
				        alert("세션이 만료되었습니다. 결제를 다시 시도해 주세요.");
				        window.location.href = "/session-expired?name=${hotelInfo.default_num}";
				    }
					function stopLocalTimer() {
					    if (timerInterval) {
					        clearInterval(timerInterval);
					        timerInterval = null; // 초기화하여 재시작 방지
					    }
					}
					function stopSyncTimer() {
					    if (syncInterval) {
					        clearInterval(syncInterval); // 동기화 타이머 중지
					        syncInterval = null; // 타이머 변수를 초기화하여 중복 방지
					    }
					}




        var IMP = window.IMP;
        IMP.init("imp76885677"); // 가맹점 식별코드

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
                maxSpan: { days: 3 }
            });
        });
		
		function setPaymentStatus(isInProgress) {
		    return fetch('/api/set-payment-status', {
		        method: 'POST',
		        headers: { 'Content-Type': 'application/json' },
				credentials: 'include',
		        body: JSON.stringify({ paymentInProgress: isInProgress })
		    })
		    .then(response => {
		        if (!response.ok) {
		            console.error("Failed to set payment status on the server");
		        }
		        return response;
		    })
		    .catch(error => {
		        console.error("Error setting payment status:", error);
		    });
		}

        function fetchUserInfoAndRequestPay() {
			stopLocalTimer();  // 로컬 타이머 중단
			    stopSyncTimer();   // 서버 타이머 동기화 중단

			    setPaymentStatus(true) // 서버에 결제 상태 설정 요청
			        .then(() => {
			            console.log("Payment status set to true."); 
			            return fetchUserInfo();  // 사용자 정보 가져오기
			        })
			        
                .then(userInfo => {
                    const buyerInfo = {
                        name: document.getElementById("name").value,
                        roomType: document.getElementById("roomType").value,
                        price: Number(document.getElementById("price").value.replace(",", "")),
                        buyer_name: userInfo.username,
                        buyer_email: userInfo.mail,
                        buyer_tel: userInfo.tel,
                        buyer_addr: userInfo.address,
                        buyer_postcode: "123-456"
                    };

                    requestPay(buyerInfo);
                })
                .catch(error => {
                    console.error('Error fetching user info:', error);
                    alert("사용자 정보를 가져오는 중 오류가 발생했습니다. 다시 시도해주세요.");
					resyncAndRestartTimers(); // 타이머 재개
                });
        }

        function fetchUserInfo() {
            return fetch('https://localhost:8443/api/user-info', {
                method: 'GET',
                credentials: 'include'
            })
            .then(response => {
                if (response.status === 401) {
                    console.log("엑세스 토큰 만료 - 리프레시 토큰으로 재발급 요청");
                    return refreshAccessToken().then(() => {
                        return fetch('https://localhost:8443/api/user-info', {
                            method: 'GET',
                            credentials: 'include'
                        });
                    });
                }
                return response;
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('사용자 정보를 가져오는 데 실패했습니다.');
                }
                return response.json();
            });
        }

        function refreshAccessToken() {
            return fetch('https://localhost:8443/refresh-token', {
                method: 'POST',
                credentials: 'include'
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('리프레시 토큰이 유효하지 않거나 만료되었습니다.');
                }
                console.log("새로운 엑세스 토큰이 쿠키에 저장되었습니다.");
            })
            .catch(error => {
                console.error('액세스 토큰 재발급 실패:', error);
                alert('세션이 만료되었습니다. 다시 로그인해 주세요.');
                window.location.href = 'https://localhost:8443/login';
            });
        }

        function requestPay(buyerInfo) {
            const product = [buyerInfo.name, buyerInfo.roomType].filter(Boolean).join(", ");
			
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
                    var form = document.createElement("form");
                    form.setAttribute("method", "POST");
                    form.setAttribute("action", "/payment_success");

                    form.appendChild(createHiddenInput("imp_uid", rsp.imp_uid));
                    form.appendChild(createHiddenInput("product_name", rsp.name));
                    form.appendChild(createHiddenInput("cost", rsp.paid_amount));
                    form.appendChild(createHiddenInput("email", rsp.buyer_email));
                    form.appendChild(createHiddenInput("name", rsp.buyer_name));
                    form.appendChild(createHiddenInput("tel", rsp.buyer_tel));
                    form.appendChild(createHiddenInput("address", rsp.buyer_addr));
					const dateRange = document.getElementById("dateRange").value;
					const dateStr = moment().format("YYYY-MM-DD"); // 현재 날짜를 dateStr로 설정 (필요에 따라 수정 가능)
					const person = document.getElementById("person").value; // 인원 수 추가
					const signature = document.querySelector('input[name="signature"]').value; // 서명 값 가져오기
					form.appendChild(createHiddenInput("dateRange", dateRange));
					form.appendChild(createHiddenInput("dateStr", dateStr)); // 추가된 dateStr 필드
					form.appendChild(createHiddenInput("person", person)); // person 필드 추가
					form.appendChild(createHiddenInput("signature", signature)); // signature 추가
					form.appendChild(createHiddenInput("hotelname", buyerInfo.name)); // signature 추가
					alert("dateRange: " + dateRange + "\ndateStr: " + dateStr + "\nPerson: " + person); // 디버깅용 알림
					
                    document.body.appendChild(form);
                    form.submit();
                } else {
                    alert("결제가 실패했습니다. 다시 시도해주세요.");
					resyncAndRestartTimers(); // 실패 시 타이머 동기화 후 재개
                }
            });
        }

        function createHiddenInput(name, value) {
            var input = document.createElement("input");
            input.setAttribute("type", "hidden");
            input.setAttribute("name", name);
            input.setAttribute("value", value);
            return input;
        }
		function resyncAndRestartTimers() {
				    setPaymentStatus(false) // 결제 플래그 해제
				        .then(() => syncSessionWithServer())
				        .then(() => {
				            startLocalTimer();  // 로컬 타이머 재개
				            startSyncTimer();   // 동기화 타이머 재개
				        });
						}
    </script>
</body>
</html>
