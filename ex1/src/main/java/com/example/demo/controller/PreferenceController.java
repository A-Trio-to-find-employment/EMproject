package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Category;
import com.example.demo.service.CategoryService;

@Controller
public class PreferenceController {
	@Autowired
    private CategoryService service;
	
	@GetMapping(value="/preftest")
	public ModelAndView gopref(String BTN) {
		ModelAndView mav = new ModelAndView();
		if(BTN.equals("동 의")) {
			mav.setViewName("genretest");
			List<Category> categories = service.getTopCategories();
			mav.addObject("categories", categories);
		} else if(BTN.equals("거 절")) {
			mav.setViewName("index");
		}
		return mav;
	}
	
	@GetMapping(value="/gogenretest")
	public ModelAndView gotest() {
		ModelAndView mav = new ModelAndView("genretest");
		List<Category> categories = service.getTopCategories();
		mav.addObject("categories", categories);
		return mav;
	}
}
