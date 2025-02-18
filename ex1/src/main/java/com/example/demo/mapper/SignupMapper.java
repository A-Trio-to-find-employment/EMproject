package com.example.demo.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Users;

@Mapper
public interface SignupMapper {
	void insertUser(Users users);
}
