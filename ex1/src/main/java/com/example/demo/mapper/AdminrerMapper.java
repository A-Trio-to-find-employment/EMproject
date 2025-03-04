package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.MyOrders;
import com.example.demo.model.Return_exchange_refund;

@Mapper
public interface AdminrerMapper {
	List<Return_exchange_refund> getrer();//신청내역 가져오기
	List<Return_exchange_refund> getexchange();//신청내역 가져오기
	MyOrders getRer(String request_id);
	void seungin(String detailid);
	void seunginreturn(String detailid);
	void seunginexchange(String detailid);
}
