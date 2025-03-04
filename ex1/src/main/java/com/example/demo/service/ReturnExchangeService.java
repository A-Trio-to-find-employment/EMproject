package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.ReturnExchangeMapper;
import com.example.demo.model.MyOrders;
import com.example.demo.model.Return_exchange_refund;

@Service
public class ReturnExchangeService {
	@Autowired
	private ReturnExchangeMapper mapper;
	
	public Integer getTotal() {
		return this.mapper.getTotal();
	}
	public void UpdateReturnExchangeRefund(String orderdetialid){
		this.mapper.UpdateReturnExchangeRefund(orderdetialid);
	}
	public void UpdateReturnExchangeRefunds(String orderdetialid){
		this.mapper.UpdateReturnExchangeRefunds(orderdetialid);
	}
	public void InsertReturnExchange(Return_exchange_refund rer) {
		this.mapper.InsertReturnExchange(rer);;
	}	 
	public MyOrders getOrders(String orderdetialid) {
		return this.mapper.getOrders(orderdetialid);
	}
	
}
