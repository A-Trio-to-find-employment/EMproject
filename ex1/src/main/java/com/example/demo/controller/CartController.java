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

import com.example.demo.mapper.FieldMapper;
import com.example.demo.model.Book;
import com.example.demo.model.Cart;
import com.example.demo.model.Coupon;
import com.example.demo.model.Orders;
import com.example.demo.model.Orders_detail;
import com.example.demo.model.PreferenceTest;
import com.example.demo.model.UserPreference;
import com.example.demo.model.Usercoupon;
import com.example.demo.model.Users;
import com.example.demo.service.CartService;
import com.example.demo.service.CouponService;
import com.example.demo.service.LoginService;
import com.example.demo.service.OrderService;
import com.example.demo.service.PreferenceService;

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
    private FieldMapper fieldMapper;
    
    // 장바구니 조회
    @GetMapping
    public ModelAndView CartList(HttpSession session) {
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
            	this.fieldMapper.buyBook(newBook);
            } else {
            	od.setCoupon_id(null);
            	subtotal = bookPrice * quantity;
            	od.setSubtotal(subtotal);
            	this.orderService.insertOrdersDetailTwo(od);
            } 
            List<String> catList= this.fieldMapper.getCategoryById(cart.getIsbn());
            for (String cat_id : catList) {
                // 사용자의 선호도(pref_id) 리스트 가져오기
                List<Long> prefIds = this.preferenceService.getPrefIdByUser(loginUser);
                
                for (Long prefId : prefIds) {
                    // 해당하는 cat_id가 이미 존재하는지 확인
                    UserPreference up = this.preferenceService.getUserPref(prefId);
                    if (! up.getCat_id().equals(cat_id)) {
                        // 선호도가 존재하면 1.2배 증가
                    	Double updatePScore = Math.min(9.9, Math.round(up.getPref_score() * 1.2 * 10.0) / 10.0);
                    	up.setPref_score(updatePScore);
                        this.preferenceService.updateScore(up);
                    } else {
                        // 없으면 새로운 선호도 추가
                        Long newPrefId = this.preferenceService.getMaxPrefId() + 1;
                        PreferenceTest pt = new PreferenceTest();
                        pt.setPref_id(newPrefId); pt.setUser_id(loginUser);
                        this.preferenceService.insertPref(pt);
                        up.setPref_id(newPrefId); up.setCat_id(cat_id); up.setPref_score(1.0);
                        this.preferenceService.insertUserPref(up);
                    }
                }
            }
        }
        cartService.deleteUserCart(loginUser);
        ModelAndView mav = new ModelAndView("redirect:/index");
        return mav;
    }
    
    
}















