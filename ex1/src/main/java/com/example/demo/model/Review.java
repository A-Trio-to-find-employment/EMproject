package com.example.demo.model;

import jakarta.validation.constraints.NotEmpty;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Review {
	private Integer review_id;
	private Long isbn;
	private String user_id;
	private Integer rating;
	@NotEmpty(message = "독서 후기를 입력해주세요.")
	private String content;
	private String reg_date;
}
