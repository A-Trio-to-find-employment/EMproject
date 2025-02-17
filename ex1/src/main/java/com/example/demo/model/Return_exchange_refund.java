package com.example.demo.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Return_exchange_refund {
	private String request_id;
	private String order_id;
	private String order_detail_id;
	private Integer isbn;
	private Integer reason;
	private Integer status;
}
