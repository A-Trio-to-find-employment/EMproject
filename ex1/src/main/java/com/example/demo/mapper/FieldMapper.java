package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Book;
import com.example.demo.model.BookStatistics;
import com.example.demo.model.Category;
import com.example.demo.model.StartEnd;
import com.example.demo.model.StartEndKey;


@Mapper
public interface FieldMapper {
	 List<Category> getCategories(String parent_id);//첫번째 하위 카테고리를 받아옴	 
	 int countSubCategories(int cat_id); 	 
	 String getCategoriesName(String cat_id);
	 Book getBookDetail(Long isbn);
	 List<String> getCategoryById(Long isbn);
	 List<Book>getorderByBook(StartEnd se);	 
	 void buyBook(Book book);
	 List<BookStatistics> getBookSalesReport(StartEndKey sek);
	 List<BookStatistics> getBookSalesReportDT(StartEndKey sek);
	 List<BookStatistics> getBookSalesReportTR(StartEndKey sek);
	 List<BookStatistics> getBookSalesReportDR(StartEndKey sek);
	 List<BookStatistics> getBookSalesSearch(StartEndKey sek);
	 List<BookStatistics> getBookSalesSearchDT(StartEndKey sek);
	 List<BookStatistics> getBookSalesSearchTR(StartEndKey sek);
	 List<BookStatistics> getBookSalesSearchDR(StartEndKey sek);
	 Integer getBookCount();
	 Integer getBookCountSearch(String SEARCH);
	 Integer getBookCategoriesCount(String cat_id);
	 String getCategoryPathByCatId(String cat_id);
}
