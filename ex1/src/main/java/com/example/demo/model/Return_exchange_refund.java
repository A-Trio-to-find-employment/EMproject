package com.example.demo.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Return_exchange_refund {
	private String request_id;
	private String order_id;
	private String order_detail_id;
	private Long isbn;
	private Integer reason;
	private Integer order_status;
	private Integer status;
	private String book_title;
	private String user_id;
}
