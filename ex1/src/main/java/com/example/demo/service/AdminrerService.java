package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.AdminrerMapper;
import com.example.demo.model.MyOrders;
import com.example.demo.model.Return_exchange_refund;
@Service
public class AdminrerService {
		
	@Autowired
	private AdminrerMapper mapper;
	
	public List<Return_exchange_refund> getrer() {
		return this.mapper.getrer();
	}
	public List<Return_exchange_refund> getexchange(){
		return this.mapper.getexchange();
	}
	public MyOrders getRer(String request_id) {
		return this.mapper.getRer(request_id);
	}
	public void seungin(String detailid) {
		this.mapper.seungin(detailid);
	}
	public void seunginreturn(String detailid) {
		this.mapper.seunginreturn(detailid);
	}
	public void seunginexchange(String detailid) {
		this.mapper.seunginexchange(detailid);
	}
}
