package com.example.demo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.OpenAIService;

import jakarta.servlet.http.HttpSession;

@Controller
public class ChatController {

	private final OpenAIService openAIService;

	// 커스텀 질문과 응답을 저장하는 맵 생성
	private final Map<String, String> customResponses = new HashMap<>();

	public ChatController(OpenAIService openAIService) {
		this.openAIService = openAIService;

		// 자주 묻는 질문과 그에 대한 응답을 미리 정의
		customResponses.put("질문 방법", "결제관련은 1번, 숙박문의는 2번, 기타문의는 3번을 눌러주세요.");
		
		/* 1) 결제문의 */
		customResponses.put("1번", "결제문의를 선택하셨군요! 결제관련 궁금하신 점을 선택해주세요 (환불, 결제수단 중 선택)");
		customResponses.put("환불", "호텔 예약을 취소하고 환불받는 조건은 호텔의 취소 정책에 따라 다릅니다. 자세한 환불 규정은 예약하신 숙소로 직접 문의해보세요");
		customResponses.put("결제수단?", "CozyPick은 현재 카카오페이만 지원하고 있으며, 점차 결제하실 수 있는 수단을 확대해 나갈테니 기대해 주세요 :) ");

		/* 2) 결제문의 */
		customResponses.put("2번", "숙박문의를 선택하셨군요! 숙박관련 궁금하신 점을 선택해주세요. (체크인, 반려동물, 조식 중 선택)");
		customResponses.put("체크인", "대부분의 호텔에서는 체크인 시간이 오후 3시부터이며, 체크아웃 시간은 오전 11시 또는 **정오(12시)**입니다. 그러나 호텔마다 정책이 다를 수 있으므로 예약하신 호텔로 문의바랍니다. ");
		customResponses.put("반려동물", "반려동물 동반 가능 여부는 호텔의 정책에 따라 다릅니다. 일부 호텔은 반려동물 친화적인 서비스를 제공하며, 추가 요금을 부과하는 경우도 있습니다. 숙박 가능한 반려동물의 종류와 크기, 수에 제한이 있을 수 있으니 예약하신 호텔로 문의바랍니다.");
		customResponses.put("조식", "조식 제공 여부는 호텔의 정책과 예약 유형에 따라 다릅니다.  예약하신 호텔로 문의바랍니다.");

		/* 3) 기타문의 */
		customResponses.put("3번", "기타문의를 선택하셨군요! 궁금하신 점을 선택해주세요. (고객센터번호, 코지픽 중 선택)");
		customResponses.put("고객센터번호", "코지픽 고객센터 번호는 없습니다 ^^ 전화하지 마세요.");
		customResponses.put("코지픽", "코지픽 주소는 서울시 동작구 장승배기로171 3층");

	}

	@GetMapping("/")
	public String index(HttpSession session, Model model) {
		List<String> chatHistory = (List<String>) session.getAttribute("chatHistory");
		if (chatHistory == null) {
			chatHistory = new ArrayList<>();
			chatHistory.add("GPT: 안녕하세요 코지픽입니다.! 무엇을 도와드릴까요?");
            session.setAttribute("chatHistory", chatHistory);
		}
		model.addAttribute("chatHistory", chatHistory);

		return "chatbot";
	}

	@PostMapping("/chat")
	@ResponseBody // JSON 형식 응답
	public List<String> chat(@RequestParam("userInput") String userInput, HttpSession session) {
		// 세션에서 chatHistory 가져오기
		List<String> chatHistory = (List<String>) session.getAttribute("chatHistory");
		if (chatHistory == null) {
			chatHistory = new ArrayList<>();
		}
		
		// 1. 커스텀 응답 확인
        if (customResponses.containsKey(userInput)) {
            String customResponse = customResponses.get(userInput);

            // 채팅 기록에 추가
            chatHistory.add("You: " + userInput);
            chatHistory.add("GPT: " + customResponse);

            session.setAttribute("chatHistory", chatHistory);
            return chatHistory;  // 커스텀 응답 반환
        }

     // 2. 커스텀 응답이 아닌 경우 GPT API 호출
        String response = openAIService.getChatResponse(userInput);

        // 사용자와 GPT의 응답을 차례로 저장
        chatHistory.add("You: " + userInput);
        
        String responses = openAIService.getChatResponse(userInput);
        chatHistory.add("GPT: " + responses);

        session.setAttribute("chatHistory", chatHistory);
        return chatHistory;  // 최신 chatHistory 반환
    }
}