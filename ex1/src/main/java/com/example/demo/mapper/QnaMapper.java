package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Qna;
import com.example.demo.model.QnaAns;
import com.example.demo.model.QnaBoard;
import com.example.demo.model.StartEnd;

@Mapper
public interface QnaMapper {
	List<QnaBoard> getQnaBoard();
	Integer getMaxWid();
	void putQna(Qna qna);
	Integer getTotal(String user_id);//나의 문의내역 갯 수 검색
	List<Qna> qnaList(StartEnd st);//나의 문의내역 목록을 검색
	
	Qna getqnaList(Integer qna_number);
	String getAnsContent(Integer qna_number);
}
