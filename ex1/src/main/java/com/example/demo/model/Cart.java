package com.example.demo.model;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Cart {
	private String cart_id;
	private String user_id;
	private Integer isbn;
	private Integer quantity;
	private Date eta;
}
