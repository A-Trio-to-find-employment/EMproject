package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.JJimMapper;
import com.example.demo.model.Book;
import com.example.demo.model.JJim;
import com.example.demo.model.StartEndKey;
@Service
public class JJimService {
	@Autowired
	private JJimMapper mapper;
	
	public void insertjjim(JJim jjim) {
		this.mapper.insertjjim(jjim);
	}
	public void deleteJjim(JJim jjim) {
		this.mapper.deleteJjim(jjim);
	}
	public Integer isBookLiked(JJim jjim) {
		Integer count = this.mapper.isBookLiked(jjim);
		return count;
	}
	public Integer getLikeCount(Long isnb) {
		Integer count =  this.mapper.getLikeCount(isnb);
		return count;
	}
	public List<Book> getorderByjjim(StartEndKey key) {
		return this.mapper.getorderByjjim(key);
	}
	public Integer getjjimCount(String user_id) {
		return this.mapper.getjjimCount(user_id);
	}
	public void deleteJjimisbn(Long isbn) {
		this.mapper.deleteJjimisbn(isbn);
	}
}
