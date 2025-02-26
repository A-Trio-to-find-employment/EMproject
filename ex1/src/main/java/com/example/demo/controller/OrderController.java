package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.MyOrders;
import com.example.demo.model.StartEnd;
import com.example.demo.service.OrderService;

import jakarta.servlet.http.HttpSession;

@Controller
public class OrderController {

    @Autowired
    private OrderService orderservice;
    
    @GetMapping(value="/order/orderlist.html")
    public ModelAndView orderList(Integer PAGE_NUM, HttpSession session, String period) {
        ModelAndView mav = new ModelAndView("orderlist");
        
        // 로그인된 사용자 정보 가져오기
        String user = (String) session.getAttribute("loginUser");
        
        int currentPage = 1;
        // 페이지 번호가 null이 아니면 currentPage 설정
        if (PAGE_NUM != null) currentPage = PAGE_NUM;

        // 사용자의 주문 갯수 조회                      		
        int count = this.orderservice.getTotal(user);  // 갯수를 검색
        int startRow = 0; 
        int endRow = 0; 
        int totalPageCount = 0;
        
        if (count > -1) {
            totalPageCount = count / 5;
            if (count % 5 != 0) totalPageCount++;
            startRow = (currentPage - 1) * 5;
            endRow = ((currentPage - 1) * 5) + 6;
            if (endRow > count) endRow = count;
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
        mav.addObject("TOTAL", count);
        mav.addObject("currentPage", currentPage);
        mav.addObject("LIST", myorderlist);  // 주문 목록을 JSP로 전달
        mav.addObject("pageCount", totalPageCount);
        
        return mav;  // JSP로 데이터 반환
    }
    
    @RequestMapping("/cancel")
    public String cancelOrder( String orderDetailId) {
        // 주문 상태와 배송 상태를 취소로 변경
    	this.orderservice.cancelDelivery(orderDetailId);
        this.orderservice.cancelOrder(orderDetailId);        
         
        // 취소 후 주문 내역 페이지로 리디렉션
        return "redirect:/order/orderlist.html";
    }
    @PostMapping("/requestAction")
    public ModelAndView returnRequest( String orderDetailId,String BTN) {
    	ModelAndView mav = new ModelAndView();
    	if(BTN.equals("반품")) {    		
    		mav.setViewName("return");    		
    	}else if(BTN.equals("교환")) {    		
    		mav.setViewName("exchange");    	
    	}
        return mav;
    }
    
}

