package com.example.demo.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Orders_detail {
	private String order_detail_id;
	private String order_id;
	private Integer isbn;
	private Integer quantity;
	private Integer delivery_status;
}
