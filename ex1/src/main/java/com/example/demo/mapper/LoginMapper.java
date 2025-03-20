package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.demo.model.Authorities;
import com.example.demo.model.StartEndKey;
import com.example.demo.model.UserInfo;
import com.example.demo.model.Users;

@Mapper
public interface LoginMapper {
	Users getUser(Users users);
	void modifyUser(UserInfo users);
	Users getUserById(String id);
	UserInfo getUserInfoById(String id);
	List<Users> getUserList(StartEndKey sek);
	List<Users> getUserListSearch(StartEndKey sek);
	Integer getUserCount();
	Integer getUserCountSearch(String SEARCH);
	Users getUserByIdAdmin(String id);
	void updateUserGrade(Users users);
	void updateCount(String user_id);
	void updateUserAuth(Authorities auth);
	void updateUserStats(Users user);
	String getPasswordByUsername(@Param("username")String username);
	Users getUsername(@Param("username")String username, String password);
}
