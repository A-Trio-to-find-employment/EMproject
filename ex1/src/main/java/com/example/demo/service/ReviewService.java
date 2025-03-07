package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.ReviewMapper;
import com.example.demo.model.MyReview;
import com.example.demo.model.Review;
import com.example.demo.model.StartEnd;
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
	 public Integer getTotal() {
		 return this.mapper.getTotal();
	 }
	 public List<Review> ReviewList(StartEnd st){
		 return this.mapper.ReviewList(st);
	 }
	 public void writeReview(Review review) {
		 review.setReview_id(getMaxReview()+1);
		 
		 System.out.println("review id : "+review.getReview_id());
		 
		 this.mapper.writeReview(review);
	 }
	 public Integer getMaxReview() {
		 Integer max = this.mapper.getMaxReview();
		 if(max == null) return 0;
		 else return max;
	 }
	 public boolean checkingOrder(String user_id, Long isbn) {
		 int count = this.mapper.checkOrder(user_id, isbn);
		 return count > 0;
	 }
	 public List<MyReview> listReview(Integer pageNo, String user_id){
		 if(pageNo == null) pageNo = 1;
		 int start = (pageNo - 1) *5;
		 int end = start+6;
		 StartEnd se = new StartEnd();
		 se.setStart(start);se.setEnd(end);se.setUser_id(user_id);
		 return this.mapper.listReview(se);
	 }
	 public Integer getTotalMine(String user_id) {
		 return this.mapper.getTotalMine(user_id);
	 }
}
