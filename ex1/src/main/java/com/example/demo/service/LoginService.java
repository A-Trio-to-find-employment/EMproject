package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.LoginMapper;
import com.example.demo.model.Users;

@Service
public class LoginService {
	@Autowired
	private LoginMapper loginMapper;
	
	public Users getUser(Users users) {
		return this.loginMapper.getUser(users);
	}
	
	public void modifyUser(Users users) {
		this.loginMapper.modifyUser(users);
	}
}
