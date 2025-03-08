package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.CouponMapper;
import com.example.demo.model.Book;
import com.example.demo.model.Coupon;
import com.example.demo.model.UserCouponModel;
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
	public List<Usercoupon> findUserCouponByUserId(String user_id) {
		List<Usercoupon> uplist = this.couponMapper.findUserCouponByUserId(user_id);
		for(Usercoupon uc : uplist) {
			Coupon coupon = this.couponMapper.couponDetail(uc.getCoupon_id());
	        uc.setCoupon(coupon);
		}
		return uplist;
	}
	public Coupon couponDetail(Integer coupon_id) {
		Coupon couponDetail = this.couponMapper.couponDetail(coupon_id);
		return couponDetail;
	}
	public void applyCoupon(Usercoupon uc) {
		this.couponMapper.applyCoupon(uc);
	}
	public Usercoupon getUserCouponDetail(Usercoupon uc) {
		Usercoupon userCoupon = this.couponMapper.getUserCouponDetail(uc);
		return userCoupon;
	}
	public List<Coupon> admingetcoupon() {
		return this.couponMapper.admingetcoupon();
	}
	public List<UserCouponModel> getAvailableCoupons(String user_id){
		List<UserCouponModel> ucmList = this.couponMapper.getAvailableCoupons(user_id);
		return ucmList;
	}
	public List<UserCouponModel> getUnavailableCoupons(String user_id){
		List<UserCouponModel> ucmList = this.couponMapper.getUnavailableCoupons(user_id);
		return ucmList;
	}
}
