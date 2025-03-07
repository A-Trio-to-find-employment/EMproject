package com.example.demo.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MyReview {
	private Long order_id;
    private String created_at;
    private String book_title;
    private String content;
    private String reg_date;
}
