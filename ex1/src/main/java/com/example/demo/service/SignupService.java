package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.SignupMapper;
import com.example.demo.model.Users;

@Service
public class SignupService{
	@Autowired
	private SignupMapper signupMapper;
	
	
	public void insertUser(Users users) {
		this.signupMapper.insertUser(users);
        System.out.println("User Info: " + users);	
	}

}
