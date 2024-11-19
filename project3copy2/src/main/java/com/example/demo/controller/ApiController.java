package com.example.demo.controller;

import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@RestController
public class ApiController {

	@GetMapping("/api/main-session-time-left")
	public ResponseEntity<Long> getSessionTimeLeft(HttpServletRequest request) {
	    HttpSession session = request.getSession(false);
	    if (session == null) {
	        return ResponseEntity.ok(0L); // No session
	    }

	    long currentTime = System.currentTimeMillis();
	    Long sessionExpiryTime = (Long) session.getAttribute("sessionExpiryTime");
	    if (sessionExpiryTime == null) {
	        int maxInactiveInterval = session.getMaxInactiveInterval(); // 초 단위
	        sessionExpiryTime = currentTime + (maxInactiveInterval * 1000L);
	        session.setAttribute("sessionExpiryTime", sessionExpiryTime);
	    }

	    Boolean paymentInProgress = (Boolean) session.getAttribute("paymentInProgress");
	    if (Boolean.TRUE.equals(paymentInProgress)) {
	        return ResponseEntity.ok(sessionExpiryTime - currentTime);
	    }

	    // 남은 시간 계산
	    long timeLeft = sessionExpiryTime - currentTime;

	    if (timeLeft <= 0) {
	        session.invalidate();
	        return ResponseEntity.ok(0L);
	    }

	    // 남은 시간이 정상적으로 계산되면 lastSyncTime 업데이트
	    session.setAttribute("lastSyncTime", currentTime);

	    return ResponseEntity.ok(Math.max(0L, timeLeft));
	}






	@PostMapping("/api/set-payment-status")
	public ResponseEntity<Void> setPaymentStatus(@RequestBody Map<String, Boolean> payload, HttpServletRequest request) {
	    HttpSession session = request.getSession(false);
	    if (session != null) {
	        Boolean paymentInProgress = payload.get("paymentInProgress");
	        session.setAttribute("paymentInProgress", paymentInProgress);
	        
	        if (!paymentInProgress) {
	            // 세션 타이머 초기화
	            long currentTime = System.currentTimeMillis();
	            int maxInactiveInterval = session.getMaxInactiveInterval(); // 초 단위
	            long newExpiryTime = currentTime + (maxInactiveInterval * 1000L);
	            session.setAttribute("sessionExpiryTime", newExpiryTime);
	            session.setAttribute("lastSyncTime", currentTime);
	        }
	        

	    }
	    return ResponseEntity.ok().build();
	}





	@PostMapping("/api/invalidate-session")
    public ResponseEntity<String> invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // 현재 세션 가져오기
        if (session != null) {
            session.invalidate(); // 세션 무효화
            return ResponseEntity.ok("세션이 성공적으로 무효화되었습니다.");
        } else {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("유효한 세션이 없습니다.");
        }
    }
	@GetMapping("/api/check-session")
	public ResponseEntity<Void> checkSession(HttpSession session) {
	    Boolean sessionActive = (Boolean) session.getAttribute("sessionActive");
	    if (sessionActive == null || !sessionActive) {
	        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
	    }
	    return ResponseEntity.ok().build();
	}


}

