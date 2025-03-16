package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.StartEndKey;
import com.example.demo.model.Users;

@Mapper
public interface LoginMapper {
	Users getUser(Users users);
	void modifyUser(Users users);
	Users getUserById(String id);
	List<Users> getUserList(StartEndKey sek);
	List<Users> getUserListSearch(StartEndKey sek);
	Integer getUserCount();
	Integer getUserCountSearch(String SEARCH);
	Users getUserByIdAdmin(String id);
	void updateUserGrade(Users users);
	void updateCount(String user_id);
	
	void updateUserStats(Users user);
}
