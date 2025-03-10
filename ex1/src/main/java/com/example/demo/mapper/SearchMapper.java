package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Book;
import com.example.demo.model.Book_author;
import com.example.demo.model.DetailSearch;

@Mapper
public interface SearchMapper {
	List<Book> searchBooks(DetailSearch ds);
	Book searchByIsbn(Long ISBN);
	List<Book_author> searchByIsbnAuthor(Long ISBN);
	List<Book> searchBookByTitleCat(Book book);
	List<Book> searchBookByTitle(String book_title);
}
