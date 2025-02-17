package com.example.demo.model;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Orders {
	private String order_id;
	private String user_id;
	private String address;
	private String address_detail;
	private Integer zipcode;
	private Integer total_price;
	private Integer order_status;
	private Date created_at;
}
