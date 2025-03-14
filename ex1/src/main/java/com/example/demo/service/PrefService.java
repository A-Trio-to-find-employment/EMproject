package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.PrefMapper;
import com.example.demo.model.User_pref;

@Service
public class PrefService {
	@Autowired
	private PrefMapper prefMapper;
	
	public List<User_pref> getUserPref(String user_id){
		List<User_pref> upList = this.prefMapper.getUserPref(user_id);
		return upList;
	}
	public void insertPref(User_pref up) {
		this.prefMapper.insertPref(up);
	}
	public User_pref getUserCatIdByCat(User_pref up){
		User_pref upp = this.prefMapper.getUserCatIdByCat(up);
		return upp;
	}
	public void updateScore(User_pref up) {
		this.prefMapper.updateScore(up);
	}
	public void DeleteUserPref(User_pref up) {
		this.prefMapper.DeleteUserPref(up);
	}
	public void InitializationPref(String user_id) {
		this.prefMapper.InitializationPref(user_id);
	}
	public List<String> getUserTopCat(String user_id){
		List<String> catList = this.prefMapper.getUserTopCat(user_id);
		return catList;
	}
	public String getPrefTop(String user_id) {
		String cat_id = this.prefMapper.getPrefTop(user_id);
		return cat_id;
	}
}
