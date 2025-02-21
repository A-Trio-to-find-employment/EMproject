package com.example.demo.model;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Qna {
	private Integer qna_number;
	private String user_id;
	
	@NotBlank(message = "제목은 필수 입력 항목입니다.")
    @Size(min = 1, max = 33, message = "제목은 33글자 이내만 가능합니다.")	
	private String qna_title;
	
	@NotBlank(message = "내용은 필수 입력 항목입니다.")
	private String qna_detail;
	private String ans_content;
	private String qna_image;
	private String qna_date;
	private String qna_index;
	private MultipartFile image;
}
