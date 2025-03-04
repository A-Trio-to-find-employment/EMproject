package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.MyOrders;
import com.example.demo.model.Return_exchange_refund;
import com.example.demo.service.AdminrerService;

@Controller
public class AdminRerController {
	
	@Autowired
	private AdminrerService service;
	
	@GetMapping("/adminrer")
	public ModelAndView adminrer() {
		ModelAndView mav = new ModelAndView("adminrer");
		List<Return_exchange_refund> rer = this.service.getrer();
		mav.addObject("rer",rer);
		return mav;
	}
	@GetMapping("/adminexchange")
	public ModelAndView adminexchange() {
		ModelAndView mav = new ModelAndView("adminexchange");
		List<Return_exchange_refund> rer = this.service.getexchange();
		mav.addObject("rer",rer);
		return mav;
	}
	@GetMapping("/adminererdetail")
	public ModelAndView adminererdetail(String request_id) {
		ModelAndView mav = new ModelAndView("adminererdetail");
		MyOrders order = this.service.getRer(request_id);
		mav.addObject("order",order);
		return mav;
	}
	@GetMapping("/adminexchangedetail")
	public ModelAndView adminexchangedetail(String request_id) {
		ModelAndView mav = new ModelAndView("adminexchangedetail");
		MyOrders order = this.service.getRer(request_id);
		mav.addObject("order",order);
		return mav;
	}
	@PostMapping("/adminExchange")
	public ModelAndView adminExchange(String detailid ) {
		ModelAndView mav = new ModelAndView();
		this.service.seungin(detailid);
		this.service.seunginexchange(detailid);
		mav.setViewName("redirect:/adminexchange");
		return mav;
	}
	
	@PostMapping("/adminReturn")
	public ModelAndView adminReturn(String detailid) {
		ModelAndView mav = new ModelAndView();
		this.service.seungin(detailid);	
		this.service.seunginreturn(detailid);
		mav.setViewName("redirect:/adminrer");
		return mav;
	}

	
}
