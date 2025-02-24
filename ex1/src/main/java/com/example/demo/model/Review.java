package com.example.demo.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Review {
	private Integer review_id;
	private Long isbn;
	private String user_id;
	private Integer rating;
	private String content;
	private String reg_date;
}
