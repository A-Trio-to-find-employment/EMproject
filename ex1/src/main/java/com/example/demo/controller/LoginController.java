package com.example.demo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.Event;
import com.example.demo.model.StartEndKey;
import com.example.demo.model.UserCouponModel;
import com.example.demo.model.Users;
import com.example.demo.service.CategoryService;
import com.example.demo.service.CouponService;
import com.example.demo.service.EventService;
import com.example.demo.service.FieldService;
import com.example.demo.service.LoginService;
import com.example.demo.service.PrefService;
import com.example.demo.service.PreferenceService;
import com.example.demo.utils.LoginValidator;

import jakarta.servlet.http.HttpSession;


@Controller
public class LoginController {
	@Autowired
	public LoginService loginService;
	@Autowired
	public LoginValidator loginValidator;
	@Autowired
	public EventService eventService;
	@Autowired
	public CouponService couponService;
	@Autowired
	public CategoryService categoryService;
	@Autowired
	public PrefService prefService;
	@Autowired
	public PreferenceService preferenceService;
	@Autowired
	public FieldService fieldService;
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
			//로그인 성공 후 정보 가져오기
			Users loginUser = this.loginService.getUser(users);
			if(loginUser != null) {
				if(loginUser.getGrade() == 9) {
					ModelAndView newMav = new ModelAndView("admin");
					return newMav;
				}
				mav.setViewName("welcomeZone");
				session.setAttribute("loginUser", loginUser.getUser_id());//
//				mav.setViewName("loginSuccess");
//				mav.addObject("loginUser",loginUser);
				StartEndKey sek = new StartEndKey();
				sek.setStart(0); sek.setEnd(3);
				List<Event> eventList = this.eventService.getEventList(sek);
				List<UserCouponModel> testList = this.couponService.getAvailableCoupons(loginUser.getUser_id());
				List<UserCouponModel> ucList = new ArrayList<UserCouponModel>();
				for(UserCouponModel ucm : testList) {
					String cat_id = this.categoryService.getCatName(ucm.getCat_id());
					ucm.setCat_id(cat_id);
					ucList.add(ucm);
				}
				List<String> catList = this.prefService.getUserTopCat(loginUser.getUser_id());
				Map<String, Object> paramMap = new HashMap<>();
				if (catList != null)
					paramMap.put("userId", loginUser.getUser_id());
				paramMap.put("catIds", catList);
				mav.addObject("catList", null);
				// 최소 1개 이상의 카테고리가 있어야 추천 도서 검색 실행
				if (!catList.isEmpty()) {
					List<Long> recommendedIsbn = this.preferenceService.getRecommendedBookList(paramMap);
					List<Book> recommendedBooks = new ArrayList<Book>();
					for (Long isbn : recommendedIsbn) {
						Book book = this.fieldService.getBookDetail(isbn);
						recommendedBooks.add(book);
					}
					mav.addObject("catList", catList);
					mav.addObject("recommendedBooks", recommendedBooks);
				}
				mav.addObject("events", eventList);
				mav.addObject("coupons", ucList);
				System.out.println("사용자 등급 : " + loginUser.getGrade());
				session.setAttribute("userGrade", loginUser.getGrade());
				return mav;
			}else {
				br.reject("error.login.users");
				mav.getModel().putAll(br.getModel());
				return mav;
			}
		}catch(EmptyResultDataAccessException e) {
			br.reject("error.login.users");
			mav.getModel().putAll(br.getModel());
			return mav;
		}
	}
}
