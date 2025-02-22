package com.example.demo.model;

import java.util.List;

import org.hibernate.validator.constraints.Range;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Book {
	@NotEmpty(message = "저자를 입력하세요.")
	private String authors;
	@NotEmpty(message = "ISBN의 중복 검사가 필요합니다.")
	private String isbnChecked;
	@NotEmpty(message = "ISBN을 입력하세요.")
	private Long isbn;
	@NotEmpty(message = "책의 이름을 기입하세요.")
	private String book_title;
	@NotEmpty(message = "출판사를 기입하세요.")
	private String publisher;
	@NotNull(message = "가격을 기입하세요.")
	@Range(min=0,max=1000000,message = "{min}과 {max}사이로 입력하세요.")
	private Integer price;
	private Integer total_rating;
	@NotNull(message = "재고를 넣어주세요.")
	@Range(min = 1,max = 100000,message = "{min}과{max}사이로 넣어주세요.")
	private Integer stock;
	private String pub_date;
	private String reg_date;
	
	private String cat_id;
	
	private String image_name;
	private List<String> categoryPath;
	
}
