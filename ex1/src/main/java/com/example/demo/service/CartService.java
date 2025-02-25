package com.example.demo.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.CartMapper;
import com.example.demo.mapper.CouponMapper;
import com.example.demo.mapper.FieldMapper;
import com.example.demo.model.Book;
import com.example.demo.model.Cart;
import com.example.demo.model.Usercoupon;

import jakarta.transaction.Transactional;

@Service
public class CartService {
	@Autowired
	private CartMapper cartMapper;
	@Autowired
	private FieldMapper fieldMapper;
	@Autowired
	private CouponMapper couponMapper;
	
	public void insertCart(Cart cart) {
		this.cartMapper.insertCart(cart);
	}
	public List<Cart> selectCartList(String user_id){
		List<Cart> cartList = this.cartMapper.selectCartList(user_id);
		for (Cart cart : cartList) {
			Book book = this.fieldMapper.getBookDetail(cart.getIsbn());
			cart.setBook(book);
			 // 해당 장바구니 항목에 적용된 쿠폰 ID 목록 가져오기
	        List<Integer> couponIds = this.cartMapper.findCouponIdFromCart(cart);
	        List<Usercoupon> appliedCoupons = new ArrayList<>();

	        // 각 쿠폰 ID에 대해 Usercoupon 정보 가져오기
	        for(Integer couponId : couponIds) {
	        	Usercoupon uc = new Usercoupon();
	            uc.setCoupon_id(couponId);
	            uc.setUser_id(user_id);  // 현재 사용자 ID 설정
	            
	            // 쿠폰 정보 조회 시 user_id와 쿠폰 ID를 기준으로만 필터링
	            Usercoupon uscp = this.couponMapper.getUserCouponDetail(uc);
	            
	            // 유효한 쿠폰 정보만 추가
	            if (uscp != null && uscp.getUser_id().equals(user_id)) {
	                appliedCoupons.add(uscp);
	            }
	        }
		}
		return cartList;
	}
	public String findEqualItem(Cart cart) {
		String cart_id = this.cartMapper.findEqualItem(cart);
		return cart_id;
	}
	public void updateCart(Cart cart) {
		this.cartMapper.updateCart(cart);
	}
	public void deleteCart(String cart_id) {
		this.cartMapper.deleteCart(cart_id);
	}
	public Integer getCountCart() {
		Integer count = this.cartMapper.getCountCart();
		if(count == null) return 0;
		else return count;
	}
	public Cart findCartByCartId(String cart_id) {
		Cart cart = this.cartMapper.findCartByCartId(cart_id);
		return cart;
	}
	public List<String> getCatIdFromCartId(String cart_id) {
		List<String> catList = this.cartMapper.getCatIdFromCartId(cart_id);
		return catList;
	}
	public List<Integer> findCouponIdFromCart(Cart cart) {
		List<Integer> couponList = this.cartMapper.findCouponIdFromCart(cart);
		return couponList;
	}
	
	@Transactional
	public void updateCartCoupon(Cart cart) {
        String cart_id = cart.getCart_id();
        Integer coupon_id = cart.getCoupon_id();
        System.out.println("service coupon_id:["+coupon_id+"], cart_id:["+cart_id+"]");

		this.cartMapper.updateCartCoupon(cart);
	}
	
	public void deleteCartCoupon(String cart_id) {
		this.cartMapper.deleteCartCoupon(cart_id);
	}
	
	public void deleteUserCart(String user_id) {
		this.cartMapper.deleteUserCart(user_id);
	}
}
