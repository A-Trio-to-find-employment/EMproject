package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.BookCategories;
import com.example.demo.model.Cart;
import com.example.demo.model.Category;
import com.example.demo.model.Review;
import com.example.demo.model.StartEnd;
import com.example.demo.service.CartService;
import com.example.demo.service.FieldService;
import com.example.demo.service.ReviewService;

import jakarta.servlet.http.HttpSession;

@Controller
public class FieldController {
	@Autowired
	private FieldService service;
	
	@Autowired
	private ReviewService reviewservice;

	@Autowired
	private CartService cartService;
	
	
	@RequestMapping(value = "/field.html")
	public ModelAndView field(String cat_id) {
	    ModelAndView mav = new ModelAndView("fieldlayout");

	    boolean hasSubCategories = service.countSubCategories(Integer.parseInt(cat_id));	    
	    if (hasSubCategories) {
	        List<Category> fieldlist = service.getCategories(cat_id);
	        // 각 카테고리에 대해 hasSubCategories 값을 설정
	        for (Category category : fieldlist) {
	            boolean subCategoriesExist = service.countSubCategories(Integer.parseInt(category.getCat_id()));
	            category.setHasSubCategories(subCategoriesExist);	            
	        }
	        mav.addObject("fieldlist", fieldlist);
	        mav.addObject("BODY", "fieldlist.jsp");
	    } 

	    else {
	        // 서브 카테고리가 없으면 booklist.html로 리다이렉트
	        mav.setViewName("redirect:/booklist.html?cat_id=" + cat_id);
	    }

	    return mav;
	}

	@RequestMapping(value = "/booklist.html")//마지막 하위카테고리면 그것을 클릭했을때 상품이 보여짐
	public ModelAndView fields(String cat_id, String sort, 
			Long BOOKID, String action, HttpSession session) {
		String loginUser = (String)session.getAttribute("loginUser");
		if(BOOKID != null && action != null) {
			if(loginUser == null) {
				ModelAndView mav = new ModelAndView("loginFail");
				return mav;
			}
			Cart cart = new Cart();
			cart.setIsbn(BOOKID); cart.setUser_id(loginUser);
			String cart_id = this.cartService.findEqualItem(cart);
			if(cart_id != null) {
				Cart existCart = this.cartService.findCartByCartId(cart_id);
				Integer quantity = existCart.getQuantity() + 1;
				existCart.setQuantity(quantity);
				this.cartService.updateCart(existCart);
			} else {
				Integer count = this.cartService.getCountCart() + 1;
				cart_id = count.toString();
				cart.setCart_id(cart_id); cart.setQuantity(1);
				this.cartService.insertCart(cart);
			}
			if(action.equals("add")) {
				ModelAndView mav = new ModelAndView("cartAlert");
				mav.addObject("cat_id", cat_id);
				mav.addObject("sort", sort);
				return mav;
			} else if(action.equals("buy")) {
				ModelAndView mav = new ModelAndView("redirect:/cart");
				return mav;
			}
		}
        ModelAndView mav = new ModelAndView("fieldlayout");
        List<Book> bookLists = service.getorderByBook(cat_id, sort); // 정렬된 도서 목록 가져오기        
        String categoryName = service.getCategoriesName(cat_id); // 카테고리 이름 가져오기        
        mav.addObject("bookList", bookLists); // 도서 목록 전달        
        mav.addObject("cat_name", categoryName); // 카테고리 이름 전달
        mav.addObject("BODY", "booklist.jsp"); // booklist.jsp를 BODY로 설정
        
        return mav;
	}
	@RequestMapping(value = "bookdetail.html")
	public ModelAndView bookdetail(Long isbn, String action, Integer PAGE_NUM, 
			HttpSession session) {
		String loginUser = (String)session.getAttribute("loginUser");
	    // 1. 책 정보 가져오기
		Book book = service.getBookDetail(isbn);
		if(isbn != null && action != null) {
			if(loginUser == null) {
				ModelAndView mav = new ModelAndView("loginFail");
				return mav;
			}
			Cart cart = new Cart();
			cart.setIsbn(isbn); cart.setUser_id(loginUser);
			String cart_id = this.cartService.findEqualItem(cart);
			if(cart_id != null) {
				Cart existCart = this.cartService.findCartByCartId(cart_id);
				Integer quantity = existCart.getQuantity() + 1;
				existCart.setQuantity(quantity);
				this.cartService.updateCart(existCart);
			} else {
				Integer count = this.cartService.getCountCart() + 1;
				cart_id = count.toString();
				cart.setCart_id(cart_id); cart.setQuantity(1);
				this.cartService.insertCart(cart);
			}
			if(action.equals("add")) {
				ModelAndView mav = new ModelAndView("cartAlertDetail");
				mav.addObject("isbn", isbn);
				return mav;
			} else if(action.equals("buy")) {
				ModelAndView mav = new ModelAndView("redirect:/cart");
				return mav;
			}
		}
		ModelAndView mav = new ModelAndView("fieldlayout");
		List<String> bookcategory = book.getCategoryPath();		
		
		int currentPage = 1;
		if(PAGE_NUM != null) currentPage = PAGE_NUM;
		int count = this.reviewservice.getTotal();
		int startRow = 0; int endRow = 0; int totalPageCount = 0;
		if(count > 0) {
			totalPageCount = count / 5;
			if(count % 5 != 0) totalPageCount++;
			startRow = (currentPage - 1) * 5;
			endRow = ((currentPage - 1) * 5) + 6;
			if(endRow > count) endRow = count;
		}
		StartEnd se = new StartEnd(); se.setStart(startRow); se.setEnd(endRow); se.setIsbn(isbn);
		List<Review> review = this.reviewservice.ReviewList(se);		
		mav.addObject("START",startRow); 
		mav.addObject("END", endRow);
		mav.addObject("TOTAL", count);	
		mav.addObject("currentPage",currentPage);
		mav.addObject("LIST",review); 
		mav.addObject("pageCount",totalPageCount);		
	    mav.addObject("BODY", "bookdetail.jsp"); // bookdetail.jsp 로드
	    mav.addObject("book", book); // 책 정보 추가
	    mav.addObject("bookcategory", bookcategory); // 책 정보 추가
	    
	    return mav;
	}
	
	 
}
