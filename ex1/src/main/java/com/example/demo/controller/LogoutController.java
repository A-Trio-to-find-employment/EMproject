package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpSession;

@Controller
public class LogoutController {
	
	@GetMapping("/logout")
	public ModelAndView logout(HttpSession session) {
	    session.invalidate();// 세션에서 loginUser 삭제
	    ModelAndView mav = new ModelAndView("redirect:/index");
	    return mav;  // 홈 페이지로 리다이렉트
	}
}