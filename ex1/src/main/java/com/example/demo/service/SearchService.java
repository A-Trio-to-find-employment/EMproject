package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.SearchMapper;
import com.example.demo.model.Book;
import com.example.demo.model.Book_author;
import com.example.demo.model.DetailSearch;
import com.example.demo.model.StartEndKey;

@Service
public class SearchService {
	@Autowired
	private SearchMapper searchMapper;
	
	public List<Book> searchBooks(DetailSearch ds){
		List<Book> searchList = this.searchMapper.searchBooks(ds);
		return searchList;
	}
	public Book searchByIsbn(Long ISBN) {
		Book searchedBook = this.searchMapper.searchByIsbn(ISBN);
		return searchedBook;
	}
	public List<Book_author> searchByIsbnAuthor(Long ISBN) {
		List<Book_author> baList = this.searchMapper.searchByIsbnAuthor(ISBN);
		return baList;
	}
	public List<Book> searchBookByTitleCat(StartEndKey sek){
		List<Book> bookList = this.searchMapper.searchBookByTitleCat(sek);
		return bookList;
	}
	public List<Book> searchBookByTitle(StartEndKey sek){
		List<Book> bookList = this.searchMapper.searchBookByTitle(sek);
		return bookList;
	}
	public Integer getTotalCountTitle(String book_title) {
		Integer count = this.searchMapper.getTotalCountTitle(book_title);
		if(count == null) return null;
		else return count;
	}
	public Integer getTotalCountTitleCat(StartEndKey sek) {
		Integer count = this.searchMapper.getTotalCountTitleCat(sek);
		if(count == null) return null;
		else return count;
	}
}
