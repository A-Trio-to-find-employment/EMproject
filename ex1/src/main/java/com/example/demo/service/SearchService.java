package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.SearchMapper;
import com.example.demo.model.Book;
import com.example.demo.model.Book_author;
import com.example.demo.model.DetailSearch;

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
}
