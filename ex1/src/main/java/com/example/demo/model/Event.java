package com.example.demo.model;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Event {
	 
	private Long event_code; 

	@NotEmpty(message = "이벤트 이름은 필수입니다.")
	@Size(max = 100, message = "이벤트 이름은 100자 이내로 입력하세요.")
	private String event_title;
 
	@NotEmpty(message = "이벤트 내용은 필수입니다.")
	@Size(max = 500, message = "이벤트 내용은 500자 이내로 입력하세요.")
	private String event_content;
	
	private Integer coupon_id;
	private String event_start;
	private String event_end;
	private String coupon_code; 
}

