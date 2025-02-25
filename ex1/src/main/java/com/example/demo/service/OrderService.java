package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.OrderMapper;
import com.example.demo.model.Orders;
import com.example.demo.model.Orders_detail;

@Service	
public class OrderService {
	@Autowired
	private OrderMapper orderMapper;
	
	public String getMaxOrderId() {
		String count = this.orderMapper.getMaxOrderId();
		if(count == null) return "0";
		else return count;
	}
	
	public String getMaxOrderDetailId() {
		String count = this.orderMapper.getMaxOrderDetailId();
		if(count == null) return "0";
		else return count;
	}
	
	public void insertOrders(Orders orders) {
		this.orderMapper.insertOrders(orders);
	}
	
	public void insertOrdersDetail(Orders_detail detail) {
		this.orderMapper.insertOrdersDetail(detail);
	}
}
