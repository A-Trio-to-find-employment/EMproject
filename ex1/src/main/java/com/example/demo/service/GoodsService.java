package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.GoodsMapper;
import com.example.demo.model.Book;
import com.example.demo.model.StartEnd;

@Service
public class GoodsService {
	@Autowired
	private GoodsMapper goodsMapper;
	
	public List<Book> getGoodsList(Integer pageNo){
		if(pageNo == null)pageNo = 1;
		int start = (pageNo-1)*5;
		int end = ((pageNo-1)*5)+6;
		StartEnd se = new StartEnd();
		se.setStart(start);se.setEnd(end);
		return this.goodsMapper.getGoodsList(se);
	}
	public Book getGoodsDetail(Long isbn) {
		return this.goodsMapper.getGoodsDetail(isbn);
	}
}
