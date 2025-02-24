package com.example.demo.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.service.ReviewService;

@Controller
public class ReviewController {
	@Autowired
	private ReviewService service;
	
	@ResponseBody
    @PostMapping("/reportReview")
    public Map<String, Object> reportReview(@RequestParam("review_id") Integer review_id) {
        service.reportReview(review_id);
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        return response;
    }

}
