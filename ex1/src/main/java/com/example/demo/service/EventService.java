package com.example.demo.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.EventMapper;
import com.example.demo.model.Event;
import com.example.demo.model.StartEndKey;

@Service
public class EventService {
	@Autowired
	private EventMapper eventMapper;
	
	public ArrayList<Event> getEventList(StartEndKey sek){
		ArrayList<Event> eventList = this.eventMapper.getEventList(sek);
		return eventList;
	}
	public ArrayList<Event> AdminGetEventList(StartEndKey sek){
		ArrayList<Event> eventList = this.eventMapper.AdminGetEventList(sek);
		return eventList;
	}
	
	public Integer getTotalCount() {
		Integer count = this.eventMapper.getTotalCount();
		if(count == null) return 0;
		else return count;
	}
	
	public Event getEventDetail(Long event_code) {
		Event event = this.eventMapper.getEventDetail(event_code);
		return event;
	}
	public void updateevent(Event event) {
		this.eventMapper.updateevent(event);
	}
	public void deleteevent(Long code) {
		this.eventMapper.deleteevent(code);
	}
	public Long maxcount() {
		Long maxEventCode = eventMapper.maxcount();  // 현재 최대 event_code 값을 가져옴
        if (maxEventCode == null) {
            return 20000000001L;  // 최대 값이 없으면, 20000000001부터 시작
        } else {
            return maxEventCode + 1;  // 최대 값에 1을 더한 값을 반환
        }
	}
	public void insertevent(Event event) {
		this.eventMapper.insertevent(event);
	}
	public void deleteCouponEvent(Integer coupon_id) {
		this.eventMapper.deleteCouponEvent(coupon_id);
	}
	public void deleteUserCoupon(Integer coupon_id) {
		this.eventMapper.deleteUserCoupon(coupon_id);
	}
}
