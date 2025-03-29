package com.example.demo.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.GoodsMapper;
import com.example.demo.model.Book;
import com.example.demo.model.BookCategories;
import com.example.demo.model.Category;
import com.example.demo.model.StartEnd;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
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
	public String getCategoryPath(String catId) {
	    return goodsMapper.getCategoryPath(catId);
	}
	public void addInfoCategory(BookCategories bookcat) {
		this.goodsMapper.addInfoCategory(bookcat);
	}
	public void addCategories(Long isbn, List<String> categoriesToAdd) {
		if (categoriesToAdd == null || categoriesToAdd.isEmpty()) return;
	    for (String catId : categoriesToAdd) {
	        BookCategories bookcat = new BookCategories();
	        bookcat.setIsbn(isbn);
	        bookcat.setCat_id(catId);
	        this.goodsMapper.addInfoCategory(bookcat);
	    }
	}
	public List<String> getCategoryByIsbn(Long isbn) {
		return this.goodsMapper.getCategoryByIsbn(isbn);
	}
	public String getGoodsTitle(Long isbn) {
		return this.goodsMapper.getGoodsTitle(isbn);
	}
//	public void updateInfoCategory(Long isbn, List<String> selectedCat) {
//	    List<String> existingCats = goodsMapper.getCategoryByIsbn(isbn); // 현재 저장된 카테고리 가져오기
//
//	    // 삭제할 카테고리 (기존에 있었지만 선택되지 않은 것)
//	    List<String> categoriesToDelete = new ArrayList<>();
//	    for (String catId : existingCats) {
//	        if (!selectedCat.contains(catId)) {
//	            categoriesToDelete.add(catId);
//	        }
//	    }
//	    // 추가할 카테고리 (기존에 없는 것만 추가)
//	    List<String> categoriesToAdd = new ArrayList<>();
//	    for (String catId : selectedCat) {
//	        if (!existingCats.contains(catId)) {
//	            categoriesToAdd.add(catId);
//	        }
//	    }
//	    // 기존 것 중에서 삭제할 것만 삭제
//	    if (!categoriesToDelete.isEmpty()) {
//	    	 System.out.println("삭제할 카테고리: " + categoriesToDelete);
//	        goodsMapper.deleteCategoriesByIsbn(isbn, categoriesToDelete);
//	    }else {
//	        System.out.println("삭제할 카테고리가 없음.");
//	    }
//
//	    // 새로운 카테고리 추가
//	    for (String catId : categoriesToAdd) {
//	        BookCategories bookcat = new BookCategories();
//	        bookcat.setIsbn(isbn);
//	        bookcat.setCat_id(catId);
//	        goodsMapper.addInfoCategory(bookcat);
//	    }
//	}
	public void updateInfoCategory(Long isbn, List<String> selectedCat) {
		for(String catId : selectedCat) {
			BookCategories bookcat = new BookCategories();
	        bookcat.setIsbn(isbn);
	        bookcat.setCat_id(catId);
	        goodsMapper.addInfoCategory(bookcat);
		}
	}
//	public void updateGoods(Book book, List<String> selectedCat) {
//	    this.goodsMapper.updateGoods(book);
//	    //기존 저자 삭제
//	    this.goodsMapper.deleteBookAuthors(book.getIsbn());
//	    //수정된 저자 정보 추가
//	    if (book.getAuthors() != null && !book.getAuthors().isEmpty()) {
//	        List<String> authorList = Arrays.asList(book.getAuthors().split(","));
//	        for (String author : authorList) {
//	            goodsMapper.addBookAuthors(book.getIsbn(), author.trim());
//	        }
//	    }
//	}
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
//	    List<String> existingCats = this.goodsMapper.getCategoryByIsbn(book.getIsbn());
//	    System.out.println("📌 기존 카테고리: " + existingCats);
//	    System.out.println("📌 선택된 카테고리: " + selectedCat);
//	    List<String> categoriesToDelete = new ArrayList<>();
//	    List<String> categoriesToAdd = new ArrayList<>();
//
//	    // 기존 카테고리 중에서 유지된 것 제외하고 삭제할 것 찾기
//	    for (String existingCat : existingCats) {
//	        if (!selectedCat.contains(existingCat)) {  
//	            categoriesToDelete.add(existingCat);
//	        }
//	    }
//
//	    // 선택된 카테고리 중에서 기존에 없던 것만 추가
//	    for (String catId : selectedCat) {
//	        if (!existingCats.contains(catId)) {  
//	            categoriesToAdd.add(catId);
//	        }
//	    }
//
//	    // 🔥 로그 출력 (디버깅용)
//	    System.out.println("🛑 삭제할 카테고리: " + categoriesToDelete);
//	    System.out.println("✅ 추가할 카테고리: " + categoriesToAdd);
//
//	    // 삭제 실행 (삭제할 게 있을 때만 실행)
//	    if (!categoriesToDelete.isEmpty()) {
//	        goodsMapper.deleteCategoriesByIsbn(book.getIsbn(), categoriesToDelete);
//	    }
//
//	    // 추가 실행
//	    for (String catId : categoriesToAdd) {
//	        BookCategories bookcat = new BookCategories();
//	        bookcat.setIsbn(book.getIsbn());
//	        bookcat.setCat_id(catId);
//	        goodsMapper.addInfoCategory(bookcat);
//	    }
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
	
	public void deleteCategoriesByIsbn(Long isbn, List<String> categoriesToDelete) {
        if (categoriesToDelete == null || categoriesToDelete.isEmpty()) 
        	return; // 삭제할 것이 없으면 실행하지 않음
        
        this.goodsMapper.deleteCategoriesByIsbn(isbn, categoriesToDelete);
    }
	public Integer getGoodsCountList(String book_title) {
		return this.goodsMapper.getGoodsCountList(book_title);
	}
	public Integer checkBookCategoryExists(Long isbn, String catId) {
		return this.goodsMapper.checkBookCategoryExists(isbn, catId);
	}
}
