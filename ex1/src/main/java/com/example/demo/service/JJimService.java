package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.JJimMapper;
import com.example.demo.model.JJim;
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
		if(count == null) return 0;
		else return count;
	}
	public Integer getLikeCount(Long isnb) {
		Integer count =  this.mapper.getLikeCount(isnb);
		if(count == null) return 0;
		else return count;
	}
}
