<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>세션 만료</title>
</head>
<body>
	<p>Hotel Name: ${hotelName}</p>

    <h1>세션이 만료되었습니다</h1>
    <p>결제 시간이 초과되었습니다. 다시 결제를 시도해 주세요.</p>
    <a href="/regionsearch5?default_num=${fn:escapeXml(hotelName)}">호텔 상세 페이지로 돌아가기</a>
	<script>
		document.addEventListener('DOMContentLoaded', () => {
			await invalidateSession();
			});
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
		</script>
</body>
</html>
