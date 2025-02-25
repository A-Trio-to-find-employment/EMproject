package com.example.demo.service;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.GoodsMapper;
import com.example.demo.model.Book;
import com.example.demo.model.BookCategories;
import com.example.demo.model.Category;
import com.example.demo.model.StartEnd;

@Service
public class GoodsService {
	@Autowired
	private GoodsMapper goodsMapper;
	
	public List<Book> getGoodsList(Integer pageNo){
		if(pageNo == null)pageNo = 1;
		int start = (pageNo-1)*5;
		int end = start+6;
		StartEnd se = new StartEnd();
		se.setStart(start);se.setEnd(end);
		return this.goodsMapper.getGoodsList(se);
	}
	public Book getGoodsDetail(Long isbn) {
		Book book = this.goodsMapper.getGoodsDetail(isbn);
		List<String> authors = this.goodsMapper.getBookAuthors(isbn);
		book.setAuthors(String.join(",", authors));
		return book;
	}
	public Integer getGoodsCount() {
		return this.goodsMapper.getGoodsCount();
	}
	public List<Book> getGoodsByName(String title, Integer pageNo){
		if(pageNo == null) pageNo = 1;
		int start = (pageNo - 1) * 5;
		int end = ((pageNo - 1) * 5) + 6;
		StartEnd se = new StartEnd();
		se.setStart(start); se.setEnd(end); se.setTitle(title);
		return this.goodsMapper.getGoodsByName(se);
	}
	public Integer getIsbnDup(Long isbn) {
		return this.goodsMapper.getIsbnDup(isbn);
	}
	public void addGoods(Book book,String selectedCat) {
		book.setCat_id(selectedCat);
		this.goodsMapper.addGoods(book);
		if (book.getAuthors() != null) {
            List<String> authorList = Arrays.asList(book.getAuthors().split(","));
            for (String author : authorList) {
                goodsMapper.addBookAuthors(book.getIsbn(), author);
            }
        }
	}
	public void insertStock(Long isbn, int amount) {
		this.goodsMapper.insertStock(isbn, amount);
	}
	
	public List<Category> getCategoriesByParentId(String parnetId){
		return this.goodsMapper.getCategoriesByParentId(parnetId);
	}
	public String getCategoryPath(String catId) {
		return this.goodsMapper.getCategoryPath(catId);
	}
	public void addInfoCategory(BookCategories bookcat) {
		this.goodsMapper.addInfoCategory(bookcat);
	}
	
}
