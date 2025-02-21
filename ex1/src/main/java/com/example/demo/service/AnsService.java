package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.AnsMapper;
import com.example.demo.model.Qna;
import com.example.demo.model.QnaAns;
import com.example.demo.model.StartEnd;

@Service
public class AnsService {
	@Autowired
	private AnsMapper mapper;

	public List<Qna> qnaList(StartEnd st){
		return this.mapper.qnaList(st);
	}
	public Qna getqnaList(Integer qna_number) {
		return this.mapper.getqnaList(qna_number);
	}
	public Integer getTotal() {
		return this.mapper.getTotal();
	}
	public void InsertQnaAns(QnaAns ans) {
		this.mapper.InsertQnaAns(ans);
	}
	public void UpdateIndex(Integer qna_number) {
		this.mapper.UpdateIndex(qna_number);
	}
	public Integer getMaxQnaAnsId() {
		  Integer maxId = this.mapper.getMaxQnaAnsId();
		  if(maxId==null) {
			  return 0;
		  }else 
			  return maxId;		  
	}
}
