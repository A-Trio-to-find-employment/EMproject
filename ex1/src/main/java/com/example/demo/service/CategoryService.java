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

	public String getCatName(String cat_id) {
		return this.mymapper.getCatName(cat_id);
	}
	public void insertCategory(Category category) {
		this.mymapper.insertCategory(category);
	}
	public void deleteCategory(String cat_id) {
		this.mymapper.deleteCategory(cat_id);
	}
	public Integer getMaxHaWeuiCategoryId() {
		return this.mymapper.getMaxHaWeuiCategoryId();
	}
	public boolean checkSubCategories(String cat_id) {
		 if ("0".equals(cat_id)) {  // cat_id가 0일 경우
		        return false;
		    }
		    
		    Integer count = mymapper.checkSubCategories(cat_id);
		    return count != null && count > 0;
	}
	public List<String> getCatIdFromIsbn(Long isbn){
		List<String> catList = this.mymapper.getCatIdFromIsbn(isbn);
		return catList;
	}
	public List<Category> getsubcategory(){
		return this.mymapper.getsubcategory();
	}
	public List<Category> getAllCategories(){
		List<Category> catList = this.mymapper.getAllCategories();
		return catList;
	}
	public Category getCategoryDetail(String cat_id) {
		Category cat = this.mymapper.getCategoryDetail(cat_id);
		return cat;
	}
}
