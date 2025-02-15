package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.MyMapper;
import com.example.demo.model.Category;

@Service
public class CategoryService {
	@Autowired
	private MyMapper mymapper;
	 public List<Category> getTopCategories(){		 
		 return mymapper.getTopCategories();
	 }
	    
	 public List<Category> getSubCategories(String parentId){
		 return this.mymapper.getSubCategories(parentId);
	 }


}
