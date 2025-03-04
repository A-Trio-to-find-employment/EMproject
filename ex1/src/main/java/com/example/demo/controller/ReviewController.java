package com.example.demo.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.Review;
import com.example.demo.service.GoodsService;
import com.example.demo.service.LoginService;
import com.example.demo.service.ReviewService;

import jakarta.servlet.http.HttpSession;


@Controller
public class ReviewController {
	@Autowired
	private ReviewService service;
	@Autowired
	private LoginService loginService;
	@Autowired
	private GoodsService goodsService;
	@ResponseBody
    @PostMapping("/reportReview")
    public Map<String, Object> reportReview(@RequestParam("review_id") Integer review_id) {
        service.reportReview(review_id);
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        return response;
    }
	
	@PostMapping("review/writeReview")
	public ModelAndView writeReviewPost(Long ISBN, Review review, HttpSession session) {
		ModelAndView mav = new ModelAndView("index");
		review.setUser_id((String)session.getAttribute("loginUser"));
		this.service.writeReview(review);
		Long isbn = review.getIsbn();
		String title = this.goodsService.getGoodsTitle(isbn);
		mav.addObject("book",title);
		mav.addObject("BODY","writeReviewComplete.jsp");
		return mav;
	}
	
	
	@GetMapping("review/writeReview")
	public ModelAndView writeReview(Long ISBN, HttpSession session) {
		ModelAndView mav = new ModelAndView("index");
		String id = (String)session.getAttribute("loginUser");  
		if (id == null) {
		    mav.addObject("error", "로그인이 필요합니다.");
		    mav.setViewName("redirect:/login");  
		    return mav;
		}
		Long isbn = ISBN;
		Book book = this.goodsService.getGoodsDetail(isbn);
		Review review = new Review();
		review.setUser_id(id);
		System.out.println("user:["+id+"]");
		review.setIsbn(isbn);
		mav.addObject(review);
		mav.addObject("book",book);
		mav.addObject("BODY","writeReview.jsp");
		return mav;
	}
//	@GetMapping("/review/getReview")
//	public String getMethodName(@RequestParam String param) {
//		return new String();
//	}
	
}
