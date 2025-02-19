package com.example.demo.model;

import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Book {
	private String authors;
	private Long isbn;
	private String book_title;
	private String publisher;
	private Integer price;
	private Integer total_rating;
	private Integer stock;
	private String pub_date;
	private String reg_date;
	private String cat_id;
	private String image_name;
	private List<String> categoryPath;
	
}
