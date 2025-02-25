package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.OrderMapper;
import com.example.demo.model.MyOrders;
import com.example.demo.model.Orders;
import com.example.demo.model.Orders_detail;
import com.example.demo.model.StartEnd;

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
	public List<MyOrders> getMyOrders(StartEnd se){
		return this.orderMapper.getMyOrders(se);
	}
	public Integer getTotal(String user_id) {
		return this.orderMapper.getTotal(user_id);
	}
	public String getCouponName(Integer quponid) {
		return this.orderMapper.getCouponName(quponid);
	}
}
