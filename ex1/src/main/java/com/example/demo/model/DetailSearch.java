package com.example.demo.model;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DetailSearch {
	private String book_title;
	private String authors;
	private String publisher;
	private String pub_date_start;
	private String pub_date_end;
	private Long isbn;
	
	private Integer start;
	private Integer end;
}
