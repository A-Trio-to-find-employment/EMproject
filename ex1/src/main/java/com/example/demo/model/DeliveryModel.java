package com.example.demo.model;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class DeliveryModel {
	private String order_detail_id;
	private String order_id;
	private Long isbn;
	private Integer quantity;
	private Integer delivery_status;
	private String user_id;
	private Timestamp created_at;
}
