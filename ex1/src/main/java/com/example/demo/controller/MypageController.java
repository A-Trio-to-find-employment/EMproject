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
	
	@GetMapping(value = "/mypage")
	public ModelAndView mypage(HttpSession session){
		String loginUser = (String)session.getAttribute("loginUser");
		if(loginUser != null) {
			ModelAndView mav = new ModelAndView("mypage");
			return mav;
		} else {
			ModelAndView mav = new ModelAndView("login");
			return mav;
		}
	}
	@PostMapping(value = "/secondfa")
	public ModelAndView secondfa(Users user, BindingResult br) {
		ModelAndView mav = new ModelAndView();
		if(br.hasErrors()) {
			mav.getModel().putAll(br.getModel());
		}
		try {
			Users loginUser = this.loginService.getUser(user);
			if(loginUser != null) {
				mav.setViewName("secondfaSuccess");
				mav.addObject("loginUser",loginUser);
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
}
