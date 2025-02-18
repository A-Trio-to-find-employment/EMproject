package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.FieldMapper;
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
}
