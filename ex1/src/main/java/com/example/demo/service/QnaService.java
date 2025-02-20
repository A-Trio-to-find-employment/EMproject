package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.QnaMapper;
import com.example.demo.model.Qna;
import com.example.demo.model.QnaBoard;

@Service
public class QnaService {
	@Autowired
	private QnaMapper mapper;
	
	public List<QnaBoard> getQnaBoard(){
		return this.mapper.getQnaBoard();
	}
	public Integer getMaxWid() {
		Integer max = this.mapper.getMaxWid();
		if(max == null) return 0;
		else return max; 
	}
	public void putQna(Qna qna) {
		this.mapper.putQna(qna);
	}
}
