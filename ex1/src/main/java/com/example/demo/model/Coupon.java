package com.example.demo.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Coupon {
	private Integer coupon_id;
	private Integer discount_percentage;
	private String valid_from;
	private String valid_until;
	
}