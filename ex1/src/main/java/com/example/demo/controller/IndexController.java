package com.example.demo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.Cart;
import com.example.demo.model.Category;
import com.example.demo.model.JJim;
import com.example.demo.model.StartEnd;
import com.example.demo.model.User_pref;
import com.example.demo.service.CartService;
import com.example.demo.service.CategoryService;
import com.example.demo.service.FieldService;
import com.example.demo.service.FilterService;
import com.example.demo.service.IndexService;
import com.example.demo.service.JJimService;
import com.example.demo.service.PrefService;
import com.example.demo.service.PreferenceService;

import jakarta.servlet.http.HttpSession;

@Controller
public class IndexController {
	@Autowired
	private PreferenceService preferenceService;
	@Autowired
	private FieldService fieldService;
	@Autowired
	private PrefService prefService;
	@Autowired
	private CategoryService categoryService;
	@Autowired
	private FilterService filterService;
	@Autowired
	private IndexService indexService;
	@Autowired
	private JJimService jjimService;
	@Autowired
	private CartService cartService;

	@RequestMapping(value = "/index")
	public ModelAndView index(HttpSession session) {
		ModelAndView mav = new ModelAndView("index");

		// 상위 카테고리 정보만 전달 (비동기 방식으로 중/하위 카테고리를 가져올 예정)
		List<Category> topCatList = filterService.getTopCategories();
		mav.addObject("topCatList", topCatList);
		
		List<Long> isbnList = this.indexService.getTop4Books();
		List<Book> bestList = new ArrayList<Book>();
		for (Long bestIsbn : isbnList) {
			Book bestBook = this.fieldService.getBookDetail(bestIsbn);
			bestList.add(bestBook);
		}
		mav.addObject("bestList", bestList);
		
		List<Long> newIsbnList = this.indexService.getTop4NewBook();
		List<Book> newBookList = new ArrayList<Book>();
		for(Long newIsbn : newIsbnList) {
			System.out.println("isbn : " + newIsbn);
			Book newBook = this.fieldService.getBookDetail(newIsbn);
			newBookList.add(newBook);
		}
		mav.addObject("newList", newBookList);
		
		// 로그인한 사용자의 추천 도서 관련 로직 (기존 코드 그대로)
		String loginUser = (String) session.getAttribute("loginUser");
		if (loginUser != null) {
			List<String> catList = this.prefService.getUserTopCat(loginUser);
			Map<String, Object> paramMap = new HashMap<>();
			if (catList != null)
				paramMap.put("userId", loginUser);
			paramMap.put("catIds", catList);
			mav.addObject("catList", null);
			// 최소 1개 이상의 카테고리가 있어야 추천 도서 검색 실행
			if (!catList.isEmpty()) {
				List<Long> recommendedIsbn = this.preferenceService.getRecommendedBooks(paramMap);
				List<Book> recommendedBooks = new ArrayList<Book>();
				for (Long isbn : recommendedIsbn) {
					Book book = this.fieldService.getBookDetail(isbn);
					recommendedBooks.add(book);
				}
				mav.addObject("catList", catList);
				mav.addObject("recommendedIsbns", recommendedIsbn);
				mav.addObject("recommendedBooks", recommendedBooks);
			}
		}
		return mav;
	}

	// Ajax 요청: 특정 상위 카테고리에 속한 중위 카테고리 목록 반환
	@RequestMapping(value = "/getMidCategories", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Category> getMidCategories(@RequestParam("topCatId") String topCatId) {
		return filterService.getMidCategoriesByParentId(topCatId);
	}

	// Ajax 요청: 특정 중위 카테고리에 속한 하위 카테고리 목록 반환
	@RequestMapping(value = "/getSubCategories", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public List<Category> getSubCategories(@RequestParam("midCatId") String midCatId) {
		return filterService.getSubCategoriesByParentId(midCatId);
	}

	@GetMapping(value = "/goBestSeller")
	public ModelAndView bestSellerList(Long BOOKID, String action, String action1, 
			Integer PAGE, HttpSession session) {
		String loginUser = (String) session.getAttribute("loginUser");
		int currentPage = 1;
		if (PAGE != null)
			currentPage = PAGE;
		int start = (currentPage - 1) * 5;
		int end = ((currentPage - 1) * 5) + 6;
		System.out.println("start : " + start + ", end : " + end);
		StartEnd se = new StartEnd();
		se.setStart(start);
		se.setEnd(end);
		List<Long> isbnList = this.indexService.getTop20Books(se);
		List<Book> bestSellerList = new ArrayList<Book>();
		
		if(loginUser == null) {
			for (Long bestIsbn : isbnList) {
				Book bestBook = this.fieldService.getBookDetail(bestIsbn);
				bestSellerList.add(bestBook);
			}
		}
		if (action1 != null) {
			// 로그인한 사용자가 없으면 로그인 페이지로 리다이렉트
			if (loginUser == null) {
				ModelAndView loginFailMav = new ModelAndView("loginFail");
				return loginFailMav;
			}

			// JJim 객체 생성 및 값 설정
			JJim jjim = new JJim();
			jjim.setUser_id(loginUser);
			jjim.setIsbn(BOOKID);

			// 찜 상태를 확인하여 찜 상태 변경
			if (action1.equals("jjim")) {
				// 찜 상태 확인
				boolean isLiked = jjimService.isBookLiked(jjim) > 0; // 반환값을 boolean으로 변환

				if (isLiked) {
					// 이미 찜한 책이라면 찜 삭제
					jjimService.deleteJjim(jjim);

					// 찜을 삭제했으므로 카테고리 선호도 점수도 감소
					List<String> catList = this.categoryService.getCatIdFromIsbn(BOOKID); // 해당 책의 카테고리 목록
					for (String catId : catList) {
						User_pref up = new User_pref();
						up.setUser_id(loginUser);
						up.setCat_id(catId);
						User_pref testUp = this.prefService.getUserCatIdByCat(up);

						if (testUp != null && testUp.getPref_score() > 0) {
							Integer score = testUp.getPref_score() - 1; // 찜을 제거했으므로 점수 감소
							up.setPref_score(score);
							this.prefService.updateScore(up);
						}
					}
				} else {
					// 찜하지 않은 책이라면 찜 추가
					jjimService.insertjjim(jjim);

					// 찜을 추가했으므로 카테고리 선호도 점수도 증가 (1점 증가)
					List<String> catList = this.categoryService.getCatIdFromIsbn(BOOKID); // 해당 책의 카테고리 목록
					for (String catId : catList) {
						User_pref up = new User_pref();
						up.setUser_id(loginUser);
						up.setCat_id(catId);
						User_pref testUp = this.prefService.getUserCatIdByCat(up);

						if (testUp == null) {
							// 사용자가 해당 카테고리를 선호하지 않았다면 선호도를 1점 부여
							up.setPref_score(1);
							this.prefService.insertPref(up);
						} else {
							// 점수를 1점만 증가
							Integer score = testUp.getPref_score() + 1; // 찜을 추가했으므로 점수 증가
							up.setPref_score(score);
							this.prefService.updateScore(up);
						}
					}
				}
			}
		}
		if (loginUser != null) {
			JJim jjim = new JJim();
			jjim.setUser_id(loginUser);
			jjim.setIsbn(BOOKID);
			for (Long bestIsbn : isbnList) {
				Book bestBook = this.fieldService.getBookDetail(bestIsbn);
				bestSellerList.add(bestBook);
			}
			// `bookList`의 각 책에 대해 찜 상태를 확인하고 업데이트
			for (Book book : bestSellerList) {
				jjim.setUser_id(loginUser);
				jjim.setIsbn(book.getIsbn());

				// 찜 상태 체크
				boolean isLiked = jjimService.isBookLiked(jjim) > 0;
				book.setLiked(isLiked);

				// 찜한 사람 수 계산 (예: 찜한 사람 수를 가져오는 메소드 호출)
				int likeCount = jjimService.getLikeCount(book.getIsbn());
				book.setLikecount(likeCount);
				
			}
			
		}
		if (BOOKID != null && action != null) {
			if (loginUser == null) {
				ModelAndView mav = new ModelAndView("loginFail");
				return mav;
			}
			Cart cart = new Cart();
			cart.setIsbn(BOOKID);
			cart.setUser_id(loginUser);
			String cart_id = this.cartService.findEqualItem(cart);
			if (cart_id != null) {
				Cart existCart = this.cartService.findCartByCartId(cart_id);
				Integer quantity = existCart.getQuantity() + 1;
				existCart.setQuantity(quantity);
				this.cartService.updateCart(existCart);
			} else {
				Integer count = this.cartService.getCountCart() + 1;
				cart_id = count.toString();
				cart.setCart_id(cart_id);
				cart.setQuantity(1);
				this.cartService.insertCart(cart);
			}
			if (action.equals("add")) {
				ModelAndView mav = new ModelAndView("cartAlertBest");
				List<String> catList = this.categoryService.getCatIdFromIsbn(BOOKID);
				for (String catId : catList) {
					User_pref up = new User_pref();
					up.setUser_id(loginUser);
					up.setCat_id(catId);
					System.out.println(catId);
					User_pref testUp = this.prefService.getUserCatIdByCat(up);
					if (testUp == null) { // 사용자가 기존에 선호하지 않았던 카테고리
						up.setPref_score(1);
						this.prefService.insertPref(up); // 이 장르에 1점을 부여한 후 선호 장르에 추가
					} else {
						Integer score = 0;
						if (testUp.getPref_score() >= 999) {
							score = testUp.getPref_score();
						} else {
							score = testUp.getPref_score() + 1;
						}
						up.setPref_score(score);
						this.prefService.updateScore(up);
					}
				}
				return mav;
			} else if (action.equals("buy")) {
				ModelAndView mav = new ModelAndView("redirect:/cart");
				List<String> catList = this.categoryService.getCatIdFromIsbn(BOOKID);
				for (String catId : catList) {
					User_pref up = new User_pref();
					up.setUser_id(loginUser);
					up.setCat_id(catId);
					User_pref testUp = this.prefService.getUserCatIdByCat(up);
					if (testUp == null) { // 사용자가 기존에 선호하지 않았던 카테고리
						up.setPref_score(1);
						this.prefService.insertPref(up); // 이 장르에 1점을 부여한 후 선호 장르에 추가
					} else {
						Integer score = 0;
						if (testUp.getPref_score() >= 999) {
							score = testUp.getPref_score();
						} else {
							score = testUp.getPref_score() + 1;
						}
						up.setPref_score(score);
						this.prefService.updateScore(up);
					}
				}
				return mav;
			}
		}
		
		
		
		int totalCount = this.indexService.getTopCount();
		int pageCount = totalCount / 5;
		if(totalCount % 5 != 0) pageCount++;
		
		ModelAndView mav = new ModelAndView("bestSellerList");
		mav.addObject("PAGE", currentPage);
		mav.addObject("currentPage", currentPage);
		mav.addObject("PAGES", pageCount);
		mav.addObject("bestSellerList", bestSellerList);
		return mav;
	}

}
