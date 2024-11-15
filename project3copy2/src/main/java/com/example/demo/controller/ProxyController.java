package com.example.demo.controller;

import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.MediaType;
@RestController
public class ProxyController {

	@GetMapping("/proxy/css")
	public ResponseEntity<byte[]> getCssFile() {
	    RestTemplate restTemplate = new RestTemplate();
	    String url = "https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css";
	    
	    try {
	        ResponseEntity<byte[]> response = restTemplate.getForEntity(url, byte[].class);
	        HttpHeaders headers = new HttpHeaders();
	        headers.setContentType(new MediaType("text", "css"));
	        headers.add("Access-Control-Allow-Origin", "*"); // 모든 출처 허용

	        
	        return new ResponseEntity<>(response.getBody(), headers, HttpStatus.OK);
	    } catch (RestClientException e) {
	        e.printStackTrace();
	        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR); // 오류 발생 시 500 반환
	    }
	}
}
