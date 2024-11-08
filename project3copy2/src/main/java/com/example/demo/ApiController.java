package com.example.demo;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@RestController
public class ApiController {

	@GetMapping("/api/main-session-time-left")
	public ResponseEntity<Long> getSessionTimeLeft(HttpServletRequest request) {
	    HttpSession session = request.getSession(false);
	    if (session == null) {
	        return ResponseEntity.ok(0L); // 세션이 없는 경우
	    }

	    // 세션 갱신 (명시적 접근)
	    session.setAttribute("heartbeat", System.currentTimeMillis()); // 갱신용 더미 데이터

	    long currentTime = System.currentTimeMillis();
	    long lastAccessedTime = session.getLastAccessedTime();
	    int maxInactiveInterval = session.getMaxInactiveInterval(); // 초 단위

	    long timeLeft = (lastAccessedTime + (maxInactiveInterval * 1000L)) - currentTime;
	    return ResponseEntity.ok(Math.max(timeLeft, 0)); // 음수 방지
	}
}

