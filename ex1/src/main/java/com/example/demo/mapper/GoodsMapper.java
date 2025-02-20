package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Book;
import com.example.demo.model.StartEnd;

@Mapper
public interface GoodsMapper {
	List<Book> getGoodsList(StartEnd se);
	Book getGoodsDetail(Long isbn); 
}
