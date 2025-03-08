package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Event;
import com.example.demo.model.StartEndKey;
import com.example.demo.model.UserCouponModel;
import com.example.demo.model.Usercoupon;
import com.example.demo.service.CouponService;
import com.example.demo.service.EventService;
import com.example.demo.service.FieldService;

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
	public ModelAndView eventList(Integer PAGE, String KEY) {
		ModelAndView mav = new ModelAndView("eventlist");
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
	public ModelAndView eventdetail(Long CODE) {
		ModelAndView mav = new ModelAndView("eventdetail");
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
	public ModelAndView myCoupon(HttpSession session) {
		String loginUser = (String)session.getAttribute("loginUser");
		ModelAndView mav = new ModelAndView("myCouponList");
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
