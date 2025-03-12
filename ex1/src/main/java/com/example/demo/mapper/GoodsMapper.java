package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Book;
import com.example.demo.model.BookCategories;
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
    void insertStock(Long isbn, int amount);
	void addBookAuthors(Long isbn, String author);
    List<String> getBookAuthors(Long isbn);
    List<Category> getCategoriesByParentId(String parentId);
	String getCategoryPath(String catIds);
	void addInfoCategory(BookCategories bookcat);
	String getGoodsTitle(Long isbn);
	
	String getCategoryByIsbn(Long isbn);
	void updateInfoCategory(BookCategories bookcat);
	void updateBookAuthors(Long isbn, String author);
	void deleteBookAuthors(Long isbn);
	void deleteCatInfo(Long isbn);
	void deleteGoods(Long isbn);
	Integer getReplyCount(Integer review_id);
}
