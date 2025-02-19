package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Category;
import com.example.demo.model.PreferenceTest;
import com.example.demo.model.UserPreference;
import com.example.demo.model.Users;
import com.example.demo.service.CategoryService;
import com.example.demo.service.PreferenceService;

import jakarta.servlet.http.HttpSession;

@Controller
public class PreferenceController {
	@Autowired
    private CategoryService service;
	
	@Autowired
	private PreferenceService preferenceService;
	
	
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
	
	@PostMapping("/savePreference")
    public ModelAndView savePreference(@RequestParam("cat_ids") String[] catIds, HttpSession session) {
        // 세션에서 사용자 ID 가져오기
        Users user = (Users) session.getAttribute("loginUser");
        String userId = user.getUser_id();
        if (userId == null) {
        	ModelAndView mav = new ModelAndView("login");
            return mav; // 또는 에러 페이지로 이동
        }
        for (String catId : catIds) {
            // 새로운 pref_id 가져오기
            Long prefId = preferenceService.getMaxPrefId();
            
            // PreferenceTest 객체 생성 및 저장
            PreferenceTest preferenceTest = new PreferenceTest();
            preferenceTest.setPref_id(prefId);
            preferenceTest.setUser_id(userId);
            preferenceService.insertPref(preferenceTest);
            
            // UserPreference 객체 생성 및 저장
            UserPreference userPreference = new UserPreference();
            userPreference.setPref_id(prefId);
            userPreference.setCat_id(catId);
            preferenceService.insertUserPref(userPreference);
        }
        List<Long> pref_list = preferenceService.getPrefIdByUser(userId);
        List<Object[]> preferences = new ArrayList<>();
        for(Long pref_id : pref_list) {
        	UserPreference up = preferenceService.getUserPref(pref_id);
        	if (up != null) {
                String cat = up.getCat_id();
                String catname = service.getCatName(cat);
                preferences.add(new Object[] {catname, up.getPref_score()});
            }
        }
        ModelAndView mav = new ModelAndView("prefresult");
        mav.addObject("preferences", preferences);
        return mav;
    }
}
