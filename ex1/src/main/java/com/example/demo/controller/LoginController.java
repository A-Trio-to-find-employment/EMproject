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
import com.example.demo.service.WelcomeService;
import com.example.demo.utils.LoginValidator;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
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
	@Autowired
	public WelcomeService welcomeService;
	
	@GetMapping(value = "/login")
	public ModelAndView login(Users user) {
		ModelAndView mav = new ModelAndView("login");
		return mav;
	}
	@PostMapping(value = "/login")
	public ModelAndView secondfa(Users users, BindingResult br, HttpSession session,HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		// 쿠키에서 가져온 ISBN 목록을 처리
				String recentBookIsbnStr = null;
				Cookie[] cookies = request.getCookies();
				if (cookies != null) {
				    for (Cookie cookie : cookies) {
				        if (cookie.getName().equals("recentBook")) {
				            recentBookIsbnStr = cookie.getValue();
				            break;
				        }
				    }
				}

				List<Book> recentBooks = new ArrayList<>();
				if (recentBookIsbnStr != null) {
				    try {
				        // 여러 ISBN이 파이프(|)로 구분되어 있다고 가정
				        String[] isbnList = recentBookIsbnStr.split("\\|");  // 파이프 구분자로 분리
				        
				        // 배열을 뒤집어서 최근에 본 책을 먼저 처리
				        for (int i = isbnList.length - 1; i >= 0; i--) {
				            String isbn = isbnList[i].trim();
				            long recentBookIsbn = Long.parseLong(isbn);
				            Book recentBook = this.fieldService.getBookDetail(recentBookIsbn);
				            if (recentBook != null) {
				                recentBooks.add(recentBook);
				            }
				        }

				        // 뷰에 전달
				        mav.addObject("recentBooks", recentBooks);
				    } catch (NumberFormatException e) {
				        System.out.println("❌ 잘못된 ISBN 값: " + recentBookIsbnStr);
				    }
				}


		this.loginValidator.validate(users, br);
		if(br.hasErrors()) {
			mav.getModel().putAll(br.getModel());
			return mav;
		}
		try {
			//로그인 성공 후 정보 가져오기
			Users loginUser = this.loginService.getUser(users);
			if(loginUser != null) {
//				this.loginService.updateCount(loginUser.getUser_id());
//				System.out.println("count횟수: "+loginUser.getCount());
				this.loginService.updateLoginStats(loginUser);
				
				if(loginUser.getGrade() == 9) {
					ModelAndView newMav = new ModelAndView("admin");
					return newMav;
				}
//				Users userInfo = this.loginService.getUserById(users.getUser_id());
				mav.addObject("USER",loginUser);
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
					String cat_id = this.fieldService.getCategoryPathByCatId(ucm.getCat_id());
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
				// 사용자 구매 카테고리, 사용자 구매 도서량 받아오기
				List<Map<String, Object>> categoryPurchases = this.welcomeService.getCategoryPurchaseStats(loginUser.getUser_id());
				mav.addObject("categoryPurchases", categoryPurchases);
				
				List<Map<String, Object>> recentPurchases = this.welcomeService.getMonthlyPurchaseStats(loginUser.getUser_id());
	            mav.addObject("recentPurchases", recentPurchases);
				
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
