package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Book;
import com.example.demo.model.Category;
import com.example.demo.model.StartEnd;

@Mapper
public interface GoodsMapper {
	List<Book> getGoodsList(StartEnd se);
	Book getGoodsDetail(Long isbn); 
	Integer getGoodsCount();
	List<Book> getGoodsByName(StartEnd se);
	void updateGoods(Book book);
	void addGoods(Book book);
	Integer getIsbnDup(Long isbn);
    void addBookAuthors(Long isbn, String author);
    List<String> getBookAuthors(Long isbn);
	
    List<Category> getCategoriesByParentId(String parentId);
	String getCategoryPath(String catId);
}
