package com.example.demo.model;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class Users {
    @NotNull(message = "아이디는 필수 입력 항목입니다.")
    @Size(min = 5, max = 20, message = "아이디는 5자 이상 20자 이하로 입력해주세요.")
    private String user_id;

    @NotNull(message = "비밀번호는 필수 입력 항목입니다.")
    @Size(min = 8, max = 20, message = "비밀번호는 8자 이상 20자 이하로 입력해주세요.")
    private String password;

    @NotNull(message = "이름은 필수 입력 항목입니다.")
    private String user_name;

    @NotNull(message = "주소는 필수 입력 항목입니다.")
    private String address;

    @NotNull(message = "상세 주소는 필수 입력 항목입니다.")
    private String address_detail;
    
    @NotNull(message = "우편번호는 입력 필수 항목입니다.")
    private String zipcode;

    @NotNull(message = "이메일은 필수 입력 항목입니다.")
    @Email(message = "유효한 이메일 주소를 입력해주세요.")
    private String email;

    @NotNull(message = "생년월일은 필수 입력 항목입니다.")
    private String birth;

    @NotNull(message = "전화번호는 필수 입력 항목입니다.")
    @Pattern(regexp = "^\\d{3}-\\d{3,4}-\\d{4}$", message = "전화번호 형식은 010-0000-0000 형식이어야 합니다.")
    private String phone;

    private Integer grade;
}