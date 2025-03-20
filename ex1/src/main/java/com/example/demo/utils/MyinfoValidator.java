package com.example.demo.utils;

import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.example.demo.model.UserInfo;
import com.example.demo.model.Users;

@Service
public class MyinfoValidator implements Validator {

	@Override
	public boolean supports(Class<?> clazz) {
		return UserInfo.class.isAssignableFrom(clazz);
	}

	public void validate(Object target, Errors errors) {
		UserInfo user = (UserInfo)target;
		
		if( ! StringUtils.hasLength(user.getUser_id())) {
			errors.rejectValue("user_id", "error.empty");
		}
		if( ! StringUtils.hasLength(user.getPassword())) {
			errors.rejectValue("password", "error.empty");
		}
		if(errors.hasErrors()) {
			errors.reject("error.input.user_id");
		}
	}

}
