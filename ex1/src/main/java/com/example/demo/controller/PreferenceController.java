package com.example.demo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.Cart;
import com.example.demo.model.Category;
import com.example.demo.model.JJim;
import com.example.demo.model.User_pref;
import com.example.demo.service.CartService;
import com.example.demo.service.CategoryService;
import com.example.demo.service.FieldService;
import com.example.demo.service.JJimService;
import com.example.demo.service.PrefService;
import com.example.demo.service.PreferenceService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class PreferenceController {
	@Autowired
    private CategoryService service;
	@Autowired
	private JJimService jjimservice;
	
	@Autowired
	private PreferenceService preferenceService;
	
	@Autowired
	private FieldService fieldService;
	
	@Autowired 
	private CartService cartService;
	
	@Autowired
	private PrefService prefService;
	
	@GetMapping(value="/preftest")
	public ModelAndView gopref(String BTN) {
		ModelAndView mav = new ModelAndView();
		if(BTN.equals("동 의")) {
			mav.setViewName("genretest");	
			List<Category> categories = service.getTopCategories();
			mav.addObject("categories", categories);
		} else if(BTN.equals("거 절")) {
			mav.setViewName("index");
		}
		return mav;
	}
	
	@GetMapping(value="/gogenretest")
	public ModelAndView gotest() {
		ModelAndView mav = new ModelAndView("goPrefAlert");
		return mav;
	}
	
	@PostMapping("/savePreference")
    public ModelAndView savePreference(@RequestParam("cat_ids") String[] catIds, HttpSession session) {
        // 세션에서 사용자 ID 가져오기
        String userId = (String)session.getAttribute("loginUser");
        if (userId == null) {
        	ModelAndView mav = new ModelAndView("login");
            return mav; // 또는 에러 페이지로 이동
        }
        for (String catId : catIds) {
        	// 이미 존재하는 cat_id인지 test
        		User_pref up = new User_pref();
        		up.setUser_id(userId);
        		up.setCat_id(catId);
        		up.setPref_score(10); // pref_score의 초기값은 10.
        		this.prefService.insertPref(up);
        }

        List<Object[]> preferences = new ArrayList<>();
        List<User_pref> prefList = this.prefService.getUserPref(userId);
        for(User_pref up : prefList) {
        	String cat_name = this.service.getCatName(up.getCat_id());
        	preferences.add(new Object[] {cat_name, up.getPref_score()});
        }
        ModelAndView mav = new ModelAndView("myArea");
        mav.addObject("preferences", preferences);
        mav.addObject("BODY","prefresult.jsp");
        return mav;
    }
	
	@GetMapping(value="/showprefresult")
	public ModelAndView showprefresult(HttpSession session,HttpServletRequest request) {
		String userId = (String)session.getAttribute("loginUser");
		ModelAndView mav = new ModelAndView("myArea");
		if (userId == null) {
	    	mav = new ModelAndView("login");
	        return mav; // 또는 에러 페이지로 이동
		}
        List<Object[]> preferences = new ArrayList<>();
        List<User_pref> prefList = this.prefService.getUserPref(userId);
        for(User_pref up : prefList) {
        	String cat_name = this.service.getCatName(up.getCat_id());
        	preferences.add(new Object[] {cat_name, up.getPref_score()});
        }

        mav.addObject("BODY","prefresult.jsp");
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
        mav.addObject("preferences", preferences);
        return mav;
	}
	
	@GetMapping(value="/myPrefBookList")
	public ModelAndView prefList(Long BOOKID, String action,String action1, HttpSession session,HttpServletRequest request) {
		String loginUser = (String)session.getAttribute("loginUser");
		if(loginUser == null){
			ModelAndView mav = new ModelAndView("loginFail");
			return mav;
		} else if(loginUser != null) {
			if(BOOKID != null && action != null) {
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
					ModelAndView mav = new ModelAndView("cartAlertPref");
					return mav;
				} else if(action.equals("buy")) {
					ModelAndView mav = new ModelAndView("redirect:/cart");
					return mav;
				}
			}

			ModelAndView mav = new ModelAndView("prefList");
			List<String> catList = this.prefService.getUserTopCat(loginUser);
			Map<String, Object> paramMap = new HashMap<>();
			if (catList != null) paramMap.put("userId", loginUser);
			paramMap.put("catIds", catList);

			// 최소 1개 이상의 카테고리가 있어야 추천 도서 검색 실행
		    if (!catList.isEmpty()) {
		    	List<Long> recommendedIsbn = this.preferenceService.getRecommendedBookList(paramMap);
		    	List<Book> recommendedBooks = new ArrayList<Book>();		    	
		    	for(Long isbn : recommendedIsbn) {
		    		Book book = this.fieldService.getBookDetail(isbn);
		            recommendedBooks.add(book);
		        }
		    	mav.addObject("recommendedBooks", recommendedBooks);
		    	if (action1 != null) {
				    // 로그인한 사용자가 없으면 로그인 페이지로 리다이렉트				    

				    // JJim 객체 생성 및 값 설정
				    JJim jjim = new JJim();
				    jjim.setUser_id(loginUser);
				    jjim.setIsbn(BOOKID);

				    // 찜 상태를 확인하여 찜 상태 변경
				    if (action1.equals("jjim")) {
				        // 찜 상태 확인
				        boolean isLiked = jjimservice.isBookLiked(jjim) > 0;  // 반환값을 boolean으로 변환
				        
				        if (isLiked) {
				            // 이미 찜한 책이라면 찜 삭제
				            jjimservice.deleteJjim(jjim);
				        } else {
				            // 찜하지 않은 책이라면 찜 추가
				            jjimservice.insertjjim(jjim);
				        }
				    }
				   
				}
				if(loginUser != null) {
				 JJim jjim = new JJim();
				    jjim.setUser_id(loginUser);
				    jjim.setIsbn(BOOKID);
				    // `bookList`의 각 책에 대해 찜 상태를 확인하고 업데이트
				    for (Book book : recommendedBooks) {		        
				        jjim.setUser_id(loginUser);
				        jjim.setIsbn(book.getIsbn());

				        // 찜 상태 체크
				        boolean isLiked = jjimservice.isBookLiked(jjim) > 0;
				        book.setLiked(isLiked);

				        // 찜한 사람 수 계산 (예: 찜한 사람 수를 가져오는 메소드 호출)
				        int likeCount = jjimservice.getLikeCount(book.getIsbn());
				        book.setLikecount(likeCount);
				    }
				}
		     }	
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



		     return mav;
		}
		
		ModelAndView maav = new ModelAndView("index");
		return maav;
	}
	
	@GetMapping(value="/goNewPrefTest")
	public ModelAndView notFirstGenreTest(HttpSession session) {
		String loginUser = (String)session.getAttribute("loginUser");
		if(loginUser == null) {
			ModelAndView mav = new ModelAndView("loginFail");
			return mav;
		}
		this.prefService.InitializationPref(loginUser);
		ModelAndView mav = new ModelAndView("genretest");
		List<Category> categories = service.getTopCategories();
		mav.addObject("categories", categories);
		return mav;
	}
}
