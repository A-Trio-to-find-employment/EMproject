package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Category;

@Mapper
public interface MyMapper {
	List<Category> getTopCategories();// 특정 카테고리의 하위 카테고리 조회	    
	List<Category> getSubCategories(String parentId);	    
	List<Category> getAllCategories(); // 모든 카테고리 조회	
	String getCatName(String cat_id);
	void insertCategory(Category category);
	void deleteCategory(String cat_id);
	Integer getMaxHaWeuiCategoryId();	
	Integer checkSubCategories(String cat_id); 
	List<String> getCatIdFromIsbn(Long isbn);
	    
	
	
	
}
