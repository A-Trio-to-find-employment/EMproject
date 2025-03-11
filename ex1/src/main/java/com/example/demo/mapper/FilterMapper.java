package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Category;

@Mapper
public interface FilterMapper {
	List<Category> getTopCategories();
	List<Category> getMidCategories();
	List<Category> getSubCategories();
	List<Category> getMidCategoriesByParentId(String parent_id);
	List<Category> getSubCategoriesByParentId(String parent_id);
}
