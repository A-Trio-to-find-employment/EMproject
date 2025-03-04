package com.example.demo.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class BookStatistics {
	private Long isbn;
	private String book_title;
	private Integer total_sales;
	private Integer daily_sales;
	private Integer total_revenue;
	private Integer daily_revenue;
}
