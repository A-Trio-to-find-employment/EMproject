package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.Event;
import com.example.demo.model.StartEndKey;
import com.example.demo.model.UserCouponModel;
import com.example.demo.model.Usercoupon;
import com.example.demo.service.CouponService;
import com.example.demo.service.EventService;
import com.example.demo.service.FieldService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class EventController {
	
	@Autowired
	private EventService eventService;
	@Autowired
	private CouponService couponService;
	@Autowired
	private FieldService fieldService;
	@GetMapping(value="/eventlist")
	public ModelAndView eventList(Integer PAGE, String KEY,HttpServletRequest request) {
		ModelAndView mav = new ModelAndView("eventlist");
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
		int currentPage = 1;
		if(PAGE != null) currentPage = PAGE;
		int start = (currentPage - 1) * 5;
		int end = ((currentPage - 1) * 5) + 6;	
		StartEndKey sek = new StartEndKey();
		sek.setStart(start); sek.setEnd(end); 
		if(KEY != null) { sek.setKey(KEY); }
		ArrayList<Event> eventList = this.eventService.getEventList(sek);		
		int totalCount = this.eventService.getTotalCount();
		int pageCount = totalCount / 5;
		if(totalCount % 5 != 0) pageCount++;
		mav.addObject("currentPage",currentPage);
		mav.addObject("PAGES", pageCount);
		mav.addObject("eventList", eventList);
		return mav;
	}
	
	@GetMapping(value="/eventdetail")	
	public ModelAndView eventdetail(Long CODE,HttpServletRequest request) {		
		ModelAndView mav = new ModelAndView("eventdetail");
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
		Event event = this.eventService.getEventDetail(CODE);
		mav.addObject("event", event);
		return mav;
	}
	
	@GetMapping(value="/getcoupon")
	public ModelAndView getCoupon(Integer CP, HttpSession session) {
		String loginUser = (String)session.getAttribute("loginUser");
		if(loginUser == null) {
			ModelAndView mav = new ModelAndView("loginFail");
			return mav;
		}
		Usercoupon uc = new Usercoupon();
		uc.setCoupon_id(CP); uc.setUser_id(loginUser);
		Integer coupon = this.couponService.findUserCoupon(uc);
		if(coupon != null) {
			ModelAndView mav = new ModelAndView("getCouponFail");
			return mav;
		}
		this.couponService.getUserCoupon(uc);
		ModelAndView mav = new ModelAndView("getCouponSuccess");
		return mav;
	}
	
	@GetMapping(value="/myCoupon")
	public ModelAndView myCoupon(HttpSession session,HttpServletRequest request) {
		String loginUser = (String)session.getAttribute("loginUser");
		ModelAndView mav = new ModelAndView("myCouponList");
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
		List<UserCouponModel> availList = this.couponService.getAvailableCoupons(loginUser);
		if(availList == null) {
			mav.addObject("canUseList", null);
		} else {
			List<UserCouponModel> canUseList = new ArrayList<UserCouponModel>();
			for(UserCouponModel ucm : availList) {
				String catPath = this.fieldService.getCategoriesName(ucm.getCat_id());
				ucm.setCat_id(catPath);
				canUseList.add(ucm);
				mav.addObject("canUseList", canUseList);
			}
			
		}
		List<UserCouponModel> unAvailList = this.couponService.getUnavailableCoupons(loginUser);
		if(unAvailList == null) {
			mav.addObject("notUseList", null);
		} else {
			List<UserCouponModel> notUseList = new ArrayList<UserCouponModel>();
			for(UserCouponModel ucm : unAvailList) {
				String catPath = this.fieldService.getCategoriesName(ucm.getCat_id());
				ucm.setCat_id(catPath);
				notUseList.add(ucm);
				mav.addObject("notUseList", notUseList);
			}
			
		}
		return mav;
	}
	
}