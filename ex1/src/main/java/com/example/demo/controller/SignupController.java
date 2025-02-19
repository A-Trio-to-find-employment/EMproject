package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Users;
import com.example.demo.service.SignupService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class SignupController {
	@Autowired
	private SignupService signupService;
	
	@GetMapping(value="/signup")
	public ModelAndView goSignup() {
		ModelAndView mav = new ModelAndView("signup");
		mav.addObject("users", new Users());
		return mav;
	}
	
	@PostMapping(value="/signupResult")
	public ModelAndView signupResult(@Valid Users users, BindingResult br, HttpSession session) {
		users.setGrade(0);
		ModelAndView mav = new ModelAndView();
		if(br.hasErrors()) {
			mav.getModel().putAll(br.getModel());
			mav.setViewName("signup");
			return mav;
		}
		try {
			this.signupService.insertUser(users);
			 // 회원가입이 정상적으로 끝났으면, 성공 페이지로 이동
	        mav.setViewName("gopreftest");  // 회원가입 성공 시 보여줄 페이지 이름
	        mav.addObject("user", users); // 가입한 사용자 정보를 뷰로 전달
	        session.setAttribute("loginUser", users.getUser_id());
	        return mav;
		}catch(Exception e) {
			br.reject("signup.fail", "회원 가입 중 문제가 발생했습니다. 다시 시도해주세요.");
		    mav.getModel().putAll(br.getModel());
		    mav.setViewName("signup"); // 예외 발생 시, 다시 회원가입 페이지로 이동
			return mav;
		}
	}
}
