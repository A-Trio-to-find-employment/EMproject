package com.example.demo.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Event;
import com.example.demo.model.StartEndKey;

@Mapper
public interface EventMapper {
	ArrayList<Event> getEventList(StartEndKey sek);
	ArrayList<Event> AdminGetEventList(StartEndKey sek);
	Integer getTotalCount();
	Event getEventDetail(Long event_code);
	void updateevent(Event event);
	void deleteevent(Long code);
	Long maxcount();
	void insertevent(Event event);
}
