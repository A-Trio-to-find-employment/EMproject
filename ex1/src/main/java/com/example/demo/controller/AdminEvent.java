package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Coupon;
import com.example.demo.model.Event;
import com.example.demo.model.StartEndKey;
import com.example.demo.service.CouponService;
import com.example.demo.service.EventService;

@Controller
public class AdminEvent {
	
	@Autowired
	private EventService eventService;
	@Autowired
	private CouponService couponService;
	
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
		ArrayList<Event> eventList = this.eventService.getEventList(sek);		
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
		ModelAndView mav = new ModelAndView();
		
		
		return mav;
	}
	
	
}
