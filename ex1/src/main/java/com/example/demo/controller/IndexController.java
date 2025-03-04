package com.example.demo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.UserPreference;
import com.example.demo.service.FieldService;
import com.example.demo.service.PreferenceService;

import jakarta.servlet.http.HttpSession;

@Controller
public class IndexController {
	@Autowired
	private PreferenceService preferenceService;
	@Autowired 
	private FieldService fieldService;
	@RequestMapping(value="/index")
    public ModelAndView index(HttpSession session) {
		ModelAndView mav = new ModelAndView("index");
		String loginUser = (String) session.getAttribute("loginUser");
		if(loginUser != null) {
			List<UserPreference> upList = this.preferenceService.getUserTopCat(loginUser);
			List<String> catList = new ArrayList<String>();
			for(UserPreference up : upList) {
				catList.add(up.getCat_id());
			}
			 Map<String, Object> paramMap = new HashMap<>();
			 if (catList != null) paramMap.put("userId", loginUser);
			 paramMap.put("catIds", catList);
			 mav.addObject("catList", null);
			 // 최소 1개 이상의 카테고리가 있어야 추천 도서 검색 실행
		     if (!catList.isEmpty()) {
		    	 List<Long> recommendedIsbn = this.preferenceService.getRecommendedBooks(paramMap);
		         List<Book> recommendedBooks = new ArrayList<Book>();
		         for(Long isbn : recommendedIsbn) {
		         	Book book = this.fieldService.getBookDetail(isbn);
		            recommendedBooks.add(book);
		         }
		         mav.addObject("catList", catList);
		         mav.addObject("recommendedIsbns", recommendedIsbn);
		         mav.addObject("recommendedBooks", recommendedBooks);
		     }
		}
		return mav;
	}
    
}
