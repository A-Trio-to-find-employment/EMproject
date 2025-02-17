package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
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
        System.out.println("Parent ID: " + parentId);  // 로그에 parentId를 출력
        return service.getSubCategories(parentId);  // JSON으로 하위 카테고리 반환
    }
}
