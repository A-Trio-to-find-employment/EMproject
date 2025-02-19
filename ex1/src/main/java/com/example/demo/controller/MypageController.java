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
	public ModelAndView myInfo(Users users, HttpSession session) {
		String loginUser = (String)session.getAttribute("loginUser");
		this.loginService.getUserById(loginUser);
		session.setAttribute("loginUser", loginUser);
		ModelAndView mav = new ModelAndView("mypage");
		if(loginUser != null) {
			mav.addObject("users",loginUser);
		}
		return mav;
	}
	@PostMapping(value = "/mypage/modify")
	public ModelAndView modify(Users users, BindingResult br) {
		ModelAndView mav = new ModelAndView();
		this.loginValidator.validate(users, br);
		if(br.hasErrors()) {
			mav.addObject("mypage.jsp");
			mav.getModel().putAll(br.getModel());
			return mav;
		}
		this.loginService.modifyUser(users);
		Users newuser = this.loginService.getUser(users);
		mav.addObject("myInfoupdate");
		mav.addObject(newuser);
		return mav;
	}
}
