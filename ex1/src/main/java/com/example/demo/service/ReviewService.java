package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.ReviewMapper;
import com.example.demo.model.Review;
@Service
public class ReviewService {
	@Autowired
	private ReviewMapper mapper;
	
	public List<Review> getReview(Long isbn){
		return this.mapper.getReview(isbn);
	}
	 public boolean reportReview(Integer reviewId) {
		 mapper.increaseReportCount(reviewId); // 신고 횟수 증가
		 mapper.deleteReportedReviews(); // 신고 10개 이상 리뷰 삭제
	        return true;
	    }
}
