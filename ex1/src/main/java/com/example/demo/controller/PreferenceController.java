package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class PreferenceController {
	
	@GetMapping(value="preftest")
	public ModelAndView gopref(String BTN) {
		ModelAndView mav = new ModelAndView();
		if(BTN.equals("동 의")) {
			mav.setViewName("genretest");
		} else if(BTN.equals("거 절")) {
			mav.setViewName("index");
		}
		return mav;
	}
}
