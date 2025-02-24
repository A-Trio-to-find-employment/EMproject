package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Book;
import com.example.demo.model.Category;


@Mapper
public interface FieldMapper {
	 List<Category> getCategories(String parent_id);//첫번째 하위 카테고리를 받아옴	 
	 int countSubCategories(int cat_id); 	 
	 String getCategoriesName(String cat_id);
	 Book getBookDetail(Long isbn);
	 List<String> getCategoryById(Long isbn);
	 List<Book>getorderByBook(String cat_id, String sort);	 
	 
	 }
