package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.DeliveryModel;
import com.example.demo.model.MyOrders;
import com.example.demo.model.Orders;
import com.example.demo.model.Orders_detail;
import com.example.demo.model.StartEnd;
import com.example.demo.model.StartEndKey;

@Mapper
public interface OrderMapper {
	String getMaxOrderId();
	String getMaxOrderDetailId();
	void insertOrders(Orders orders);
	void insertOrdersDetail(Orders_detail detail);

	List<MyOrders> getMyOrders(StartEnd se);
	Integer getTotal(String user_id);
	String getCouponName(Integer quponid);

	void insertOrdersDetailTwo(Orders_detail detail);
	
	List<DeliveryModel> getDeliveryListWithStatus(StartEndKey sek);
	List<DeliveryModel> getDeliveryListWithoutStatus(StartEndKey sek);
	Integer getOrderDetailCountDeliv(Integer count);
	Integer getOrderDetailCount();
	
	void updateDeliveryCount(DeliveryModel dm);
}
