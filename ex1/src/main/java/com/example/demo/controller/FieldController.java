package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.model.Book;
import com.example.demo.model.Category;
import com.example.demo.service.FieldService;

@Controller
public class FieldController {
	@Autowired
	private FieldService service;
	
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
	public ModelAndView fields(String cat_id, String sort) {
        ModelAndView mav = new ModelAndView("fieldlayout");
        List<Book> bookLists = service.getorderByBook(cat_id, sort); // 정렬된 도서 목록 가져오기        
        String categoryName = service.getCategoriesName(cat_id); // 카테고리 이름 가져오기        
        mav.addObject("bookList", bookLists); // 도서 목록 전달        
        mav.addObject("cat_name", categoryName); // 카테고리 이름 전달
        mav.addObject("BODY", "booklist.jsp"); // booklist.jsp를 BODY로 설정
        
        return mav;
	}
	@RequestMapping(value = "bookdetail.html")
	public ModelAndView bookdetail(Long isbn) {
		ModelAndView mav = new ModelAndView("fieldlayout");
	    // 1. 책 정보 가져오기
		 Book book = service.getBookDetail(isbn);
		List<String> bookcategory = book.getCategoryPath(); 
	    mav.addObject("BODY", "bookdetail.jsp"); // bookdetail.jsp 로드
	    mav.addObject("book", book); // 책 정보 추가
	    mav.addObject("bookcategory", bookcategory); // 책 정보 추가
	    
	    return mav;
	}
	
	 
}
