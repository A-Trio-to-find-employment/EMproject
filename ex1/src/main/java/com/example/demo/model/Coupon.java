package com.example.demo.model;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Coupon {
	private Integer coupon_id;
	@NotNull(message = "할인율을 입력하세요.")    
	private Integer discount_percentage;
	@NotBlank(message = "시작일자를 설정하세요.")
	private String valid_from;
	@NotBlank(message = "만료날자를 설정하세요.")
	private String valid_until;
	@NotNull(message = "쿠폰 코드를 입력하세요.")
    @Pattern(regexp = "^[A-Za-z0-9]+$", message = "쿠폰 코드는 영문 대소문자와 숫자만 포함할 수 있습니다.")
    private String coupon_code;
	@NotBlank(message = "카테고리 ID를 선택하세요.")
	private String cat_id;
}