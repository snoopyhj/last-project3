<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>GPT Chatbot</title>
<style>
.chat-box {
	width: 50%;
	margin: auto;
	border: 1px solid #ccc;
	padding: 10px;
	border-radius: 5px;
	background-color: #f9f9f9;
	overflow-y: auto;
	max-height: 400px;
}

.message {
	margin: 5px 0;
}

.user {
	color: blue;
}

.gpt {
	color: green;
}
</style>
</head>
<body>
	<h1 style="text-align: center;">GPT Chatbot</h1>

	<div class="chat-box" id="chatBox">
    <c:forEach var="msg" items="${chatHistory}">
        <div class="message ${msg.startsWith('You:') ? 'user' : 'gpt'}">
            <p>${msg}</p>
        </div>
    </c:forEach>
</div>

	<form action="sendMessage(event)"
		style="text-align: center; margin-top: 10px;">
		<input type="text" id="userInput" placeholder="Enter your message"
			required>
		<button type="submit">Send</button>
	</form>

	<script>
	document.addEventListener('DOMContentLoaded', () => {
	    console.log('DOM fully loaded and parsed');

	    async function sendMessage(event) {
	        event.preventDefault();  // 폼 새로고침 방지

	        const input = document.getElementById('userInput');
	        const userMessage = input.value.trim();

	        if (!userMessage) {
	            alert('메시지를 입력하세요.');
	            return;
	        }

	        console.log(`User message: ` + userMessage); // 디버깅용 로그

	        // 사용자 메시지를 화면에 추가
	        addMessageToChatBox(`You: ` + userMessage, 'user');
	        
	        // 입력 필드 초기화 (확인용 로그)
	        input.value = '';
	        console.log('Input cleared.');

	        try {
	            const response = await fetch('/chat', {
	                method: 'POST',
	                headers: {
	                    'Content-Type': 'application/x-www-form-urlencoded',
	                },
	                body: new URLSearchParams({ userInput: userMessage }),
	            });

	            if (!response.ok) {
	                throw new Error(`Server Error: ${response.statusText}`);
	            }

	            const chatHistory = await response.json();
	            console.log('Chat history from server:', chatHistory);

	            const latestResponse = chatHistory[chatHistory.length - 1];
	            addMessageToChatBox(latestResponse, 'gpt');
	        } catch (error) {
	            console.error('Error:', error);
	            addMessageToChatBox('GPT: 오류가 발생했습니다.', 'gpt');
	        }
	    }

	    function addMessageToChatBox(content, className) {
	        console.log(`Adding message: ${content} with class: ${className}`);  // 디버깅용 로그

	        const messageElement = document.createElement('div');
	        messageElement.className = `message ${className}`;
	        messageElement.textContent = content;

	        const chatBox = document.getElementById('chatBox');
	        if (!chatBox) {
	            console.error('Error: chatBox element not found!');
	            return;
	        }

	        chatBox.appendChild(messageElement);
	        chatBox.scrollTop = chatBox.scrollHeight;  // 스크롤을 가장 아래로 이동
	    }

	    // 폼 이벤트 리스너 추가
	    const form = document.querySelector('form');
	    form.addEventListener('submit', sendMessage);
	});

    </script>
</body>
</html>
