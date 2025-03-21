package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.CouponMapper;
import com.example.demo.model.Book;
import com.example.demo.model.Coupon;
import com.example.demo.model.StartEnd;
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
	public List<Coupon>CouponList(StartEnd se){
		return this.couponMapper.CouponList(se);
	}
	public Integer getTotalcoupon() {
		return this.couponMapper.getTotalcoupon();
	}
	public void deleteCoupon(Integer coupon_id) {
		this.couponMapper.deleteCoupon(coupon_id);
	}
	public Integer MaxCouponid() {
		Integer maxCouponid = couponMapper.MaxCouponid();  // 현재 최대 event_code 값을 가져옴
        if (maxCouponid == null) {
            return 10001;  
        } else {
            return maxCouponid + 1;  // 최대 값에 1을 더한 값을 반환
        }
	}
	public String checkCouponCode(String couponcode) {
		return this.couponMapper.checkCouponCode(couponcode);
	}
	public void InsertCoupon(Coupon coupon) {
		this.couponMapper.InsertCoupon(coupon);
	}
	public List<UserCouponModel> getAvailableCoupons(String user_id){
		List<UserCouponModel> ucmList = this.couponMapper.getAvailableCoupons(user_id);
		return ucmList;
	}
	public List<UserCouponModel> getUnavailableCoupons(String user_id){
		List<UserCouponModel> ucmList = this.couponMapper.getUnavailableCoupons(user_id);
		return ucmList;
	}
	public void insertCatCoupon(Coupon coupon) {
		this.couponMapper.insertCatCoupon(coupon);
	}
	public List<Coupon> getCouponByCode(String coupon_code) {
		List<Coupon> c = this.couponMapper.getCouponByCode(coupon_code);
		return c;
	}
}
