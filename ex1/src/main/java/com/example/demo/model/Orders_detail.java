package com.example.demo.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Orders_detail {
	private String order_detail_id;
	private String order_id;
	private Long isbn;
	private Integer quantity;
	private Integer delivery_status;
	private Integer subtotal;
	private Integer coupon_id;
}
