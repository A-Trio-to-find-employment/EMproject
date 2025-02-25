package com.example.demo.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MyOrders {
private Integer order_id;
private Integer order_status;
private String created_at;
private Integer order_detail_id;
private Long isbn;
private Integer quantity;
private Integer delivery_status;
private String book_title;
private Integer subtotal;
private Integer coupon_id;
private String coupon_code;
} 