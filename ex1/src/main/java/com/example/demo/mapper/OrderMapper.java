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
	void cancelDelivery(String detail_id);
	void cancelOrder(String detail_id);
	void insertOrdersDetailTwo(Orders_detail detail);

	MyOrders getUsers(String detial_id);
	
	List<DeliveryModel> getDeliveryListWithStatus(StartEndKey sek);
	List<DeliveryModel> getDeliveryListWithoutStatus(StartEndKey sek);
	Integer getOrderDetailCountDeliv(Integer count);
	Integer getOrderDetailCount();
	
	void updateDeliveryCount(DeliveryModel dm);
	void nullisbn(Long isbn);
	Orders_detail findOdByOdId(String order_detail_id);
}
