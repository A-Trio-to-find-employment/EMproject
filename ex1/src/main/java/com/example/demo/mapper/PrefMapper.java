package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.User_pref;

@Mapper
public interface PrefMapper {
	List<User_pref> getUserPref(String user_id);
	void insertPref(User_pref up);
	User_pref getUserCatIdByCat(User_pref up);
	void updateScore(User_pref up);
	void DeleteUserPref(User_pref up);
	void InitializationPref(String user_id);
	List<String> getUserTopCat(String user_id);
	String getPrefTop(String user_id);
}
