package com.example.demo.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface WelcomeMapper {
	List<Map<String, Object>> getCategoryPurchaseStats(String user_id);
	List<Map<String, Object>> getMonthlyPurchaseStats(String user_id);
}
