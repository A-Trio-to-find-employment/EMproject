package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.WelcomeMapper;

@Service
public class WelcomeService {
	@Autowired
	private WelcomeMapper welcomeMapper;
	
	public List<Map<String, Object>> getCategoryPurchaseStats(String user_id){
		List<Map<String, Object>> catPurchaseList = this.welcomeMapper.getCategoryPurchaseStats(user_id);
		return catPurchaseList;
	}
	public List<Map<String, Object>> getMonthlyPurchaseStats(String user_id){
		List<Map<String, Object>> monPurchaseList = this.welcomeMapper.getMonthlyPurchaseStats(user_id);
		return monPurchaseList;
	}
}
