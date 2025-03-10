package com.example.demo.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.JJim;

@Mapper
public interface JJimMapper {
	void insertjjim(JJim jjim);
	void deleteJjim(JJim jjim);
	Integer isBookLiked(JJim jjim);
	Integer getLikeCount(Long isnb);
}
