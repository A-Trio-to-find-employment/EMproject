package com.example.demo.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Cart {
	private String cart_id;
	private String user_id;
	private Long isbn;
	private Integer quantity;
	private Date eta;
	private Integer coupon_id;
	private Book book;
	private Integer subtotal;
	private List<Usercoupon> appliedCoupon = new ArrayList<Usercoupon>(); // 사용자 쿠폰 목록
	private List<Coupon> userCouponApplied = new ArrayList<Coupon>();
}
