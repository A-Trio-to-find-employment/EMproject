package com.example.demo.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.Coupon;
import com.example.demo.model.Event;
import com.example.demo.model.StartEndKey;
import com.example.demo.model.UserCouponModel;
import com.example.demo.model.Usercoupon;
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
	public ModelAndView login(Users user, HttpSession session, HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
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
				String[] isbnList = recentBookIsbnStr.split("\\|"); // 파이프 구분자로 분리

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
		if (authentication != null) {
			Object principal = authentication.getPrincipal();
			String userId = "";
			String password = "";

			if (principal instanceof UserDetails) {
				// 인증된 사용자가 UserDetails를 구현하고 있다면, 아이디와 비밀번호를 가져옴
				UserDetails userDetails = (UserDetails) principal;
				userId = userDetails.getUsername(); // 아이디
				password = userDetails.getPassword(); // 비밀번호
			} else {
				// 인증된 사용자가 UserDetails를 사용하지 않는 경우 (기본 사용자)
				userId = principal.toString(); // 예: "anonymousUser"와 같은 값이 나올 수 있음
			}

			// 사용자 아이디와 비밀번호를 콘솔에 출력
			System.out.println("현재 로그인한 사용자 아이디: " + userId);
			System.out.println("현재 로그인한 사용자 비밀번호: " + password);

			// imagebbs.setWriter(userId); // 작성자에 계정 설정
			session.setAttribute("loginUser", userId); // 세션에 로그인 사용자 설정
			session.setAttribute("password", password); // 세션에 로그인 사용자 설정

			Users loginUser = this.loginService.getUserById(userId);
			if (loginUser.getGrade() == 9) {
				ModelAndView newMav = new ModelAndView("admin");
				return newMav;
			} // admin으로 보내버림
			
			this.loginService.updateCount(loginUser.getUser_id());
//			System.out.println("count횟수: " + loginUser.getCount());
			this.loginService.updateLoginStats(loginUser);
			Users userInfo = this.loginService.getUserById(loginUser.getUser_id());
			mav.addObject("USER", loginUser);
			mav.setViewName("welcomeZone");
			session.setAttribute("loginUser", loginUser.getUser_id());
//			mav.setViewName("loginSuccess");
//			mav.addObject("loginUser",loginUser);
			StartEndKey sek = new StartEndKey();
			sek.setStart(0);
			sek.setEnd(3);
			List<Event> eventList = this.eventService.getEventList(sek);
			List<UserCouponModel> testList = this.couponService.getAvailableCoupons(loginUser.getUser_id());
			List<UserCouponModel> ucList = new ArrayList<UserCouponModel>();
			for (UserCouponModel ucm : testList) {
				String cat_id = this.fieldService.getCategoryPathByCatId(ucm.getCat_id());
				ucm.setCat_id(cat_id);
				ucList.add(ucm);
			}

			List<String> catList = this.prefService.getUserTopCat(loginUser.getUser_id());
			Map<String, Object> paramMap = new HashMap<>();
			if (catList != null) { // 선호 카테고리가 null이 아님.
				paramMap.put("userId", loginUser.getUser_id());
				paramMap.put("catIds", catList);
				mav.addObject("catList", null);
				String prefCatId = this.prefService.getPrefTop(loginUser.getUser_id());
				if (prefCatId == null) { // 선호 pref_id가 없으면
					mav.addObject("getCoupon", null);
				} else { // 선호 pref_id가 있다면
					String prefCatName = this.categoryService.getCatName(prefCatId);
					if (loginUser.getGrade() == 0) {
						String path = "";
						String month = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMM")); // 현재 연월
						path = prefCatName + month;
						List<Coupon> prefCoupon = this.couponService.getCouponByCode(path);
						List<Coupon> getCoupon = new ArrayList<Coupon>();
						for (Coupon c : prefCoupon) {
							String catId = this.fieldService.getCategoryPathByCatId(c.getCat_id());
							c.setCat_id(catId);
							getCoupon.add(c);
						}
						Usercoupon uc = new Usercoupon();
						for (Coupon cou : prefCoupon) {
							uc.setUser_id(loginUser.getUser_id());
							uc.setCoupon_id(cou.getCoupon_id());
							Integer testcid = this.couponService.findUserCoupon(uc);
							if (testcid != null) {
								getCoupon = null;
							}
						}
						mav.addObject("getCoupon", getCoupon);
					} else if (loginUser.getGrade() == 1) {
						String path = "";
						String month = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMM")); // 현재 연월
						path = prefCatName + month + "VIP";
						List<Coupon> prefCoupon = this.couponService.getCouponByCode(path);
						List<Coupon> getCoupon = new ArrayList<Coupon>();
						for (Coupon c : prefCoupon) {
							String catId = this.fieldService.getCategoryPathByCatId(c.getCat_id());
							c.setCat_id(catId);
							getCoupon.add(c);
						}
						Usercoupon uc = new Usercoupon();
						for (Coupon cou : getCoupon) {
							uc.setUser_id(loginUser.getUser_id());
							uc.setCoupon_id(cou.getCoupon_id());
							Integer testcid = this.couponService.findUserCoupon(uc);
							System.out.println("쿠폰 ID : " + testcid);
							if (testcid != null) {
								getCoupon = null;
							}
						}
						mav.addObject("getCoupon", getCoupon);
					} else if (loginUser.getGrade() == 2) {
						String path = "";
						String month = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMM")); // 현재 연월
						path = prefCatName + month + "VVIP";
						List<Coupon> prefCoupon = this.couponService.getCouponByCode(path);
						List<Coupon> getCoupon = new ArrayList<Coupon>();
						for (Coupon c : prefCoupon) {
							String catId = this.fieldService.getCategoryPathByCatId(c.getCat_id());
							c.setCat_id(catId);
							getCoupon.add(c);
						}
						Usercoupon uc = new Usercoupon();
						for (Coupon cou : getCoupon) {
							uc.setUser_id(loginUser.getUser_id());
							uc.setCoupon_id(cou.getCoupon_id());
							Integer testcid = this.couponService.findUserCoupon(uc);

							if (testcid != null) {
								getCoupon = null;
							}
						}
						mav.addObject("getCoupon", getCoupon);
					}
				}
			}
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
			List<Map<String, Object>> categoryPurchases = this.welcomeService
					.getCategoryPurchaseStats(loginUser.getUser_id());
			mav.addObject("categoryPurchases", categoryPurchases);

			List<Map<String, Object>> recentPurchases = this.welcomeService
					.getMonthlyPurchaseStats(loginUser.getUser_id());
			mav.addObject("recentPurchases", recentPurchases);

			mav.addObject("events", eventList);
			mav.addObject("coupons", ucList);
			System.out.println("사용자 등급 : " + loginUser.getGrade());
			session.setAttribute("userGrade", loginUser.getGrade());
			return mav;
		} 
		return mav;
	}

	@RequestMapping("/login/securityLogin.html")
	public ModelAndView securityLoginFrom() {
		ModelAndView mav = new ModelAndView("index");
		mav.addObject(new Users());
		mav.addObject("BODY", "securitylogin.jsp");
		return mav;
	}

}
