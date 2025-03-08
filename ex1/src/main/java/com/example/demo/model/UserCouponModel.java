package com.example.demo.model;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserCouponModel {
	private Integer coupon_id;
	private Integer is_used;
	private String coupon_code;
	private String cat_id;
	private Integer discount_percentage;
	private String valid_from;
	private String valid_until;
}
