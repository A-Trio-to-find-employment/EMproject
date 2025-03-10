package com.example.demo.model;

import java.util.List;

import org.hibernate.validator.constraints.Range;
import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.constraints.Digits;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Book {
	@NotEmpty(message = "저자를 기입하세요.")
	private String authors;
	@NotEmpty(message = "ISBN의 중복 검사가 필요합니다.")
	private String isbnChecked;
	@NotNull(message = "ISBN을 입력하세요.")
	@Digits(integer = 13, fraction = 0, message = "ISBN은 13자리 정수여야 합니다.")
	@Min(value = 1000000000000L, message = "ISBN은 13자리여야 합니다.")
	private Long isbn;
	@NotEmpty(message = "책의 이름을 기입하세요.")
	private String book_title;
	@NotEmpty(message = "출판사를 기입하세요.")
	private String publisher;
	@NotNull(message = "가격을 기입하세요.")
	@Range(min=1,max=1000000,message = "{min}과 {max}사이로 입력하세요.")
	private Integer price;
	private Integer total_rating;
	@NotNull(message = "재고를 넣어주세요.")
	@Range(min = 1,max = 100000,message = "{min}과{max}사이로 넣어주세요.")
	private Integer stock;
	@NotEmpty(message = "발행일을 기입하세요.")
	private String pub_date;
	private String reg_date;
	
	private String cat_id;
	
	private Integer amount;
	private String image_name;
	private MultipartFile coverImage;
	private List<String> categoryPath;
	private boolean isLiked;
	private Integer likecount;
//	public String getAuthors() {
//        return authors;
//    }
//
//    public void setAuthors(String authors) {
//        this.authors = authors;
//    }
	
}
