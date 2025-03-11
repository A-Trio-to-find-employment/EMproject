package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.FilterMapper;
import com.example.demo.model.Category;

@Service
public class FilterService {
	@Autowired
	private FilterMapper filterMapper;
	
	public List<Category> getTopCategories(){
		List<Category> topCatList = this.filterMapper.getTopCategories();
		return topCatList;
	}
	public List<Category> getMidCategories(){
		List<Category> midCatList = this.filterMapper.getMidCategories();
		return midCatList;
	}
	public List<Category> getSubCategories(){
		List<Category> subCatList = this.filterMapper.getSubCategories();
		return subCatList;
	}
	public List<Category> getMidCategoriesByParentId(String parent_id){
		List<Category> midCatList = this.filterMapper.getMidCategoriesByParentId(parent_id);
		return midCatList;
	}
	public List<Category> getSubCategoriesByParentId(String parent_id){
		List<Category> subCatList = this.filterMapper.getSubCategoriesByParentId(parent_id);
		return subCatList;
	}
}
