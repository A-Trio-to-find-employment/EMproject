package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.CouponMapper;
import com.example.demo.model.Usercoupon;

@Service
public class CouponService {
	@Autowired
	private CouponMapper couponMapper;
	
	public Integer findUserCoupon(Usercoupon usercoupon) {
		Integer coupon_id = this.couponMapper.findUserCoupon(usercoupon);
		return coupon_id;
	}
	public void getUserCoupon(Usercoupon usercoupon) {
		this.couponMapper.getUserCoupon(usercoupon);
	}
}
