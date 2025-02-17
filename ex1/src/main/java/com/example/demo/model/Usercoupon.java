package com.example.demo.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Usercoupon {
	private String user_id;
	private Integer coupon_id;
	private Integer is_used;
	private String used_at;
}
