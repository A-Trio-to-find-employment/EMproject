package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.QnaMapper;
import com.example.demo.model.Qna;
import com.example.demo.model.QnaAns;
import com.example.demo.model.QnaBoard;
import com.example.demo.model.StartEnd;

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
	public Integer getTotal(String user_id) {
		return this.mapper.getTotal(user_id);
	}
	public List<Qna> qnaList(StartEnd st){
		return this.mapper.qnaList(st);
	}
	public Qna getqnaList(Integer qna_number) {
		return this.mapper.getqnaList(qna_number);
	}
	public String getAnsContent(Integer qna_number) {
		return this.mapper.getAnsContent(qna_number);
	}
	public void deleteqna(Integer qna_number) {
		this.mapper.deleteqna(qna_number);
	}
	
	public void deleteans(Integer qna_number) {
		this.mapper.deleteans(qna_number);
	}
}
