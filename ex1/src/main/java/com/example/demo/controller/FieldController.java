package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

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
	    return mav;
	}

	@RequestMapping(value = "/booklist.html")//마지막 하위카테고리면 그것을 클릭했을때 상품이 보여짐
	public ModelAndView fields(String cat_id) {
		ModelAndView mav = new ModelAndView();	   
		return mav;
	}
	 
}
