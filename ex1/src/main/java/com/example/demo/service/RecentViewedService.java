package com.example.demo.service;

import org.springframework.stereotype.Service;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Service
public class RecentViewedService {

    // 쿠키에서 최근 본 상품 목록을 가져오는 메서드
    public String getRecentViewedFromCookie(HttpServletRequest request) {
        String cookieValue = "";
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("recentViewed".equals(cookie.getName())) {
                    cookieValue = cookie.getValue();
                    break;
                }
            }
        }
        return cookieValue;  // 쿠키에 저장된 ISBN 목록 반환 (없으면 빈 문자열)
    }

    // 최근 본 상품 쿠키에 ISBN을 추가하는 메서드
    public void addRecentViewedCookie(HttpServletResponse response, Long isbn, HttpServletRequest request) {
        String cookieValue = getRecentViewedFromCookie(request);  // request 객체를 사용하여 기존 쿠키 값 가져오기

        // 쿠키에 해당 ISBN이 없다면 새로 추가
        if (!cookieValue.contains(String.valueOf(isbn))) {
            // 최근 5개까지만 저장하도록 제한
            if (cookieValue.split(",").length >= 5) {
                cookieValue = cookieValue.substring(cookieValue.indexOf(",") + 1);  // 오래된 값 제거
            }
            cookieValue += (cookieValue.isEmpty() ? "" : ",") + isbn;  // 새 ISBN 추가

            // 쿠키 생성
            Cookie recentViewedCookie = new Cookie("recentViewed", cookieValue);
            recentViewedCookie.setMaxAge(60 * 10);  // 유효기간 10분 (600초)
            recentViewedCookie.setPath("/");  // 모든 경로에서 접근 가능
            response.addCookie(recentViewedCookie);  // 쿠키 저장
        }
    }

}
