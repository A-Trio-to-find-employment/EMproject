package com.example.demo.model;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Qna {
	private Integer qna_number;
	private String user_id;
	private String qna_title;
	private String qna_detail;
	private Date qna_date;
	private String qna_index;
}
