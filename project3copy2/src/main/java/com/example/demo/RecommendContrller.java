package com.example.demo;

import java.util.List;
import org.springframework.ui.Model;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import com.example.demo.dao.RecommendDAO;
import com.example.demo.vo.RecommendVO;

@Controller
public class RecommendContrller {

    @Autowired
    private RecommendDAO recommendDAO;

    @GetMapping("/recommend")
    public String showRecommendedHotels(Model model) {
        List<RecommendVO> hotels = recommendDAO.recommends();
        model.addAttribute("hotels", hotels);
        return "main";
    }
}
