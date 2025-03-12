package com.example.demo.controller;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.service.FieldService;
import com.example.demo.service.RecentViewedService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class RecentViewedController {

    @Autowired
    private RecentViewedService recentViewedService;

    @Autowired
    private FieldService fieldService;

    // 최근 본 상품 목록을 쿠키에 추가하고 처리하는 메서드
    @GetMapping("/bookdetail.html/{isbn}")
    public String addRecentViewed(@PathVariable Long isbn, HttpServletResponse response, HttpServletRequest request) {
        // 해당 ISBN을 최근 본 상품 쿠키에 추가
        recentViewedService.addRecentViewedCookie(response, isbn, request); // request도 전달

        // 책 정보를 조회하는 서비스 메서드
        Book book = fieldService.getBookDetaill(isbn);

        // 책 정보를 모델에 추가하여 뷰로 전달
        return "index";  // "bookDetail"은 책 정보 페이지의 뷰 이름
    }

    // 최근 본 상품 목록을 조회하는 메서드
    @GetMapping("/recentview/list")
    public ModelAndView getRecentViewedList(HttpServletRequest request) {
        // 쿠키에서 최근 본 상품 목록 가져오기
        String recentViewedIsbns = recentViewedService.getRecentViewedFromCookie(request);

        List<Book> books = new ArrayList<>();
        if (!recentViewedIsbns.isEmpty()) {
            // 각 ISBN에 대한 책 정보 조회
            String[] isbnArray = recentViewedIsbns.split(",");
            for (String isbnStr : isbnArray) {
                Long isbn = Long.valueOf(isbnStr);
                Book book = fieldService.getBookDetaill(isbn);  // 책 정보를 조회하는 서비스 메서드
                if (book != null) {
                    books.add(book);
                }
            }
        }

        // ModelAndView 반환
        ModelAndView mav = new ModelAndView("recentViewed");  // "recentViewed"는 최근 본 상품 목록 뷰 이름
        mav.addObject("books", books);  // 조회한 책 리스트를 모델에 추가
        return mav;
    }
}
