package com.example.demo.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Usercoupon;

@Mapper
public interface CouponMapper {
	Integer findUserCoupon(Usercoupon usercoupon);
	void getUserCoupon(Usercoupon usercoupon);

}
