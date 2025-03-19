package com.example.demo.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Users;

@Mapper
public interface SignupMapper {
	void insertUser(Users users);
	String checkId(String user_id);
	void insertAuth(String user_id);
}
