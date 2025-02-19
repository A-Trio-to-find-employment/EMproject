package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.PreferenceTest;
import com.example.demo.model.UserPreference;

@Mapper
public interface PreferenceMapper {
	
	Long getMaxPrefId();
	void insertPref(PreferenceTest preferenceTest);
	void insertUserPref(UserPreference userPreference);
	List<Long> getPrefIdByUser(String userId);
	UserPreference getUserPref(Long pref_id);
}
