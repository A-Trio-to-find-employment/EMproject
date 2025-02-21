package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Qna;
import com.example.demo.model.QnaAns;
import com.example.demo.model.QnaBoard;
import com.example.demo.model.StartEnd;

@Mapper
public interface AnsMapper {	
	List<Qna> qnaList(StartEnd st);// 문의내역 목록을 검색	
	Integer getTotal();//문의내역 갯 수 검색
	Qna getqnaList(Integer qna_number);
	void InsertQnaAns(QnaAns ans);
	void UpdateIndex(Integer qna_number);
	 Integer getMaxQnaAnsId();
}
