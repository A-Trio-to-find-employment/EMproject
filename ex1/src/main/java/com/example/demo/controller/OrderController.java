package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.MyOrders;
import com.example.demo.model.Orders_detail;
import com.example.demo.model.Return_exchange_refund;
import com.example.demo.model.StartEnd;
import com.example.demo.model.User_pref;
import com.example.demo.model.Users;
import com.example.demo.service.CartService;
import com.example.demo.service.CategoryService;
import com.example.demo.service.FieldService;
import com.example.demo.service.LoginService;
import com.example.demo.service.OrderService;
import com.example.demo.service.PrefService;
import com.example.demo.service.ReturnExchangeService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class OrderController {

    @Autowired
    private OrderService orderservice;
    @Autowired
    private ReturnExchangeService returnExchangeService;
    @Autowired
    private PrefService prefService;
    @Autowired
    private CategoryService categoryService;
    @Autowired
    private CartService cartService;
    @Autowired
    private LoginService loginService;
    @Autowired
	private FieldService fieldService;
    
    @GetMapping(value="/order/orderlist.html")
    public ModelAndView orderList(Integer PAGE_NUM, HttpSession session,HttpServletRequest request) {
        ModelAndView mav = new ModelAndView("orderlist");
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
        // 로그인된 사용자 정보 가져오기
        String user = (String) session.getAttribute("loginUser");     
        int currentPage = 1;
		// 페이지 번호가 null이 아니면 currentPage 설정
		if (PAGE_NUM != null) {
			currentPage = PAGE_NUM;
		}
		
		int count1 = this.orderservice.getTotal(user);
		int startRow = 0;
		int endRow = 0;
		int totalPageCount = 0;

		if (count1 > 0) {
			totalPageCount = count1 / 5; // 페이지 수 계산
			if (count1 % 5 != 0)
				totalPageCount++; // 나머지가 있으면 페이지 수 +1

			// startRow는 currentPage에 맞게 계산, 첫 페이지는 0, 두 번째 페이지는 5
			startRow = (currentPage - 1) * 5;

			// endRow는 startRow + 5로 설정, 단 endRow가 count보다 클 수 있으므로 count로 제한
			endRow = startRow + 5;

			if (endRow > count1) {
				endRow = count1;
			}
		}
        
       
        // 주문 목록을 페이지 범위에 맞게 설정
        StartEnd se = new StartEnd();
        se.setStart(startRow);
        se.setEnd(endRow);
        se.setUser_id(user);
        
        
        // 주문 목록을 가져오는 서비스 호출
        List<MyOrders> myorderlist = this.orderservice.getMyOrders(se);       
        
        // ModelAndView에 데이터 추가        
        mav.addObject("START", startRow);
        mav.addObject("END", endRow);
        mav.addObject("TOTAL", count1);
        mav.addObject("currentPage", currentPage);
        mav.addObject("LIST", myorderlist);  // 주문 목록을 JSP로 전달
        mav.addObject("pageCount", totalPageCount);
        
        return mav;  // JSP로 데이터 반환
    }
    
    @RequestMapping("/cancel")
    public String cancelOrder(String orderDetailId, HttpSession session) {
    	String loginUser = (String)session.getAttribute("loginUser");
        // 주문 상태와 배송 상태를 취소로 변경
    	this.orderservice.cancelDelivery(orderDetailId);
        this.orderservice.cancelOrder(orderDetailId);        
        // 주문 취소 시 선호도를 감점시킨다.
        Orders_detail od = this.orderservice.findOdByOdId(orderDetailId);
        // 주문 상세 번호를 통해 상품의 isbn을 찾고 이를 활용해 책의 카테고리들을 list형태로 가져온다.
        List<String> catList = this.categoryService.getCatIdFromIsbn(od.getIsbn());
        for(String catId : catList) {
        	User_pref up = new User_pref();
        	up.setUser_id(loginUser); up.setCat_id(catId);
        	up = this.prefService.getUserCatIdByCat(up);
        	int score = up.getPref_score() - 5;
        	if(score < 1) {
        		this.prefService.DeleteUserPref(up);
        	} else {
        		up.setPref_score(score);
        		this.prefService.updateScore(up);
        	}
        }
        Integer totalSum = this.cartService.getUserTotalPriceSum(loginUser); // 최근 3개월의 결제 금액 확인
        if(totalSum >= 150000 && totalSum < 300000) {
        	Users findUser = this.loginService.getUserById(loginUser);
        	int grade = findUser.getGrade();
        	Users updateUser = new Users();
        	if(grade == 0) { 
        		grade = grade + 1;
        		updateUser.setUser_id(loginUser);
            	updateUser.setGrade(grade);
            	session.setAttribute("userGrade", updateUser.getGrade());
        	} else if(grade == 2) {
        		grade = grade - 1;
        		updateUser.setUser_id(loginUser);
            	updateUser.setGrade(grade);
            	session.setAttribute("userGrade", updateUser.getGrade());
        	}
        	this.loginService.updateUserGrade(updateUser);
        } else if(totalSum >= 300000) {
        	Users findUser = this.loginService.getUserById(loginUser);
        	int grade = findUser.getGrade();
        	if(grade == 1 || grade == 0) {
        		grade = grade + 1;
        		Users updateUser = new Users();
        		updateUser.setUser_id(loginUser);
        		updateUser.setGrade(grade);
        		this.loginService.updateUserGrade(updateUser);
        		session.setAttribute("userGrade", updateUser.getGrade());
        	}
        } // 조건에 맞다면 사용자의 등급을 올린다.
        // 취소 후 주문 내역 페이지로 리디렉션
        return "redirect:/order/orderlist.html";
    }
    @PostMapping("/requestAction")
    public ModelAndView returnRequest( String orderDetailId, String BTN,HttpServletRequest request) {
    	ModelAndView mav = new ModelAndView();
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
    	MyOrders order = this.orderservice.getUsers(orderDetailId);
		mav.addObject("order",order);
    	if(BTN.equals("반품")) {    		
    		mav.setViewName("return");
    		
    	}else if(BTN.equals("교환")) {
    		
    		mav.setViewName("exchange");    	
    	}
        return mav;
    }
    @PostMapping("/submitReturn")
    public ModelAndView submitReturn(String detailid, Integer reason,
    		HttpSession session,HttpServletRequest request) {
    	String loginUser = (String)session.getAttribute("loginUser");
    	Return_exchange_refund rer = new Return_exchange_refund();
    	this.returnExchangeService.UpdateReturnExchangeRefund(detailid);
    	MyOrders myorders = new MyOrders();
    	myorders = this.returnExchangeService.getOrders(detailid);    	
    	Integer total = this.returnExchangeService.getTotal();    	
        rer.setOrder_detail_id(detailid);
        rer.setIsbn(myorders.getIsbn());
    	rer.setOrder_id(myorders.getOrder_id());
    	rer.setReason(reason);
    	rer.setRequest_id(total.toString());  
    	rer.setOrder_status(myorders.getOrder_status());
    	this.returnExchangeService.InsertReturnExchange(rer);
    	// 주문 취소 시 선호도를 감점시킨다.
        Orders_detail od = this.orderservice.findOdByOdId(detailid);
        // 주문 상세 번호를 통해 상품의 isbn을 찾고 이를 활용해 책의 카테고리들을 list형태로 가져온다.
        List<String> catList = this.categoryService.getCatIdFromIsbn(od.getIsbn());
        for(String catId : catList) {
        	User_pref up = new User_pref();
        	up.setUser_id(loginUser); up.setCat_id(catId);
        	up = this.prefService.getUserCatIdByCat(up);
        	if(up != null) {
        		int score = up.getPref_score() - 5;
            	if(score < 1) {
            		this.prefService.DeleteUserPref(up);
            	} else {
            		up.setPref_score(score);
            		this.prefService.updateScore(up);
            	}
        	}
        }
        Integer totalSum = this.cartService.getUserTotalPriceSum(loginUser); // 최근 3개월의 결제 금액 확인
        if(totalSum >= 150000 && totalSum < 300000) {
        	Users findUser = this.loginService.getUserById(loginUser);
        	int grade = findUser.getGrade();
        	Users updateUser = new Users();
        	if(grade == 0) { 
        		grade = grade + 1;
        		updateUser.setUser_id(loginUser);
            	updateUser.setGrade(grade);
            	session.setAttribute("userGrade", updateUser.getGrade());
        	} else if(grade == 2) {
        		grade = grade - 1;
        		updateUser.setUser_id(loginUser);
            	updateUser.setGrade(grade);
            	session.setAttribute("userGrade", updateUser.getGrade());
        	}
        	this.loginService.updateUserGrade(updateUser);
        } else if(totalSum >= 300000) {
        	Users findUser = this.loginService.getUserById(loginUser);
        	int grade = findUser.getGrade();
        	if(grade == 1 || grade == 0) {
        		grade = grade + 1;
        		Users updateUser = new Users();
        		updateUser.setUser_id(loginUser);
        		updateUser.setGrade(grade);
        		this.loginService.updateUserGrade(updateUser);
        		session.setAttribute("userGrade", updateUser.getGrade());
        	}
        } // 조건에 맞다면 사용자의 등급을 변경한다.
    	ModelAndView mav = new ModelAndView("redirect:/order/orderlist.html");
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
    @PostMapping("/submitExchange")
    public ModelAndView submitExchange(String detailid, Integer reason, HttpSession session) { 
    	String loginUser = (String)session.getAttribute("loginUser");
        Return_exchange_refund rer = new Return_exchange_refund();

        // 주문 상태 업데이트 (order_status를 4로 변경하는 로직)
        this.returnExchangeService.UpdateReturnExchangeRefunds(detailid);
        System.out.println("📌 [디버깅] 주문 상태 업데이트 요청 완료!");

        // 🔥 업데이트 후 DB에서 직접 order_status 다시 조회
        MyOrders updatedOrder = this.returnExchangeService.getOrders(detailid);
        System.out.println("📌 [디버깅] 업데이트 후 order_status: " + updatedOrder.getOrder_status());

        // 🔥 만약 업데이트 후에도 2라면 -> SQL 실행 여부 체크 필요
        if (updatedOrder.getOrder_status() == 2) {
            System.out.println("🚨 [경고] order_status가 업데이트되지 않았습니다! SQL 실행 확인 필요.");
        }

        // 최신 상태의 order_status를 다시 가져옴
        MyOrders myorders = this.returnExchangeService.getOrders(detailid);
        Integer total = this.returnExchangeService.getTotal();    

        rer.setOrder_detail_id(detailid);
        rer.setIsbn(myorders.getIsbn());
        rer.setOrder_id(myorders.getOrder_id());
        rer.setReason(reason);
        rer.setRequest_id(total.toString());  
        rer.setOrder_status(4);  // 🔥 무조건 4로 설정 (이전 값이 2라도 덮어쓰기)

        this.returnExchangeService.InsertReturnExchange(rer);
        Integer totalSum = this.cartService.getUserTotalPriceSum(loginUser); // 최근 3개월의 결제 금액 확인
        if(totalSum >= 150000 && totalSum < 300000) {
        	Users findUser = this.loginService.getUserById(loginUser);
        	int grade = findUser.getGrade();
        	Users updateUser = new Users();
        	if(grade == 0) { 
        		grade = grade + 1;
        		updateUser.setUser_id(loginUser);
            	updateUser.setGrade(grade);
            	session.setAttribute("userGrade", updateUser.getGrade());
        	} else if(grade == 2) {
        		grade = grade - 1;
        		updateUser.setUser_id(loginUser);
            	updateUser.setGrade(grade);
            	session.setAttribute("userGrade", updateUser.getGrade());
        	}
        	this.loginService.updateUserGrade(updateUser);
        } else if(totalSum >= 300000) {
        	Users findUser = this.loginService.getUserById(loginUser);
        	int grade = findUser.getGrade();
        	if(grade == 1 || grade == 0) {
        		grade = grade + 1;
        		Users updateUser = new Users();
        		updateUser.setUser_id(loginUser);
        		updateUser.setGrade(grade);
        		this.loginService.updateUserGrade(updateUser);
        		session.setAttribute("userGrade", updateUser.getGrade());
        	}
        } // 조건에 맞다면 사용자의 등급을 올린다.
        System.out.println("📌 반품 데이터 삽입 완료! order_status: " + rer.getOrder_status());

        return new ModelAndView("redirect:/order/orderlist.html");
    }


    
    
}

