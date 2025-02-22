package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.service.GoodsService;

import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;

@Controller
public class AdminController {
	@Autowired
	private GoodsService goodsService;
	
	@GetMapping(value = "/adminPage")
	public ModelAndView adminPage() {
		ModelAndView mav = new ModelAndView("admin");
		return mav;
	}
	@GetMapping(value = "/manageGoods")
	public ModelAndView manageGoods(Integer pageNo) {
		int currentPage = 1;
		if(pageNo != null) currentPage = pageNo;
		List<Book> goodsList = this.goodsService.getGoodsList(pageNo);
		ModelAndView mav = new ModelAndView("admin");
		Integer totalCount = this.goodsService.getGoodsCount();
		int pageCount = totalCount / 5;
		if(totalCount % 5 != 0) pageCount++;
		mav.addObject("GOODS",goodsList);
		mav.addObject("PAGES",pageCount);mav.addObject("currentPage",currentPage);
		mav.addObject("BODY","goodsList.jsp");
		return mav;
	}
	@GetMapping(value = "/manageGoods/detail")
	public ModelAndView goodsDetail(Long isbn) {
		ModelAndView mav = new ModelAndView("admin");
		Book goods = this.goodsService.getGoodsDetail(isbn);
		mav.addObject(goods);
		mav.addObject("GOODS", goods);
		mav.addObject("BODY","goodsDetail.jsp");
		return mav;
	}
	@PostMapping(value = "/manageGoods/search")
	public ModelAndView goodsSearch(String TITLE, Integer pageNo) {
		int currentPage = 1;
		if(pageNo != null) currentPage = pageNo;
		List<Book> goodsList = this.goodsService.getGoodsByName(TITLE, pageNo);
		Integer totalCount = this.goodsService.getGoodsCount();
		int pageCount = totalCount / 5;
		if(totalCount % 5 != 0) pageCount++;
		ModelAndView mav = new ModelAndView("admin");
		mav.addObject("PAGES",pageCount);mav.addObject("currentPage",currentPage);
		mav.addObject("GOODS",goodsList);
		mav.addObject("BODY","goodsByTitle.jsp");
		mav.addObject("TITLE",TITLE);
		return mav;
	}
	@GetMapping(value = "/manageGoods/add")
	public ModelAndView goodsAdd() {
		ModelAndView mav = new ModelAndView("admin");
		mav.addObject(new Book());
		mav.addObject("BODY","addGoods.jsp");
		//카테고리
		return mav;
	}
	@PostMapping(value = "/manageGoods/insert")
	public ModelAndView goodsInsert(@Valid Book book, BindingResult br, HttpSession session) {
		ModelAndView mav = new ModelAndView("admin");
		if(br.hasErrors()) {
			mav.addObject("BODY","addGoods.jsp");
			//카테고리?
			mav.addObject("","");
			mav.getModel().putAll(br.getModel());
			return mav;
		}
		this.goodsService.addGoods(book);
		mav.addObject("BODY","addGoodsComplete.jsp");
		return mav;
	}
	@GetMapping(value = "/manageGoods/isbnCheck")
	public ModelAndView isbnCheck(Long isbn) {
		ModelAndView mav = new ModelAndView("isbnCheckResult");
		Integer count = this.goodsService.getIsbnDup(isbn);
		if(count > 0) {
			mav.addObject("DUP","YES");
		}else {
			mav.addObject("DUP","NO");
		}
		mav.addObject("ISBN",isbn);
		return mav;
	}
	@PostMapping(value = "/manageGoods/update")
	public ModelAndView updateGoods() {
		ModelAndView mav = new ModelAndView("admin");
		mav.addObject("isbnChecked","");
		mav.addObject("book",new Book());
		mav.addObject("BODY","updateComplete.jsp");
		return mav;
	}
}
