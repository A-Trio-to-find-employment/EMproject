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
	public void addGoods(Book book) {
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
	public String getCategoryPath(String catIds) {
		return this.goodsMapper.getCategoryPath(catIds);
	}
	public void addInfoCategory(BookCategories bookcat) {
		this.goodsMapper.addInfoCategory(bookcat);
	}
	public String getCategoryByIsbn(Long isbn) {
		return this.goodsMapper.getCategoryByIsbn(isbn);
	}
	public String getGoodsTitle(Long isbn) {
		return this.goodsMapper.getGoodsTitle(isbn);
	}
	public void updateInfoCategory(BookCategories bookcat) {
		this.goodsMapper.updateInfoCategory(bookcat);
	}
	public void updateGoods(Book book) {
	    this.goodsMapper.updateGoods(book);
	    //기존 저자 삭제
	    this.goodsMapper.deleteBookAuthors(book.getIsbn());
	    //수정된 저자 정보 추가
	    if (book.getAuthors() != null && !book.getAuthors().isEmpty()) {
	        List<String> authorList = Arrays.asList(book.getAuthors().split(","));
	        for (String author : authorList) {
	            goodsMapper.addBookAuthors(book.getIsbn(), author.trim());
	        }
	    }
	}
	public void deleteGoods(Long isbn) {
		this.goodsMapper.deleteBookAuthors(isbn);
		this.goodsMapper.deleteCatInfo(isbn);
		this.goodsMapper.deleteGoods(isbn);
	}
	public Integer getReplyCount(Integer review_id) {
		return this.goodsMapper.getReplyCount(review_id);
	}
	public void deleteBookAuthors(Long isbn) {
		this.goodsMapper.deleteBookAuthors(isbn);
	}
	public void deleteCatInfo(Long isbn) {
		this.goodsMapper.deleteCatInfo(isbn);
	}
}
