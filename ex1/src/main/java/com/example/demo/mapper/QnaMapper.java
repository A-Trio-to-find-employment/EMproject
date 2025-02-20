package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Qna;
import com.example.demo.model.QnaBoard;

@Mapper
public interface QnaMapper {
	List<QnaBoard> getQnaBoard();
	Integer getMaxWid();
	void putQna(Qna qna);
}
