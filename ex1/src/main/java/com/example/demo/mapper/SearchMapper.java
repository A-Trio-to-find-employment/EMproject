package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Book;
import com.example.demo.model.Book_author;
import com.example.demo.model.DetailSearch;
import com.example.demo.model.StartEndKey;

@Mapper
public interface SearchMapper {
	List<Book> searchBooks(DetailSearch ds);
	Book searchByIsbn(Long ISBN);
	List<Book_author> searchByIsbnAuthor(Long ISBN);
	List<Book> searchBookByTitleCat(StartEndKey sek);
	List<Book> searchBookByTitle(StartEndKey sek);
	Integer getTotalCountTitle(String book_title);
	Integer getTotalCountTitleCat(StartEndKey sek);
	Integer countSearchBooks(DetailSearch ds);
}
