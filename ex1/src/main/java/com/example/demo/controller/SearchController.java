package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.StringJoiner;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.Book_author;
import com.example.demo.model.Cart;
import com.example.demo.model.DetailSearch;
import com.example.demo.model.User_pref;
import com.example.demo.service.CartService;
import com.example.demo.service.CategoryService;
import com.example.demo.service.FieldService;
import com.example.demo.service.PrefService;
import com.example.demo.service.SearchService;

import jakarta.servlet.http.HttpSession;

@Controller
public class SearchController {
	@Autowired
	private SearchService searchService;
	@Autowired
	private PrefService prefService;
	@Autowired
	private CartService cartService;
	@Autowired
	private CategoryService categoryService;
	@Autowired
	private FieldService fieldService;
	@GetMapping(value="/goDetailSearch")
	public ModelAndView goDetailSearch() {
		ModelAndView mav = new ModelAndView("detailSearchForm");
		return mav;
	}
	
	@GetMapping(value="/detailSearch")
	public ModelAndView detailSearch(String TITLE, String AUTHOR, String PUBLISHER, 
			String PUB_DATE_START, String PUB_DATE_END, Long BOOKID, String action, 
			HttpSession session) {
		System.out.println("TITLE: " + TITLE);
		System.out.println("AUTHOR: " + AUTHOR);
		System.out.println("PUBLISHER: " + PUBLISHER);
		System.out.println("PUB_DATE_START: " + PUB_DATE_START);
		System.out.println("PUB_DATE_END: " + PUB_DATE_END);

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
				ModelAndView mav = new ModelAndView("cartAlertDetailSearch");
				mav.addObject("TITLE", TITLE);
				mav.addObject("AUTHOR", AUTHOR);
				mav.addObject("PUBLISHER", PUBLISHER);
				mav.addObject("PUB_DATE_START", PUB_DATE_START);
				mav.addObject("PUB_DATE_END", PUB_DATE_END);
				List<String> catList = this.categoryService.getCatIdFromIsbn(BOOKID);
				for(String catId : catList) {
					User_pref up = new User_pref();
					up.setUser_id(loginUser); up.setCat_id(catId);
					System.out.println(catId);
					User_pref testUp = this.prefService.getUserCatIdByCat(up);
					if(testUp == null) { // 사용자가 기존에 선호하지 않았던 카테고리
						up.setPref_score(1);
						this.prefService.insertPref(up); // 이 장르에 1점을 부여한 후 선호 장르에 추가
					}else {
						Integer score = 0;
						if(testUp.getPref_score() >= 999) {
							score = testUp.getPref_score();
						}else {
							score = testUp.getPref_score() + 1;
						}
						up.setPref_score(score);
						this.prefService.updateScore(up);
					}
				}
				return mav;
			} else if(action.equals("buy")) {
				ModelAndView mav = new ModelAndView("redirect:/cart");
				List<String> catList = this.categoryService.getCatIdFromIsbn(BOOKID);
				for(String catId : catList) {
					User_pref up = new User_pref();
					up.setUser_id(loginUser); up.setCat_id(catId);
					User_pref testUp = this.prefService.getUserCatIdByCat(up);
					if(testUp == null) { // 사용자가 기존에 선호하지 않았던 카테고리
						up.setPref_score(1);
						this.prefService.insertPref(up); // 이 장르에 1점을 부여한 후 선호 장르에 추가
					}else {
						Integer score = 0;
						if(testUp.getPref_score() >= 999) {
							score = testUp.getPref_score();
						}else {
							score = testUp.getPref_score() + 1;
						}
						up.setPref_score(score);
						this.prefService.updateScore(up);
					}
				}
				return mav;
			}
		}
		ModelAndView mav = new ModelAndView("searchResult");
		DetailSearch ds = new DetailSearch();
		ds.setBook_title(TITLE); ds.setAuthors(AUTHOR); ds.setPublisher(PUBLISHER);
		ds.setPub_date_start(PUB_DATE_START); ds.setPub_date_end(PUB_DATE_END);
		List<Book> testList = this.searchService.searchBooks(ds);
		List<Book> searchList = new ArrayList<Book>();
		for(Book book :testList) {
			Book finalBook = this.fieldService.getBookDetail(book.getIsbn());
			searchList.add(finalBook);
		}
		mav.addObject("TITLE", TITLE);
		mav.addObject("AUTHOR", AUTHOR);
		mav.addObject("PUBLISHER", PUBLISHER);
		mav.addObject("PUB_DATE_START", PUB_DATE_START);
		mav.addObject("PUB_DATE_END", PUB_DATE_END);
		mav.addObject("searchList", searchList);
		return mav;
	}
	@GetMapping(value="/goIsbnSearch")
	public ModelAndView isbnSearch(Long ISBN, Long BOOKID, String action, HttpSession session) {
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
				ModelAndView mav = new ModelAndView("cartAlertIsbnSearch");
				mav.addObject("ISBN", ISBN);
				List<String> catList = this.categoryService.getCatIdFromIsbn(BOOKID);
				for(String catId : catList) {
					User_pref up = new User_pref();
					up.setUser_id(loginUser); up.setCat_id(catId);
					System.out.println(catId);
					User_pref testUp = this.prefService.getUserCatIdByCat(up);
					if(testUp == null) { // 사용자가 기존에 선호하지 않았던 카테고리
						up.setPref_score(1);
						this.prefService.insertPref(up); // 이 장르에 1점을 부여한 후 선호 장르에 추가
					}else {
						Integer score = 0;
						if(testUp.getPref_score() >= 999) {
							score = testUp.getPref_score();
						}else {
							score = testUp.getPref_score() + 1;
						}
						up.setPref_score(score);
						this.prefService.updateScore(up);
					}
				}
				return mav;
			} else if(action.equals("buy")) {
				ModelAndView mav = new ModelAndView("redirect:/cart");
				List<String> catList = this.categoryService.getCatIdFromIsbn(BOOKID);
				for(String catId : catList) {
					User_pref up = new User_pref();
					up.setUser_id(loginUser); up.setCat_id(catId);
					User_pref testUp = this.prefService.getUserCatIdByCat(up);
					if(testUp == null) { // 사용자가 기존에 선호하지 않았던 카테고리
						up.setPref_score(1);
						this.prefService.insertPref(up); // 이 장르에 1점을 부여한 후 선호 장르에 추가
					}else {
						Integer score = 0;
						if(testUp.getPref_score() >= 999) {
							score = testUp.getPref_score();
						}else {
							score = testUp.getPref_score() + 1;
						}
						up.setPref_score(score);
						this.prefService.updateScore(up);
					}
				}
				return mav;
			}
		}
		System.out.println("입력된 isbn : " + ISBN);
		ModelAndView mav = new ModelAndView("searchResultIsbn");
		Book searchedBook = this.searchService.searchByIsbn(ISBN);
		List<Book> searchList = new ArrayList<Book>();
		if(searchedBook != null) {
			List<Book_author> baList = this.searchService.searchByIsbnAuthor(ISBN);
			StringJoiner authorPath = new StringJoiner(", ");
			for (Book_author ba : baList) {
			    authorPath.add(ba.getAuthor());
			}
			searchedBook.setAuthors(authorPath.toString());
			searchList.add(searchedBook);
			mav.addObject("searchList", searchList);
			return mav;
		}
		mav.addObject("searchList", null);
		return mav;
	}
}
