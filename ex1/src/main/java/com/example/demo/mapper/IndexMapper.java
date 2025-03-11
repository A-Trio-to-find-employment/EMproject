package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.StartEnd;

@Mapper
public interface IndexMapper {
	List<Long> getTop4Books();
	List<Long> getTop20Books(StartEnd se);
	Integer getTopCount();
	List<Long> getTop4NewBook();
}
