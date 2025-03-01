package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Review;
import com.example.demo.model.StartEnd;

@Mapper
public interface ReviewMapper {
   List<Review> getReview(Long isbn);
   void increaseReportCount(Integer review_id);
   void deleteReportedReviews();
   Integer getTotal();
   List<Review> ReviewList(StartEnd st);
   void writeReview(Review review);
   Integer getMaxReview();
}
