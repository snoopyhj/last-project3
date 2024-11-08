<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>숙소 예약 페이지</title>

    <!-- jQuery와 Daterangepicker 라이브러리 -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/moment@2.29.1/min/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />

    <!-- Iamport 결제 API -->
    <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>

    <style>
        /* 스타일 적용 */
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
    <div class="container">
        <h1>숙소 예약하기</h1>
        <form action="reservation-confirmation.jsp" method="post">
            <!-- 동적으로 이미지 경로를 받아서 표시 -->
            <img src="${param.imagePath}" alt="숙소 이미지" style="max-width:100%; border-radius: 10px;">

            <!-- 숙박일, 인원 수, 가격 등의 입력 폼 -->
            <div class="form-group">
                <label for="dateRange">체크인 ~ 체크아웃 날짜:</label>
                <input type="text" id="dateRange" name="dateRange" required>
            </div>

            <div class="form-group">
                <label for="adults">인원 수:</label>
                <input type="number" id="adults" name="adults" min="1" required>
            </div>

            <div class="form-group">
                <label for="price">1박 가격:</label>
                <p id="price">${param.price}원</p>
            </div>

            <div class="form-group">
                <label for="totalPrice">총 가격:</label>
                <p id="totalPrice">${param.price}원</p>
            </div>

            <input type="hidden" id="name" value="${param.name}">
            <input type="hidden" id="roomType" value="${param.roomType}">
        </form>
        
        <!-- 결제하기 버튼 -->
        <button type="button" class="reserve-button" onclick="requestPay()">결제하기</button>
    </div>

    <script>
        $(document).ready(function() {
            // Date Range Picker 초기화
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
            }, function(start, end, label) {
                const diffDays = end.diff(start, 'days') - 1; // 숙박 일수를 체크아웃 포함하지 않도록 -1
                if (diffDays > 2) {
                    $('#dateError').text('체크아웃 날짜는 체크인 날짜로부터 최대 3일 이내여야 합니다.');
                } else {
                    $('#dateError').text('');
                }
                updateTotalPrice(diffDays + 1); // 수정된 숙박 일수를 넘깁니다.
            });
        });

        // 총 가격 계산 함수
        function updateTotalPrice(nights) {
            const pricePerNight = Number(document.getElementById('price').textContent.replace(",", "").replace("원", ""));
            const totalPrice = nights * pricePerNight;
            document.getElementById('totalPrice').textContent = totalPrice.toLocaleString() + "원";
        }

        // 결제 처리 함수
        function requestPay() {
            const price = Number(document.getElementById('totalPrice').textContent.replace(",", "").replace("원", ""));
            const name = document.getElementById('name').value;
            const roomType = document.getElementById('roomType').value;
            const product = name + ', ' + roomType; // 상품명: 이름 + 방 종류

            // Iamport 결제 API 초기화
            var IMP = window.IMP;
            IMP.init("imp76885677"); // 본인 Iamport API 키 사용

            // 결제 요청
            IMP.request_pay({
                pg: "kakaopay", // 결제 수단: 카카오페이
                pay_method: "card", // 카드 결제
                merchant_uid: "merchant_" + new Date().getTime(), // 고유한 ID
                name: product, // 상품명
                amount: price // 결제 금액
            }, function(rsp) {
                if (rsp.success) {
                    $.ajax({
                        url: "/reservation_clear", // 결제 완료 후 호출할 URL
                        method: "POST",
                        headers: {"Content-Type": "application/json"},
                        data: JSON.stringify({imp_uid: rsp.imp_uid}) // 결제 고유 ID 전송
                    }).done(function() {
                        alert("결제가 완료되었습니다.");
                    });
                } else {
                    alert("결제에 실패하였습니다. 다시 시도해주세요.");
                }
            });
        }
    </script>
</body>
</html>
