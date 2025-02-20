package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Users;
import com.example.demo.service.LoginService;
import com.example.demo.utils.LoginValidator;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class MypageController {
	@Autowired
	public LoginService loginService;
	@Autowired
	public LoginValidator loginValidator;
	
	@GetMapping(value = "/secondfa")
	public ModelAndView mypage(){
		ModelAndView mav = new ModelAndView("secondfa");
		return mav;
	}
	@PostMapping(value = "/secondfa")
	public ModelAndView secondfa(Users users, BindingResult br) {
		ModelAndView mav = new ModelAndView();
		if(br.hasErrors()) {
			mav.getModel().putAll(br.getModel());
		}
		try {
			Users loginUser = this.loginService.getUser(users);
			if(loginUser != null) {
				mav.setViewName("secondfaSuccess");
//				mav.addObject("loginUser",loginUser);
				return mav;
			}else {
				br.reject("error.login.user");
				mav.getModel().putAll(br.getModel());
				return mav;
			}
		}catch(EmptyResultDataAccessException e) {
			br.reject("error.login.user");
			mav.getModel().putAll(br.getModel());
			return mav;
		}
	}
	@GetMapping(value = "/myInfo")
	public ModelAndView myInfo(HttpSession session) {
		ModelAndView mav = new ModelAndView("mypage");
		String loginUser = (String)session.getAttribute("loginUser");
		if(loginUser == null) {
			mav.addObject("error", "로그인을 한 후 다시 시도해주세요.");
			return mav;
		}
		Users users = this.loginService.getUserById(loginUser);
		if(users != null) {
			mav.addObject("users",users);
			mav.addObject("user_id",users.getUser_id());
		}else {
			mav.addObject("error", "회원 정보를 찾을 수 없습니다.");
		}
		return mav;
	}
	@PostMapping(value = "/mypage/modify")
	public ModelAndView modify(@Valid Users users, BindingResult br) {
		ModelAndView mav = new ModelAndView("mypage");
		this.loginValidator.validate(users, br);
		if(br.hasErrors()) {
			mav.addObject("errors", br.getAllErrors());
			mav.getModel().putAll(br.getModel());
			return mav;
		}
		this.loginService.modifyUser(users);
//		Users newuser = this.loginService.getUser(users);
		Users newuser = this.loginService.getUserById(users.getUser_id());
		if(newuser != null) {
			mav.addObject(newuser);
			mav.addObject("users",users);
			mav.addObject("myInfoupdate");
		}else {
			mav.addObject("error", "회원 정보 수정 실패");
		}
		return mav;
	}
}
