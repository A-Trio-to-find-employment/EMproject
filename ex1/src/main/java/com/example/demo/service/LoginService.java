package com.example.demo.service;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.LoginMapper;
import com.example.demo.model.Authorities;
import com.example.demo.model.StartEndKey;
import com.example.demo.model.UserInfo;
import com.example.demo.model.Users;

@Service
public class LoginService {
	@Autowired
	private LoginMapper loginMapper;
	
	public UserInfo getUserInfoById(String id) {
		return this.loginMapper.getUserInfoById(id);
	}
	public Users getUserById(String id) {
		return this.loginMapper.getUserById(id);
	}
//	public Users getUser(Users users) {
//		Users user = this.loginMapper.getUser(users);
//		if(user != null) {
//			this.loginMapper.updateCount(user.getUser_id());
//		}
//		return user;
//	}
	public void updateUserAuth(Authorities auth) {
        this.loginMapper.updateUserAuth(auth);
    }
	public Users getUser(Users users) {
		return this.loginMapper.getUser(users);
	}
	public void updateCount(String user_id) {
		this.loginMapper.updateCount(user_id);
	}
	
	public void modifyUser(UserInfo users) {
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
	
	public void updateLoginStats(Users user) {
        LocalDate today = LocalDate.now();

        if (user.getLast_date() != null) {
            LocalDate lastLoginDate = user.getLast_date().toLocalDate();

            if (lastLoginDate.plusDays(1).isEqual(today)) {
                user.setContinue_count(user.getContinue_count() + 1);
            } else {
                user.setContinue_count(0);
            }

            if (lastLoginDate.isEqual(today)) {
                user.setDaily_count(user.getDaily_count() + 1);
            } else {
                user.setDaily_count(1);
            }

            if (lastLoginDate.getYear() == today.getYear() && lastLoginDate.getMonth() == today.getMonth()) {
                user.setMonthly_count(user.getMonthly_count() + 1);
            } else {
                user.setMonthly_count(1);
            }
        } else {
        	//continue_count는 연속방문 횟수이기에 0으로 초기화
            user.setContinue_count(0);
            user.setDaily_count(1);
            user.setMonthly_count(1);
        }
        user.setCount(user.getCount() + 1);
        user.setLast_date(Date.valueOf(today));

        this.loginMapper.updateUserStats(user);  // XML에서 실행될 updateUserStats 호출
    }
	public String getPasswordByUsername(String username) {
		return this.loginMapper.getPasswordByUsername(username);
	}
	public Users getUsername(String username, String password) {
		return this.loginMapper.getUsername(username, password);
	}
}
