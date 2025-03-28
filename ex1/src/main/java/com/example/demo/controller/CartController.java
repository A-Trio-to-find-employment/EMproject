package com.example.demo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.Cart;
import com.example.demo.model.Coupon;
import com.example.demo.model.Orders;
import com.example.demo.model.Orders_detail;
import com.example.demo.model.User_pref;
import com.example.demo.model.Usercoupon;
import com.example.demo.model.Users;
import com.example.demo.service.CartService;
import com.example.demo.service.CategoryService;
import com.example.demo.service.CouponService;
import com.example.demo.service.FieldService;
import com.example.demo.service.LoginService;
import com.example.demo.service.OrderService;
import com.example.demo.service.PrefService;
import com.example.demo.service.PreferenceService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/cart")
public class CartController {

    @Autowired
    private CartService cartService;

    @Autowired
    private CouponService couponService;
    
    @Autowired
    private LoginService loginService;
    
    @Autowired
    private OrderService orderService;
    
    @Autowired
    private PreferenceService preferenceService;
    
    @Autowired 
    private FieldService fieldService;
    
    @Autowired
    private PrefService prefService;
    
    @Autowired
    private CategoryService categoryService;
    
    // 장바구니 조회
    @GetMapping
    public ModelAndView CartList(HttpSession session,HttpServletRequest request) {
        String loginUser = (String) session.getAttribute("loginUser");
        if (loginUser == null) {
            ModelAndView mav = new ModelAndView("loginFail");
            return mav;
        }
        List<String> cpnameList = new ArrayList<String>();
        List<Integer> dpList = new ArrayList<Integer>();
        List<Cart> cartList = cartService.selectCartList(loginUser);
        Map<String, List<Coupon>> selectBox = new HashMap<>();
        List<Integer> subTotalList = new ArrayList<Integer>();
        ModelAndView mav = new ModelAndView("cart");
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
        int totalPrice = 0;
        for (Cart cart : cartList) { // 카트 항목마다 반복
        	// 사용가능한쿠폰 목록
        	List<Integer> availableCouponIds = cartService.findCouponIdFromCart(cart);
            // 쿠폰을 전체적으로 받을 리스트
        	List<Coupon> availableCoupons = new ArrayList<>();
            for (Integer cpid : availableCouponIds) {
                Coupon coupon = this.couponService.couponDetail(cpid);
                if (coupon != null) {
                    availableCoupons.add(coupon);
                }
            }
            selectBox.put(cart.getCart_id(), availableCoupons);
            // 여기까지 사용가능한 쿠폰은 잘 출력된다.
            int subtotal = 0; // subtotal 값이 변경되는게 반영되지 않는다.
            int bookPrice = cart.getBook().getPrice();
            int quantity = cart.getQuantity();
            if (cart.getCoupon_id() != null) { 
                Integer cid = cart.getCoupon_id();
                Coupon coupon = this.couponService.couponDetail(cid);
                int discountPercentage = coupon.getDiscount_percentage();
                String coupon_code = coupon.getCoupon_code();
                int discountAmount = bookPrice * discountPercentage / 100;
                int discountedPrice = bookPrice - discountAmount;
                int normalPrice = bookPrice * (quantity - 1);
                subtotal = discountedPrice + normalPrice;
                dpList.add(discountPercentage);
                cpnameList.add(coupon_code);
            } else {
                subtotal = bookPrice * quantity;
                dpList.add(0);
                cpnameList.add("0");
            }
            subTotalList.add(subtotal);
            totalPrice += subtotal;
        }
        Users userinfo = this.loginService.getUserById(loginUser);
        mav.addObject("userInfo", userinfo);
        mav.addObject("cpnameList", cpnameList);
        mav.addObject("dpList", dpList);
        mav.addObject("subList", subTotalList);
        mav.addObject("cartList", cartList);
        mav.addObject("selectBox", selectBox);
        mav.addObject("totalPrice", totalPrice);
        return mav;
    }

    // 수량 변경 (수정 버튼 클릭 시만 반영)
    @PostMapping("/updateCart")
    public String updateCart(@RequestParam("cart_id") String cartId, 
                             @RequestParam("NUM") int quantity) {
        if (quantity > 0) {
        	Cart cart = new Cart();
        	cart.setCart_id(cartId);
        	cart.setQuantity(quantity);
            this.cartService.updateCart(cart);
        }
        return "redirect:/cart";
    }

    // 장바구니에서 삭제
    @PostMapping("/deleteCart")
    public String deleteCart(@RequestParam("cart_id") String cartId, HttpSession session) {
    	String loginUser = (String) session.getAttribute("loginUser");
    	if (loginUser == null) {
            return "redirect:/login";
        }
    	
    	Cart deleteCart = cartService.findCartByCartId(cartId);
    	List<String> catList = this.categoryService.getCatIdFromIsbn(deleteCart.getIsbn());
    	User_pref up = new User_pref();
    	for(String catId : catList) {
    		up.setUser_id(loginUser); up.setCat_id(catId);
        	up = this.prefService.getUserCatIdByCat(up);
        	int score = up.getPref_score() - 1;
        	if(score < 1) {
        		this.prefService.DeleteUserPref(up);
        	} else {
        		up.setPref_score(score);
        		this.prefService.updateScore(up);
        	}
    	}
        if (deleteCart != null) {
            List<Usercoupon> ucList = deleteCart.getAppliedCoupon();
            if (ucList != null) {
                for (Usercoupon uc : ucList) {
                    Usercoupon checkUc = couponService.getUserCouponDetail(uc);
                    if (checkUc != null && checkUc.getIs_used() > 0) { // 쿠폰 적용되어있으면 미적용으로 변경
                        couponService.applyCoupon(uc);
                    }
                }
            }
            cartService.deleteCart(cartId);
        }

        return "redirect:/cart";
    }

 // 쿠폰 적용
    @PostMapping("/applyCoupon")
    public ModelAndView applyCoupon(@RequestParam("coupon_id") Integer couponId,
            @RequestParam("cart_id") String cartId, HttpSession session) {
        String loginUser = (String) session.getAttribute("loginUser");
        if (loginUser == null) {
            ModelAndView mav = new ModelAndView("loginFail");
            return mav;
        }
        // 쿠폰 정보 가져오기
        Coupon coupon = couponService.couponDetail(couponId);
        System.out.println(coupon.getCoupon_code());
        // Cart 객체에 쿠폰 적용
        Cart cart = this.cartService.findCartByCartId(cartId);
        cart.setCoupon_id(couponId);
        
        String cart_id = cart.getCart_id();
        Integer coupon_id = cart.getCoupon_id();
        System.out.println("coupon_id:["+coupon_id+"], cart_id:["+cart_id+"]");
        
        this.cartService.updateCartCoupon(cart);  // 쿠폰 정보 업데이트
        
        System.out.println(cart.getCart_id() + cart.getUser_id() + cart.getQuantity()
        		 + cart.getIsbn() + cart.getCoupon_id());
        // Usercoupon에 쿠폰 적용 처리
        Usercoupon uc = new Usercoupon();
        uc.setCoupon_id(couponId);
        uc.setUser_id(loginUser);
        uc = this.couponService.getUserCouponDetail(uc);
        this.couponService.applyCoupon(uc);

        // 쿠폰 코드와 할인율을 추가하여 redirect
        ModelAndView mav = new ModelAndView("redirect:/cart");
        return mav;
    }
    
    @PostMapping("/cancelCoupon")
    public ModelAndView cancelCoupon(@RequestParam("cart_id") String cartId, HttpSession session) {
    	String loginUser = (String)session.getAttribute("loginUser");
    	if(loginUser == null) {
    		ModelAndView mav = new ModelAndView("loginFail");
            return mav;
    	}
    	Cart cart = this.cartService.findCartByCartId(cartId);
    	if(cartId != null) {
        	this.cartService.deleteCartCoupon(cartId);
        	Usercoupon uc = new Usercoupon();
            uc.setCoupon_id(cart.getCoupon_id());
            uc.setUser_id(loginUser);
            uc = this.couponService.getUserCouponDetail(uc);
            this.couponService.applyCoupon(uc);
        }
    	ModelAndView mav = new ModelAndView("redirect:/cart");
    	return mav;
    }

    // 구매하기
    @PostMapping("/checkout")
    public ModelAndView checkout(String address,String address_detail, String zipcode,
    		Integer total, HttpSession session) {
        String loginUser = (String) session.getAttribute("loginUser");
        System.out.println("주소 : [" + address + "], 주소상세 : [" + address_detail + "], 우편번호 : ["
        		+ zipcode + "], 총액 : [" + total + "]");
        if (loginUser == null) {
            ModelAndView mav = new ModelAndView("loginFail");
            return mav;
        }
        String count = this.orderService.getMaxOrderId();
        Integer orderId = Integer.parseInt(count) + 1;
        String order_id = orderId.toString();
        Orders orders = new Orders();
        orders.setOrder_id(order_id);
        orders.setUser_id(loginUser);
        orders.setAddress(address);
        orders.setAddress_detail(address_detail);
        orders.setZipcode(zipcode);
        orders.setTotal_price(total);
        this.orderService.insertOrders(orders); // 주문번호 생성 및 추가
        
        List<Cart> cartList = this.cartService.selectCartList(loginUser);        
        for (Cart cart : cartList) {
            Integer odid = Integer.parseInt(this.orderService.getMaxOrderDetailId()) + 1;
            String detail_id = odid.toString();
            int subtotal = 0;
            Orders_detail od = new Orders_detail();
            od.setOrder_detail_id(detail_id);
            od.setOrder_id(order_id);
            od.setIsbn(cart.getIsbn());
            od.setQuantity(cart.getQuantity());
            int bookPrice = cart.getBook().getPrice();
            int quantity = cart.getQuantity();
            System.out.println("쿠폰아이디 : " + cart.getCoupon_id());
            if(cart.getCoupon_id() != null) {
            	od.setCoupon_id(cart.getCoupon_id());
            	Integer cid = cart.getCoupon_id();
                Coupon coupon = this.couponService.couponDetail(cid);
                int discountPercentage = coupon.getDiscount_percentage();
                String coupon_code = coupon.getCoupon_code();
                int discountAmount = bookPrice * discountPercentage / 100;
                int discountedPrice = bookPrice - discountAmount;
                int normalPrice = bookPrice * (quantity - 1);
                subtotal = discountedPrice + normalPrice;
            	od.setSubtotal(subtotal);
            	this.orderService.insertOrdersDetail(od);
            	Integer minusStock = cart.getBook().getStock() - quantity;
            	Book newBook = new Book();
            	newBook.setIsbn(cart.getIsbn()); newBook.setStock(minusStock);
            	this.fieldService.buyBook(newBook);
            } else {
            	od.setCoupon_id(null);
            	subtotal = bookPrice * quantity;
            	od.setSubtotal(subtotal);
            	this.orderService.insertOrdersDetailTwo(od);
            } 
            List<String> catList= this.categoryService.getCatIdFromIsbn(cart.getIsbn());
            for (String cat_id : catList) { // 구매시 선호도 반영해보기.
            	// 동일한 cat_id 보유한지 찾아보기
            	User_pref up = new User_pref();
            	up.setUser_id(loginUser); up.setCat_id(cat_id);
            	User_pref testUp = this.prefService.getUserCatIdByCat(up);
            	Integer score = 0;
            	if(testUp == null) { // 현재 cat_id와 동일한 장르가 선호도목록에 없다
            		score = 5;
            		up.setPref_score(score);
            		this.prefService.insertPref(up); // 현재 로그인된 정보에 새 장르와 +5점 부여
            	} else { // 현재 cat_id와 동일한 장르가 선호도목록에 있다
            		score = testUp.getPref_score() + 5;
            		up.setPref_score(score);
            		this.prefService.updateScore(up); // 기존 점수 + 5점으로 update
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
        } // 조건에 맞다면 사용자의 등급을 올린다.
        this.cartService.deleteUserCart(loginUser);
		
        ModelAndView mav = new ModelAndView("redirect:/index");
        return mav;
    }
    
    
}















