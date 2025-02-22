package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.model.Category;
import com.example.demo.service.CategoryService;

@Controller
public class CategoryController {

    @Autowired
    private CategoryService service;

    // 최상위 카테고리 목록을 가져오는 메소드

    @GetMapping("/categories")
    public String getCategories(Model model) {
    	
        List<Category> categories = service.getTopCategories();  // 최상위 카테고리만 가져옴
        model.addAttribute("categories", categories);
        return "categoryList";  // categoryList.jsp
        
    }

    // 하위 카테고리를 가져오는 메소드
    @GetMapping("/category/sub/{parent_id}")
    @ResponseBody
    public List<Category> getSubCategories(@PathVariable("parent_id") String parentId) {        
        return service.getSubCategories(parentId);  // JSON으로 하위 카테고리 반환
    }
    
    @PostMapping("/category/delete")
    @ResponseBody
    public Map<String, Object> deleteCategory( @RequestParam("cat_id") String categoryId) {
        Map<String, Object> response = new HashMap<>();        
        try {
            // 카테고리 삭제 로직
        	this.service.deleteCategory(categoryId);
            response.put("success", true);
        } catch (Exception e) {
            response.put("success", false);
            e.printStackTrace();
        }
        return response;
    }
    @PostMapping("/category/add")
    @ResponseBody
    public Map<String, Object> addCategory(@RequestParam("parent_id") String parentId, 
                                           @RequestParam("cat_name") String categoryName) {
        Map<String, Object> response = new HashMap<>();
        try {
            // 카테고리 추가 로직
        	Integer cat_id = this.service.getMaxHaWeuiCategoryId();//카테고리id자동증가
        	Category newCategory = new Category();
        	newCategory.setCat_id(cat_id.toString());
        	newCategory.setParent_id(parentId);
        	newCategory.setCat_name(categoryName);
            this.service.insertCategory(newCategory);
            response.put("success", true);
        } catch (Exception e) {
            response.put("success", false);
            e.printStackTrace();
        }
        return response;
    }
    
    @GetMapping("/category/checkSubCategories")
    @ResponseBody
    public Map<String, Object> checkSubCategories(@RequestParam("cat_id") String catId) {
        Map<String, Object> response = new HashMap<>();
        boolean hasSubCategories = this.service.checkSubCategories(catId);
        response.put("hasSubCategories", hasSubCategories);
        return response;
    }

}
