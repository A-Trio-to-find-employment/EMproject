package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.MyReview;
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
//		if(!this.service.checkingOrder(id, ISBN)) {
//			mav.addObject("error","구매한 도서에만 리뷰작성이 가능합니다.");
//			mav.setViewName("redirect:/booklist.html?ISBN="+ISBN);
//			return mav;
//		}
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
	@ResponseBody
	@GetMapping("/review/checkPurchase")
	public Map<String, Object> checkPurchase(@RequestParam("isbn") Long isbn, HttpSession session){
		Map<String, Object> response = new HashMap<>();
		String id = (String)session.getAttribute("loginUser");
		if (id == null) {
	        response.put("purchased", false);
	        response.put("message", "로그인이 필요합니다.");
	    } else {
	        boolean purchased = this.service.checkingOrder(id, isbn);
	        response.put("purchased", purchased);
	        if (!purchased) {
	            response.put("message", "구매한 도서에만 리뷰 작성이 가능합니다.");
	        }
	    }
	    return response;
	}
	@GetMapping(value = "/listReview")
	public ModelAndView listReview(Integer pageNo, HttpSession session) {
		int currentPage = 1;
		if(pageNo != null)currentPage = pageNo;
		String id = (String)session.getAttribute("loginUser");
		List<MyReview> mineReview = this.service.listReview(pageNo, id);
		ModelAndView mav = new ModelAndView("myArea");
		Integer totalCount  = this.service.getTotalMine(id);
		int pageCount = totalCount / 10;
		if(totalCount % 5 != 0)pageCount++;
		mav.addObject("mine",mineReview);
		mav.addObject("PAGES",pageCount);mav.addObject("currentPage",currentPage);
		mav.addObject("BODY","listReview.jsp");
		return mav;
	}
	@PostMapping(value = "/listReview/delete")
	public ModelAndView deleteReview() {
		ModelAndView mav = new ModelAndView("myArea");
		return mav;
	}
}
