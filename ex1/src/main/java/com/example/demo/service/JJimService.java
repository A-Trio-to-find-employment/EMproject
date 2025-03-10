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
		return this.mapper.isBookLiked(jjim);
	}
	public Integer getLikeCount(Long isnb) {
		return this.mapper.getLikeCount(isnb);
	}
}
