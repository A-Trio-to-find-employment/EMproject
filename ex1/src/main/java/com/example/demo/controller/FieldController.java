package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.Cart;
import com.example.demo.model.Category;
import com.example.demo.model.JJim;
import com.example.demo.model.Review;
import com.example.demo.model.StartEnd;
import com.example.demo.model.User_pref;
import com.example.demo.service.CartService;
import com.example.demo.service.CategoryService;
import com.example.demo.service.FieldService;
import com.example.demo.service.JJimService;
import com.example.demo.service.PrefService;
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
	@Autowired
	private PrefService prefService;
	@Autowired
	private CategoryService categoryService;
	@Autowired
	private JJimService jjimservice;
	
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
			Long BOOKID, String action, String action1, HttpSession session) {
		String loginUser = (String)session.getAttribute("loginUser");
		List<Book> bookLists = service.getorderByBook(cat_id, sort); // 정렬된 도서 목록 가져오기
		ModelAndView mav1 = new ModelAndView("fieldlayout");
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
		            boolean isLiked = jjimservice.isBookLiked(jjim) > 0;  // 반환값을 boolean으로 변환

		            if (isLiked) {
		                // 이미 찜한 책이라면 찜 삭제
		                jjimservice.deleteJjim(jjim);

		                // 찜을 삭제했으므로 카테고리 선호도 점수도 감소
		                List<String> catList = this.categoryService.getCatIdFromIsbn(BOOKID);  // 해당 책의 카테고리 목록
		                for (String catId : catList) {
		                    User_pref up = new User_pref();
		                    up.setUser_id(loginUser);
		                    up.setCat_id(catId);
		                    User_pref testUp = this.prefService.getUserCatIdByCat(up);

		                    if (testUp != null && testUp.getPref_score() > 0) {
		                        Integer score = testUp.getPref_score() - 1;  // 찜을 제거했으므로 점수 감소
		                        up.setPref_score(score);
		                        this.prefService.updateScore(up);
		                    }
		                }
		            } else {
		                // 찜하지 않은 책이라면 찜 추가
		                jjimservice.insertjjim(jjim);

		                // 찜을 추가했으므로 카테고리 선호도 점수도 증가 (1점 증가)
		                List<String> catList = this.categoryService.getCatIdFromIsbn(BOOKID);  // 해당 책의 카테고리 목록
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
		                        Integer score = testUp.getPref_score() + 1;  // 찜을 추가했으므로 점수 증가
		                        up.setPref_score(score);
		                        this.prefService.updateScore(up);
		                    }
		                }
		            }
		        }
		    }
		 if(loginUser != null) {
			 JJim jjim = new JJim();
			    jjim.setUser_id(loginUser);
			    jjim.setIsbn(BOOKID);
			    // `bookList`의 각 책에 대해 찜 상태를 확인하고 업데이트
			    for (Book book : bookLists) {		        
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
        
                
        String categoryName = service.getCategoriesName(cat_id); // 카테고리 이름 가져오기        
        mav1.addObject("bookList", bookLists); // 도서 목록 전달        
        mav1.addObject("cat_name", categoryName); // 카테고리 이름 전달
        mav1.addObject("loginUser",loginUser);
        mav1.addObject("BODY", "booklist.jsp"); // booklist.jsp를 BODY로 설정
     // 서버에서 isLiked 값을 모델에 추가               
        return mav1;
	}
	@RequestMapping(value = "/bookdetail.html")
	public ModelAndView bookdetail(Long isbn, String action,String action1, Integer PAGE_NUM, 
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
				List<String> catList = this.categoryService.getCatIdFromIsbn(isbn);
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
			} else if(action.equals("buy")) {
				ModelAndView mav = new ModelAndView("redirect:/cart");
				List<String> catList = this.categoryService.getCatIdFromIsbn(isbn);
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
		
		
		if (action1 != null) {
	        // 로그인한 사용자가 없으면 로그인 페이지로 리다이렉트
	        if (loginUser == null) {
	            ModelAndView loginFailMav = new ModelAndView("loginFail");
	            return loginFailMav;
	        }

	        // JJim 객체 생성 및 값 설정
	        JJim jjim = new JJim();
	        jjim.setUser_id(loginUser);
	        jjim.setIsbn(isbn);

	        // 찜 상태를 확인하여 찜 상태 변경
	        if (action1.equals("jjim")) {
	            // 찜 상태 확인
	            boolean isLiked = jjimservice.isBookLiked(jjim) > 0;  // 반환값을 boolean으로 변환

	            if (isLiked) {
	                // 이미 찜한 책이라면 찜 삭제
	                jjimservice.deleteJjim(jjim);

	                // 찜을 삭제했으므로 카테고리 선호도 점수도 감소
	                List<String> catList = this.categoryService.getCatIdFromIsbn(isbn);  // 해당 책의 카테고리 목록
	                for (String catId : catList) {
	                    User_pref up = new User_pref();
	                    up.setUser_id(loginUser);
	                    up.setCat_id(catId);
	                    User_pref testUp = this.prefService.getUserCatIdByCat(up);

	                    if (testUp != null && testUp.getPref_score() > 0) {
	                        Integer score = testUp.getPref_score() - 1;  // 찜을 제거했으므로 점수 감소
	                        up.setPref_score(score);
	                        this.prefService.updateScore(up);
	                    }
	                }
	            } else {
	                // 찜하지 않은 책이라면 찜 추가
	                jjimservice.insertjjim(jjim);

	                // 찜을 추가했으므로 카테고리 선호도 점수도 증가 (1점 증가)
	                List<String> catList = this.categoryService.getCatIdFromIsbn(isbn);  // 해당 책의 카테고리 목록
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
	                        Integer score = testUp.getPref_score() + 1;  // 찜을 추가했으므로 점수 증가
	                        up.setPref_score(score);
	                        this.prefService.updateScore(up);
	                    }
	                }
	            }
	        }
	    }

		    // 찜 상태 및 찜한 사람 수 업데이트
		    if (loginUser != null) {
		        JJim jjim = new JJim();
		        jjim.setUser_id(loginUser);
		        jjim.setIsbn(isbn);

		        // 찜 상태 체크
		        boolean isLiked = jjimservice.isBookLiked(jjim) > 0;
		        book.setLiked(isLiked);

		        // 찜한 사람 수 계산
		        int likeCount = jjimservice.getLikeCount(isbn);
		        book.setLikecount(likeCount);
		    }
		
		
		ModelAndView mav = new ModelAndView("fieldlayout");
		List<String> bookcategory = book.getCategoryPath();		
		
		int currentPage = 1;
		if(PAGE_NUM != null) currentPage = PAGE_NUM;
		int count = this.reviewservice.getTotal(isbn);
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
