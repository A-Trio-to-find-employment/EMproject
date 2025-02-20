package com.example.demo.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Event {
	private Long event_code;
	private String event_title;
	private String event_content;
	private Integer coupon_id;
	private String event_start;
	private String event_end;
}

