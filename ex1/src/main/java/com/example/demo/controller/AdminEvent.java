package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Category;
import com.example.demo.model.Coupon;
import com.example.demo.model.Event;
import com.example.demo.model.StartEnd;
import com.example.demo.model.StartEndKey;
import com.example.demo.service.CategoryService;
import com.example.demo.service.CouponService;
import com.example.demo.service.EventService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class AdminEvent {
	
	@Autowired
	private EventService eventService;
	@Autowired
	private CouponService couponService;
	@Autowired
	private CategoryService categryservice;
	
	@GetMapping(value="/adminevent")
	public ModelAndView event(Integer PAGE, String KEY) {
		ModelAndView mav = new ModelAndView("admineventmenu");
		mav.addObject("BODY","admineventlist.jsp");
		int currentPage = 1;
		if(PAGE != null) currentPage = PAGE;
		int start = (currentPage - 1) * 5;
		int end = ((currentPage - 1) * 5) + 6;	
		StartEndKey sek = new StartEndKey();
		sek.setStart(start); sek.setEnd(end); 
		if(KEY != null) { sek.setKey(KEY); }
		ArrayList<Event> eventList = this.eventService.AdminGetEventList(sek);		
		int totalCount = this.eventService.getTotalCount();
		int pageCount = totalCount / 5;
		if(totalCount % 5 != 0) pageCount++;
		mav.addObject("currentPage",currentPage);
		mav.addObject("PAGES", pageCount);
		mav.addObject("eventList", eventList);
		return mav;		
	}
	@GetMapping(value="/admineventdetail")
	public ModelAndView eventdetail(Long CODE) {
		ModelAndView mav = new ModelAndView("admineventmenu");
		mav.addObject("BODY","admineventdetail.jsp");
		Event event = this.eventService.getEventDetail(CODE);
		List<Coupon> coupon = this.couponService.admingetcoupon();
		mav.addObject("coupon",coupon);
		mav.addObject("event", event);
		return mav;
	}
	@PostMapping(value="/admineventupdate")
	public ModelAndView admineventupdate(Long eventId,String event_title,String event_content,String event_start,String event_end,Integer couponId) {
		ModelAndView mav = new ModelAndView();
		Event event= new Event();
		event.setCoupon_id(couponId);
		event.setEvent_code(eventId);
		event.setEvent_content(event_content);
		event.setEvent_end(event_end);
		event.setEvent_start(event_start);
		event.setEvent_title(event_title);
		this.eventService.updateevent(event);		
		mav.setViewName("redirect:/adminevent");
		return mav;
	}
	@PostMapping(value="/admineventdelete")
	public ModelAndView admineventdelete(Long eventId) {
		ModelAndView mav = new ModelAndView();
		this.eventService.deleteevent(eventId);
		mav.setViewName("redirect:/adminevent");
		return mav;
	}
	@GetMapping(value="/eventregister")
	public ModelAndView eventregister() {					
		ModelAndView mav = new ModelAndView("admineventmenu");
		mav.addObject("BODY","eventregister.jsp");	
		List<Coupon> coupon = this.couponService.admingetcoupon();
		mav.addObject(new Event()); 
		mav.addObject("coupon",coupon);
		return mav;
	}
	
	@PostMapping(value="/eventregisterform")
	public ModelAndView eventregisterform(@Valid Event event, BindingResult br, Integer coupon_id) {
	    if (br.hasErrors()) {
	        System.out.println("Form has errors: " + br.getAllErrors());  // 오류 출력
	        ModelAndView mav = new ModelAndView("admineventmenu");
	        List<Coupon> coupon = this.couponService.admingetcoupon();
	        mav.addObject("coupon", coupon);
	        mav.getModel().putAll(br.getModel());
	        mav.addObject("BODY", "eventregister.jsp");
	        return mav;
	    }
	    Long count = this.eventService.maxcount();
	    Event eventt = new Event();
	    eventt.setCoupon_id(coupon_id);
	    eventt.setEvent_code(count);
	    eventt.setEvent_content(event.getEvent_content());
	    eventt.setEvent_title(event.getEvent_title());
	    eventt.setEvent_end(event.getEvent_end());
	    eventt.setEvent_start(event.getEvent_start());
	    this.eventService.insertevent(eventt);
	    return new ModelAndView("redirect:/adminevent"); // 리다이렉트 URL을 설정
	}
	@GetMapping(value="/admincouponlist")
	public ModelAndView admincouponlist(Integer PAGE_NUM) {
		ModelAndView mav = new ModelAndView("admineventmenu");
		mav.addObject("BODY","admincouponlist.jsp");
		
		int currentPage = 1;
		if(PAGE_NUM != null) currentPage = PAGE_NUM;
		int count = this.couponService.getTotalcoupon();
		int startRow = 0; int endRow = 0; int totalPageCount = 0;
		if(count > 0) {
			totalPageCount = count / 5;
			if(count % 5 != 0) totalPageCount++;
			startRow = (currentPage - 1) * 5;
			endRow = ((currentPage - 1) * 5) + 6;
			if(endRow > count) endRow = count;
		}
		StartEnd se = new StartEnd(); se.setStart(startRow); se.setEnd(endRow);
		List<Coupon> coupon = this.couponService.CouponList(se);		
		mav.addObject("START",startRow); 
		mav.addObject("END", endRow);
		mav.addObject("TOTAL", count);	
		mav.addObject("currentPage",currentPage);
		mav.addObject("LIST",coupon); 
		mav.addObject("pageCount",totalPageCount);			        	  
		return mav;		
	}
	
	@PostMapping("/deleteCoupon")
	public ModelAndView deleteCoupon(Integer coupon_id) {
		ModelAndView mav = new ModelAndView();		
		this.eventService.deleteCouponEvent(coupon_id);
		this.eventService.deleteUserCoupon(coupon_id);
		this.couponService.deleteCoupon(coupon_id);
		mav.setViewName("redirect:/admincouponlist"); // 리다이렉트 URL을 설정
		return mav;
	}
	@GetMapping("/admincoupon")
	public ModelAndView admincoupon() {
		ModelAndView mav = new ModelAndView("admineventmenu");
		mav.addObject("BODY","admincoupon.jsp");
		List<Category> cat = this.categryservice.getsubcategory();
		mav.addObject("cat",cat);
		mav.addObject(new Coupon());
		return mav;
	}
	// 쿠폰 코드 중복 검사
	@GetMapping(value = "/checkCouponCode")
	@ResponseBody  // AJAX 요청에 대한 JSON 응답을 반환
	public String couponCodeCheck(@RequestParam("couponCode") String couponCode) {
	    System.out.println("Received coupon code: " + couponCode);  // 쿠폰 코드 로그 출력

	    String existingCouponCode = this.couponService.checkCouponCode(couponCode);  // 쿠폰 코드 중복 확인

	    if (existingCouponCode != null) {  // 쿠폰 코드가 중복된 경우
	        return "{\"DUP\":\"YES\"}";  // JSON 형식으로 중복 응답
	    } else {  // 쿠폰 코드가 중복되지 않는 경우
	        return "{\"DUP\":\"NO\"}";  // JSON 형식으로 사용 가능 응답
	    }
	}
	@PostMapping("/admincouponsubmit")
	public ModelAndView admincouponsubmit(@Valid Coupon coupon,BindingResult br, HttpSession session) {
	    ModelAndView mav = new ModelAndView("admineventmenu");	    	   
		if(br.hasErrors()) {
			 List<Category> cat = this.categryservice.getsubcategory();
			    mav.addObject("cat",cat);
			mav.getModel().putAll(br.getModel());
			mav.addObject("BODY","admincoupon.jsp");
			return mav;
		}
		else {					
	    Integer count = this.couponService.MaxCouponid();	    	   
	    Coupon couponinsert = new Coupon();
	    couponinsert.setCat_id(coupon.getCat_id());
	    couponinsert.setCoupon_code(coupon.getCoupon_code());
	    couponinsert.setCoupon_id(count);
	    couponinsert.setDiscount_percentage(coupon.getDiscount_percentage());
	    couponinsert.setValid_from(coupon.getValid_from());
	    couponinsert.setValid_until(coupon.getValid_until());
	    this.couponService.InsertCoupon(couponinsert); 	    
	    session.setAttribute("couponMessage", "등록이 완료되었습니다.");
	    mav.setViewName("redirect:/admincouponlist"); // 리다이렉트 URL을 설정
	    return mav;
		}
	}

}
