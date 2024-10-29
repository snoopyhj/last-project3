package com.example.demo.service;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Service
public class OpenAIService {

	private final String API_KEY = "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";
	private final String API_URL = "https://api.openai.com/v1/chat/completions";
	
	public String getChatResponse(String userMessage) {
		try {
			RestTemplate restTemplate = new RestTemplate();

			HttpHeaders headers = new HttpHeaders();
			headers.setContentType(MediaType.APPLICATION_JSON);
			headers.setBearerAuth(API_KEY);

            String body = String.format("""
                    {
                      "model": "gpt-3.5-turbo",
                      "messages": [
                        {"role": "system", "content": "You are a helpful assistant."},
                        {"role": "assistant", "content": "안녕하세요 코지픽입니다.! 무엇을 도와드릴까요?"},
                        {"role": "user", "content": "%s"}
                      ],
                      "temperature": 0.7
                    }
                    """, userMessage);

			HttpEntity<String> request = new HttpEntity<>(body, headers);
			ResponseEntity<String> response = restTemplate.exchange(API_URL, HttpMethod.POST, request, String.class);

			// JSON 응답 파싱
			ObjectMapper objectMapper = new ObjectMapper();
			JsonNode jsonNode = objectMapper.readTree(response.getBody());

			// choices[0].message.content 값 추출
			String content = jsonNode.path("choices").get(0).path("message").path("content").asText();

			return content;
		} catch (Exception e) {
			e.printStackTrace();
			return "OpenAI API 호출 중 오류가 발생했습니다.";
		}
	}
}