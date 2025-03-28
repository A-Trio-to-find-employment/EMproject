package com.example.demo.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

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

    String getCategoryPath(@Param("cat_id") String catId);
	String findCategoryPathsById(@Param("catId") String catId);
	void addInfoCategory(BookCategories bookcat);
	String getGoodsTitle(Long isbn);
	
	List<String> getCategoryByIsbn(Long isbn);
	void updateInfoCategory(BookCategories bookcat);
	void updateBookAuthors(Long isbn, String author);
	void deleteBookAuthors(Long isbn);
	void deleteCatInfo(Long isbn);
	void deleteGoods(Long isbn);
	Integer getReplyCount(Integer review_id);
	
	void deleteCategoriesByIsbn(@Param("isbn") Long isbn, 
			@Param("categoriesToDelete") List<String> categoriesToDelete);
	Integer getGoodsCountList(String book_title);
	Integer checkBookCategoryExists(Long isbn, String catId);
}
