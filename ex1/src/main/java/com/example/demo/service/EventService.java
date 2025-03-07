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
}
