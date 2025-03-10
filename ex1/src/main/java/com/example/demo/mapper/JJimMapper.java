package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Book;
import com.example.demo.model.JJim;
import com.example.demo.model.StartEndKey;

@Mapper
public interface JJimMapper {
	void insertjjim(JJim jjim);
	void deleteJjim(JJim jjim);
	Integer isBookLiked(JJim jjim);
	Integer getLikeCount(Long isnb);
	List<Book> getorderByjjim(StartEndKey key);
	Integer getjjimCount(String user_id);
}
