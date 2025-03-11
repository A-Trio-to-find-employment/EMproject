package com.example.demo.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.Category;
import com.example.demo.service.CategoryService;
import com.example.demo.service.FieldService;
import com.example.demo.service.FilterService;
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
    
    @RequestMapping(value="/index")
    public ModelAndView index(HttpSession session) {
        ModelAndView mav = new ModelAndView("index");
        
        // 상위 카테고리 정보만 전달 (비동기 방식으로 중/하위 카테고리를 가져올 예정)
        List<Category> topCatList = filterService.getTopCategories();
        mav.addObject("topCatList", topCatList);
        
        // 로그인한 사용자의 추천 도서 관련 로직 (기존 코드 그대로)
        String loginUser = (String) session.getAttribute("loginUser");
        if(loginUser != null) {
            List<String> catList = this.prefService.getUserTopCat(loginUser);
            Map<String, Object> paramMap = new HashMap<>();
            if (catList != null) paramMap.put("userId", loginUser);
            paramMap.put("catIds", catList);
            mav.addObject("catList", null);
            // 최소 1개 이상의 카테고리가 있어야 추천 도서 검색 실행
            if (!catList.isEmpty()) {
                List<Long> recommendedIsbn = this.preferenceService.getRecommendedBooks(paramMap);
                List<Book> recommendedBooks = new ArrayList<Book>();
                for(Long isbn : recommendedIsbn) {
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
    @RequestMapping(value="/getMidCategories", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Category> getMidCategories(@RequestParam("topCatId") String topCatId) {
        return filterService.getMidCategoriesByParentId(topCatId);
    }
    
    // Ajax 요청: 특정 중위 카테고리에 속한 하위 카테고리 목록 반환
    @RequestMapping(value="/getSubCategories", method=RequestMethod.GET, produces=MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public List<Category> getSubCategories(@RequestParam("midCatId") String midCatId) {
        return filterService.getSubCategoriesByParentId(midCatId);
    }
}
