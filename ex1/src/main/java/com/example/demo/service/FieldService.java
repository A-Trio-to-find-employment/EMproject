package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.FieldMapper;
import com.example.demo.model.Book;
import com.example.demo.model.BookStatistics;
import com.example.demo.model.Category;
import com.example.demo.model.StartEnd;
import com.example.demo.model.StartEndKey;

@Service
public class FieldService {
	@Autowired
	private FieldMapper mapper;
	 public List<Category> getCategories(String parent_id){//첫번째 하위 카테고리를 받아옴	
		 
		 return this.mapper.getCategories(parent_id);
	 }
	 public boolean countSubCategories(int catId) {
	        return mapper.countSubCategories(catId) > 0;
	    }
	 public String getCategoriesName(String cat_id) {
		 return mapper.getCategoriesName(cat_id);
	 }
	 public void deletebookCategories(Long isbn) {
		 this.mapper.deletebookCategories(isbn);
	 }
	 public Book getBookDetail(Long isbn) {
		 Book book = mapper.getBookDetail(isbn);
	        if (book == null) return null;

	        // 카테고리 경로 가져오기
	        List<String> categoryPath = getCategoryById(book.getIsbn());
	        book.setCategoryPath(categoryPath);

	        return book;
	 }
	 public List<String> getCategoryById(Long isbn) {
		    return mapper.getCategoryById(isbn); // SQL에서 이미 "국내 > 소설 > 장르소설" 형태로 가져옴
		}
	 public List<Book> getorderByBook(StartEnd se) { // 반환 타입 확인!
	        return mapper.getorderByBook(se);
	    }
	 public void buyBook(Book book) {
		 this.mapper.buyBook(book);
	 }
	 public List<BookStatistics> getBookSalesReport(StartEndKey sek){
		 List<BookStatistics> statisList = this.mapper.getBookSalesReport(sek);
		 return statisList;
	 }
	 public List<BookStatistics> getBookSalesReportDT(StartEndKey sek){
		 List<BookStatistics> statisList = this.mapper.getBookSalesReportDT(sek);
		 return statisList;
	 }
	 public List<BookStatistics> getBookSalesReportTR(StartEndKey sek){
		 List<BookStatistics> statisList = this.mapper.getBookSalesReportTR(sek);
		 return statisList;
	 }
	 public List<BookStatistics> getBookSalesReportDR(StartEndKey sek){
		 List<BookStatistics> statisList = this.mapper.getBookSalesReportDR(sek);
		 return statisList;
	 }
	 public List<BookStatistics> getBookSalesSearch(StartEndKey sek){
		 List<BookStatistics> statisList = this.mapper.getBookSalesSearch(sek);
		 return statisList;
	 }
	 public List<BookStatistics> getBookSalesSearchDT(StartEndKey sek){
		 List<BookStatistics> statisList = this.mapper.getBookSalesSearchDT(sek);
		 return statisList;
	 }
	 public List<BookStatistics> getBookSalesSearchTR(StartEndKey sek){
		 List<BookStatistics> statisList = this.mapper.getBookSalesSearchTR(sek);
		 return statisList;
	 }
	 public List<BookStatistics> getBookSalesSearchDR(StartEndKey sek){
		 List<BookStatistics> statisList = this.mapper.getBookSalesSearchDR(sek);
		 return statisList;
	 }
	 public Integer getBookCount() {
		 Integer count = this.mapper.getBookCount();
		 if(count == null) return 0;
		 else return count;
	 }
	 public Integer getBookCountSearch(String SEARCH) {
		 Integer count = this.mapper.getBookCountSearch(SEARCH);
		 if(count == null) return 0;
		 else return count;
	 }
	 public Integer getBookCategoriesCount(String cat_id) {
		 return this.mapper.getBookCategoriesCount(cat_id);
	 }

	 public String getCategoryPathByCatId(String cat_id) {
		 String catPath = this.mapper.getCategoryPathByCatId(cat_id);
		 return catPath;
	 }
	 public Book getBookDetaill(Long isbn) {
		 return this.mapper.getBookDetaill(isbn);

	 }
	 public List<Book>getorderByBookBook(StartEnd se){
		 return this.mapper.getorderByBookBook(se);
	 }
	 public  Integer getbooklistcount(String parent_id) {
		 return this.mapper.getbooklistcount(parent_id);
	 }
}
