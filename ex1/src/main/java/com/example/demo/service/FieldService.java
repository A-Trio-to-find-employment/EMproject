package com.example.demo.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.FieldMapper;
import com.example.demo.model.Book;
import com.example.demo.model.Category;

@Service
public class FieldService {
	@Autowired
	private FieldMapper mapper;
	 public List<Category> getCategories(String parent_id){//첫번째 하위 카테고리를 받아옴	
		 
		 return this.mapper.getCategories(parent_id);
	 }
	 public boolean countSubCategories(int catId) {
	        return mapper.countSubCategories(catId) > 0;
	    }
	 public String getCategoriesName(String cat_id) {
		 return mapper.getCategoriesName(cat_id);
	 }
	 public Book getBookDetail(Long isbn) {
		 Book book = mapper.getBookDetail(isbn);
	        if (book == null) return null;

	        // 카테고리 경로 가져오기
	        List<String> categoryPath = getCategoryById(book.getIsbn());
	        book.setCategoryPath(categoryPath);

	        return book;
	 }
	 public List<String> getCategoryById(Long isbn) {
		    return mapper.getCategoryById(isbn); // SQL에서 이미 "국내 > 소설 > 장르소설" 형태로 가져옴
		}
	 public List<Book> getorderByBook(String cat_id, String sort) { // 반환 타입 확인!
	        return mapper.getorderByBook(cat_id, sort);
	    }
}
