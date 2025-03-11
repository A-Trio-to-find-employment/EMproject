package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.LoginMapper;
import com.example.demo.model.StartEndKey;
import com.example.demo.model.Users;

@Service
public class LoginService {
	@Autowired
	private LoginMapper loginMapper;
	
	public Users getUserById(String id) {
		return this.loginMapper.getUserById(id);
	}
	public Users getUser(Users users) {
		return this.loginMapper.getUser(users);
	}
	
	public void modifyUser(Users users) {
		this.loginMapper.modifyUser(users);
	}
	public List<Users> getUserList(StartEndKey sek){
		List<Users> userList = this.loginMapper.getUserList(sek);
		return userList;
	}
	public List<Users> getUserListSearch(StartEndKey sek){
		List<Users> userList = this.loginMapper.getUserListSearch(sek);
		return userList;
	}
	public Integer getUserCount() {
		Integer count = this.loginMapper.getUserCount();
		if(count == null) return 0;
		else return count;
	}
	public Integer getUserCountSearch(String SEARCH) {
		Integer count = this.loginMapper.getUserCountSearch(SEARCH);
		if(count == null) return 0;
		else return count;
	}
	public Users getUserByIdAdmin(String id) {
		Users userDetail = this.loginMapper.getUserByIdAdmin(id);
		return userDetail;
	}
	public void updateUserGrade(Users users) {
		this.loginMapper.updateUserGrade(users);
	}
}
