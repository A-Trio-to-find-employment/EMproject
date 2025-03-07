package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Coupon;
import com.example.demo.model.StartEnd;
import com.example.demo.model.Usercoupon;

@Mapper
public interface CouponMapper {
	Integer findUserCoupon(Usercoupon usercoupon);
	void getUserCoupon(Usercoupon usercoupon);
	List<Usercoupon> findUserCouponByUserId(String user_id);
	Coupon couponDetail(Integer coupon_id);
	void applyCoupon(Usercoupon uc);
	Usercoupon getUserCouponDetail(Usercoupon uc);
	List<Coupon> admingetcoupon();
	List<Coupon>CouponList(StartEnd se);
	Integer getTotalcoupon();
}
