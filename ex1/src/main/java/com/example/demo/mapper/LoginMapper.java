package com.example.demo.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Users;

@Mapper
public interface LoginMapper {
	Users getUser(Users users);
	void modifyUser(Users users);
}
