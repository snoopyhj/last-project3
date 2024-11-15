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
	        return ResponseEntity.ok(0L); // 세션이 없는 경우
	    }

	    long currentTime = System.currentTimeMillis();
	    Long sessionExpiryTime = (Long) session.getAttribute("sessionExpiryTime");

	    if (sessionExpiryTime == null) {
	        int maxInactiveInterval = session.getMaxInactiveInterval(); // 초 단위
	        sessionExpiryTime = currentTime + (maxInactiveInterval * 1000L);
	        session.setAttribute("sessionExpiryTime", sessionExpiryTime);
	    }

	    Boolean paymentInProgress = (Boolean) session.getAttribute("paymentInProgress");
	    Long lastSyncTime = (Long) session.getAttribute("lastSyncTime");

	    if (Boolean.TRUE.equals(paymentInProgress)) {
	        // 결제 중일 경우 타이머 멈춤
	        System.out.println("Payment in progress. Server timer halted.");
	        return ResponseEntity.ok(sessionExpiryTime - currentTime);
	    }

	    if (lastSyncTime != null && !Boolean.TRUE.equals(paymentInProgress)) {
	        long elapsed = currentTime - lastSyncTime;
	        sessionExpiryTime -= elapsed; // 결제 취소 후 흐른 시간 보정
	        session.setAttribute("sessionExpiryTime", sessionExpiryTime);
	        session.setAttribute("lastSyncTime", null); // 동기화 재설정
	        System.out.println("Adjusted session expiry: " + sessionExpiryTime);
	    }

	    long timeLeft = sessionExpiryTime - currentTime;
	    if (timeLeft <= 0) {
	        session.invalidate();
	        return ResponseEntity.ok(0L);
	    }

	    session.setAttribute("lastSyncTime", currentTime);
	    session.setAttribute("sessionExpiryTime", sessionExpiryTime);
	    return ResponseEntity.ok(Math.max(timeLeft, 0L));
	}



	@PostMapping("/api/set-payment-status")
	public ResponseEntity<Void> setPaymentStatus(@RequestBody Map<String, Boolean> payload, HttpServletRequest request) {
	    HttpSession session = request.getSession(false);
	    if (session != null) {
	        Boolean paymentInProgress = payload.get("paymentInProgress");
	        session.setAttribute("paymentInProgress", paymentInProgress);
	        if (!paymentInProgress) {
	            session.setAttribute("lastSyncTime", System.currentTimeMillis());
	        }
	        System.out.println("Payment status updated: " + paymentInProgress);
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

}

