package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Cart;

@Mapper
public interface CartMapper {
	void insertCart(Cart cart);
	List<Cart> selectCartList(String user_id);
	String findEqualItem(Cart cart);
	void updateCart(Cart cart);
	void deleteCart(String cart_id);
	Integer getCountCart();
	Cart findCartByCartId(String cart_id);
	List<String> getCatIdFromCartId(String cart_id);
	List<Integer> findCouponIdFromCart(Cart cart);
	void updateCartCoupon(Cart cart);
	void deleteCartCoupon(String cart_id);
	void deleteUserCart(String user_id);
	Integer getUserTotalPriceSum(String user_id);
}
