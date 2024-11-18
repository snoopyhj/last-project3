package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpSession;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@RestController
public class SearchController {

    @GetMapping("/searchHistory")
    public List<String> getSearchHistory(@RequestParam String query, HttpSession session) {
        List<String> searchHistory = (List<String>) session.getAttribute("searchHistory");
        if (searchHistory == null) {
            searchHistory = new ArrayList<>();
        }

        return searchHistory.stream()
                .filter(item -> item.toLowerCase().contains(query.toLowerCase()))
                .collect(Collectors.toList());
    }

    @GetMapping("/saveSearch")
    public void saveSearch(@RequestParam String query, HttpSession session) {
        List<String> searchHistory = (List<String>) session.getAttribute("searchHistory");
        if (searchHistory == null) {
            searchHistory = new ArrayList<>();
        }
        if (!searchHistory.contains(query)) {
            searchHistory.add(query);
        }
        session.setAttribute("searchHistory", searchHistory);
    }
}