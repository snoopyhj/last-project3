<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>숙소 예약 페이지</title> <link rel="icon" href="/image/메인로고.png" >
   <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/hotel/hotelreservation.css">
    

    <!-- JQuery -->
    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <!-- iamport.payment.js -->
    <script src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/moment@2.29.1/min/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
</head>



<body>
    <div class="header">
        <a href="/" class="logo">cozypick</a>
             <div class="nav">
             </div>
             
          <span id="buyerName1"></span>
    </div>
    

	<input type="hidden" name="signature" value="${signature}">

    <main class="main">
       
        <div class="reservation-container">
            <!-- 예약 정보와 호텔 정보 섹션을 같은 열에 배치 -->
            <div class="reservation-row">
                <section class="reservation-info">
                    <h3>예약 확인 및 결제</h3><br>
                    <form>
                        <div class="form-group">
                            <h4>예약자 정보</h4>
                            <p class="reservation-info-check">* 예약 전 정보가 일치한지 반드시 확인해주세요. *</p><hr>
                        </div>
                        <div class="form-group">
                            <label for="id">예약자 ID: <span id="buyerName"></span></label>
                        </div><br>
                        <div class="form-group">
                            <label for="tel">예약자 email: <span id="buyerEmail"></span></label>
                        </div><br>
                        <div class="form-group">
                            <label for="tel">예약자 전화번호: <span id="buyerTel"></span></label>
                        </div>
                    </form>
                </section>
        
                <section class="hotel-info-container">
                    <h3 id='hotelName'>숙소 이름: ${hotelInfo.name}</h3>
                    <img src="${hotelInfo.img1}" class="hotel-image"><br>
                    <label class="hotel-address">호텔 주소: ${hotelInfo.address}</label><br>
                    <label class="roomtype">선택한 객실: ${RoomType}</label><br>
					<input type="hidden" id="roomType" value="${RoomType}">

                    <label class="price">객실 금액: ${Price}원</label><br>
					<input type="hidden" id="price" value="${Price}">
					<label for="guestCount">인원수: </label>
					<input type="number" id="person" name="person" min="1" max="10" value="1" required><br>
                 <label for="dateRange">체크인 ~ 체크아웃 날짜 : </label>
                 <input type="text" id="dateRange" name="dateRange" required>
                </section>
            </div>
            
            <section class="payment-info-container">
                <h3>결제 정보</h3>
                <label class="payment-method"> 결제수단 : 카카오페이</label><br>
                <label class="payment-price"> 객실 가격 (1박): ${Price}원<br></label><br><hr><br>

                <div class="total-price">
                    <p><strong> 총 결제 금액:</strong> <span> ${Price}원</span></p>
                </div><br>
                <div class ="payment">
                    <button onclick="fetchUserInfoAndRequestPay()" class="btn-pay">결제하기</button>
                </div>
                <p id="session-timer">남은 시간: --초</p>
            </section>
        </div>
    </main>

    <footer>
        <pre>
            Some hotels require cancellation at least 24 hours before check-in.
            © 2024 COZYPICK. All rights reserved.
            Dispute Settlement: Tel: 010-4717-2540 | Email: dica200@paran.com
            COZYPICK Co., Ltd., 171, Jangseungbaegi-ro, Dongjak-gu, Seoul, Republic of Korea
            Company Representative: Hyunwoo Bae
        </pre>
     
    </footer>






    <script>
		const sessionTimerElement = document.getElementById('session-timer');
		document.addEventListener('DOMContentLoaded', () => {
			fetchUserInfo()
			        .then(userInfo => {
			            const buyerNameElement = document.getElementById("buyerName");
			            const buyerEmailElement = document.getElementById("buyerEmail");
			            const buyerTelElement = document.getElementById("buyerTel");
						const buyerNameElement1 = document.getElementById("buyerName1");

			            if (buyerNameElement) {
			                buyerNameElement.textContent = userInfo.username; // userInfo 데이터 반영
							buyerNameElement1.textContent = userInfo.username; // userInfo 데이터 반영
			            }
			            
			            if (buyerEmailElement) {
			               buyerEmailElement.textContent = userInfo.mail;
			            }
			            
			            if (buyerTelElement) {
			               buyerTelElement.textContent = userInfo.tel;
			            }

			            console.log("User info fetched:", userInfo); // 디버깅용 로그
			        })
			        .catch(error => {
			            console.error("Error fetching user info:", error);
			            alert("사용자 정보를 가져오는 중 오류가 발생했습니다. 다시 시도해주세요.");
			        });
			checkSessionStatus();
		    if (!sessionTimerElement) {
		        console.error('session-timer 요소를 찾을 수 없습니다.');
		        return;
		    }
			


		    syncSessionWithServer(); // 페이지 로드 시 즉시 서버 동기화
		    startSyncTimer();        // 동기화 타이머 시작
		    startLocalTimer(); // 로컬 타이머 시작
		});
		window.addEventListener('beforeunload', function(event) {
		    // 세션 무효화 요청
			const beaconSent = navigator.sendBeacon('/api/invalidate-session');
			    if (!beaconSent) {
			        // Beacon 전송 실패 시 대체 요청 처리 (Fallback)
			        fetch('/api/invalidate-session', {
			            method: 'POST',
			            credentials: 'include'
			        });
			    }
		});
		function checkSessionStatus() {
		    fetch('/api/check-session', {
		        method: 'GET',
		        credentials: 'include' // 세션 쿠키 포함
		    })
		    .then(response => {
		        if (!response.ok) {
		            window.location.href = '/session-expired';
		        }
		    })
		    .catch(error => {
		        console.error('세션 확인 중 오류:', error);
		        window.location.href = '/session-expired';
		    });
		}
		async function invalidateSession() {
				    fetch('/api/invalidate-session', {
				        method: 'POST',
				        credentials: 'include', // 세션 쿠키를 포함
				    })
				    .then(response => {
				        if (response.ok) {
				            console.log('세션이 성공적으로 무효화되었습니다.');
				            
				            
				        } else {
				            console.error('세션 무효화 실패:', response.statusText);
				        }
				    })
				    .catch(error => {
				        console.error('세션 무효화 요청 중 오류:', error);
				    });
				}
		let localTimeLeft = 0;
				    let lastSyncedTime = Date.now();
					let syncInterval; // 서버 동기화 Interval 변수
					let timerInterval; // 로컬 타이머 Interval 변수

					function syncSessionWithServer() {
					    const syncStartTime = Date.now(); // 동기화 시작 시점

					    return fetch('/api/main-session-time-left')
					        .then(response => response.text())
					        .then(serverTimeLeft => {
					            const syncEndTime = Date.now(); // 동기화 응답 수신 시점
					            const roundTripTime = syncEndTime - syncStartTime; // 요청-응답 왕복 시간

					            const serverTimeInSeconds = Math.floor(serverTimeLeft / 1000);
					            console.log('서버에서 받은 남은 시간(초):', serverTimeInSeconds);

					            // 보정: 왕복 시간의 절반을 서버의 남은 시간에 추가
					            const correctedTimeLeft = serverTimeInSeconds - Math.floor(roundTripTime / 2000);
					            
					            localTimeLeft = correctedTimeLeft;
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
			const personInput = document.getElementById('person');
						if (!personInput.value || personInput.value < 1 || personInput.value > 50) {
						    alert('인원 수를 입력하고 1 이상 50 이하의 값을 선택하세요.');
						    personInput.focus();
						    return; // 입력값이 유효하지 않으면 결제 진행 중단
						}
			stopLocalTimer();  // 로컬 타이머 중단
			    stopSyncTimer();   // 서버 타이머 동기화 중단

			    setPaymentStatus(true) // 서버에 결제 상태 설정 요청
			        .then(() => {
			            console.log("Payment status set to true."); 
			            return fetchUserInfo();  // 사용자 정보 가져오기
			        })
			        
                .then(userInfo => {
					const hotelNameElement = document.getElementById("hotelName");
					const hotelName = hotelNameElement.textContent.replace("숙소 이름: ", "").trim();
                    const buyerInfo = {
                        name: hotelName,
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
					alert("결제가 성공했습니다.")
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
		    setPaymentStatus(false) // 결제 상태 해제 및 세션 초기화 요청
		        .then(() => syncSessionWithServer())
		        .then(() => {
		            localTimeLeft = Math.max(localTimeLeft, 0); // 보정된 시간으로 재설정
		            startLocalTimer();  
		            startSyncTimer();   
		        });
		}

    </script>
</body>
</html>
