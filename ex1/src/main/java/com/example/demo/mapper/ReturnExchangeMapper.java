package com.example.demo.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.MyOrders;
import com.example.demo.model.Return_exchange_refund;

@Mapper
public interface ReturnExchangeMapper {
	Integer getTotal();
	void UpdateReturnExchangeRefund(String orderdetialid);
	void UpdateReturnExchangeRefunds(String orderdetialid);
	void InsertReturnExchange(Return_exchange_refund rer);	 
	MyOrders getOrders(String orderdetialid);
}
