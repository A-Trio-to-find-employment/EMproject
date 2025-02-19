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
public class LoginController {
	@Autowired
	public LoginService loginService;
	@Autowired
	public LoginValidator loginValidator;
	
	@GetMapping(value = "/login")
	public ModelAndView login(Users user) {
		ModelAndView mav = new ModelAndView("login");
		return mav;
	}
	@PostMapping(value = "/login")
	public ModelAndView secondfa(Users users, BindingResult br, HttpSession session) {
		ModelAndView mav = new ModelAndView();
		this.loginValidator.validate(users, br);
		if(br.hasErrors()) {
			mav.getModel().putAll(br.getModel());
			return mav;
		}
		try {
			Users loginUser = this.loginService.getUser(users);
			if(loginUser != null) {
				mav.setViewName("index");
				session.setAttribute("loginUser", loginUser);
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
