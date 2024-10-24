<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://js.tosspayments.com/v1/payment-widget"></script>
    <title>숙소 예약 페이지</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />
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
            max-width: 900px;
            width: 100%;
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
        .img-section {
            text-align: center;
            margin-bottom: 20px;
        }
        .img-section img {
            max-width: 100%;
            border-radius: 10px;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        .form-group label {
            font-weight: bold;
        }
        .form-group input {
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .payment {
            margin-top: 25px;
        }
        .payment-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: space-between;
        }
        .payment-buttons button {
            flex: 1 1 45%;
            padding: 12px;
            border: none;
            border-radius: 5px;
            background-color: #f0f0f0;
            color: #333;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .payment-buttons button.active,
        .payment-buttons button:hover {
            background-color: #45a049;
            color: #fff;
        }
        #dateError {
            color: red;
            text-align: center;
            margin-top: -10px;
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
        @media (max-width: 600px) {
            .payment-buttons button {
                flex: 1 1 100%;
            }
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/moment@2.29.1/min/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.min.js"></script>
    <script>
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
            }, function(start, end, label) {
                const diffDays = end.diff(start, 'days');
                if (diffDays > 3) {
                    $('#dateError').text('체크아웃 날짜는 체크인 날짜로부터 최대 3일 이내여야 합니다.');
                } else {
                    $('#dateError').text('');
                }
            });
        });

        $(document).ready(function() {
            $('.payment-buttons button').on('click', function() {
                $('.payment-buttons button').removeClass('active');
                $(this).addClass('active');
            });
        });
    </script>
</head>
<body>
    <div class="container">
        <h1>숙소 예약하기</h1>
        <div class="img-section">
            <img src="${pageContext.request.contextPath}/images/hotel.jpg" alt="숙소 이미지">
        </div>
        <form action="reservation-confirmation.jsp" method="post">
            <div class="form-group">
                <label for="dateRange">체크인 ~ 체크아웃 날짜:</label>
                <input type="text" id="dateRange" name="dateRange" required>
            </div>
            <div id="dateError"></div>
            <div class="form-group">
                <label for="adults">인원 수:</label>
                <input type="number" id="adults" name="adults" min="1" required>
            </div>
        </form>
        <div class="payment">
            <h2>결제 구역</h2>
            <p>결제수단을 선택해주세요</p>
            <div class="payment-buttons">
                <button>카카오페이</button>
                <button>토스페이</button>
                <button>KB Pay</button>
                <button>N Pay</button>
                <button>신용/체크카드</button>
                <button>휴대폰 결제</button>
            </div>
        </div>
        <button class="reserve-button">계산하기</button>
    </div>
</body>
</html>
