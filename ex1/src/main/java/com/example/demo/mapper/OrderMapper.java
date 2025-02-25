package com.example.demo.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Orders;
import com.example.demo.model.Orders_detail;

@Mapper
public interface OrderMapper {
	String getMaxOrderId();
	String getMaxOrderDetailId();
	void insertOrders(Orders orders);
	void insertOrdersDetail(Orders_detail detail);
}
