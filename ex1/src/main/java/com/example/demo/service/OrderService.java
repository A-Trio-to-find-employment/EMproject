package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.OrderMapper;
import com.example.demo.model.DeliveryModel;
import com.example.demo.model.MyOrders;
import com.example.demo.model.Orders;
import com.example.demo.model.Orders_detail;
import com.example.demo.model.StartEnd;
import com.example.demo.model.StartEndKey;

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
	
	public void insertOrdersDetailTwo(Orders_detail detail) {
		this.orderMapper.insertOrdersDetailTwo(detail);
	}
	public void cancelDelivery(String detail_id) {
		this.orderMapper.cancelDelivery(detail_id);
	}
	public void cancelOrder(String detail_id) {
		this.orderMapper.cancelOrder(detail_id);
	}
	public MyOrders getUsers(String detial_id) {
		return this.orderMapper.getUsers(detial_id);
	}
	public List<DeliveryModel> getDeliveryListWithStatus(StartEndKey sek){
		List<DeliveryModel> orderList = this.orderMapper.getDeliveryListWithStatus(sek);
		return orderList;
	}
	public List<DeliveryModel> getDeliveryListWithoutStatus(StartEndKey sek){
		List<DeliveryModel> orderList = this.orderMapper.getDeliveryListWithoutStatus(sek);
		return orderList;
	}
	public Integer getOrderDetailCountDeliv(Integer count) {
		Integer delivCount = this.orderMapper.getOrderDetailCountDeliv(count);
		if(delivCount == null) return 0;
		else return delivCount;
	}
	public Integer getOrderDetailCount() {
		Integer delivCount = this.orderMapper.getOrderDetailCount();
		if(delivCount == null) return 0;
		else return delivCount;
	}
	
	public void updateDeliveryCount(DeliveryModel dm) {
		this.orderMapper.updateDeliveryCount(dm);
	}
}
