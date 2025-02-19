package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpSession;

@Controller
public class IndexController {
	
	@RequestMapping(value="/index")
    public ModelAndView index() {
		ModelAndView mav = new ModelAndView("index");
		return mav;
	}
    
}
