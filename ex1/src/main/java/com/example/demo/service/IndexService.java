package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.IndexMapper;
import com.example.demo.model.StartEnd;

@Service
public class IndexService {
	@Autowired
	private IndexMapper indexMapper;
	
	public List<Long> getTop4Books(){
		List<Long> isbnList = this.indexMapper.getTop4Books();
		return isbnList;
	}
	public List<Long> getTop20Books(StartEnd se){
		List<Long> isbnList = this.indexMapper.getTop20Books(se);
		return isbnList;
	}
	public Integer getTopCount() {
		Integer count = this.indexMapper.getTopCount();
		return count;
	}
	public List<Long> getTop4NewBook(){
		List<Long> isbnList = this.indexMapper.getTop4NewBook();
		return isbnList;
	}
}
