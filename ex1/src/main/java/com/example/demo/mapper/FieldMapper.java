package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Category;

@Mapper
public interface FieldMapper {
	 List<Category> getCategories(String parent_id);//첫번째 하위 카테고리를 받아옴
	 
	 int countSubCategories(int cat_id); 
	 
}
