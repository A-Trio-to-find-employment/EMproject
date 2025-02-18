package com.example.demo.utils;

import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.validation.Errors;
import org.springframework.validation.Validator;

import com.example.demo.model.Users;

@Service
public class LoginValidator implements Validator {

	@Override
	public boolean supports(Class<?> clazz) {
		return Users.class.isAssignableFrom(clazz);
	}

	public void validate(Object target, Errors errors) {
		Users users = (Users)target;
		
		if( ! StringUtils.hasLength(users.getUser_id())) {
			errors.rejectValue("user_id", "error.empty");
		}
		if( ! StringUtils.hasLength(users.getPassword())) {
			errors.rejectValue("password", "error.empty");
		}
		if(errors.hasErrors()) {
			errors.reject("error.input.user_id");
		}
		System.out.println("validate ok");
	}

}
