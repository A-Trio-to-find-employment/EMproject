package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.PreferenceMapper;
import com.example.demo.model.PreferenceTest;
import com.example.demo.model.UserPreference;

@Service
public class PreferenceService {

    @Autowired
    private PreferenceMapper preferenceMapper;
    
    public Long getMaxPrefId() {
    	Long max = this.preferenceMapper.getMaxPrefId();
    	if(max == null) return (long) 1;
    	else return max + 1;
    }
	public void insertPref(PreferenceTest preferenceTest) {
		this.preferenceMapper.insertPref(preferenceTest);
	}
	public void insertUserPref(UserPreference userPreference) {
		this.preferenceMapper.insertUserPref(userPreference);
	}
	
	public List<Long> getPrefIdByUser(String user_id) {
		List<Long> pref_id = this.preferenceMapper.getPrefIdByUser(user_id);
		return pref_id;
	}
	public UserPreference getUserPref(Long pref_id) {
		UserPreference userPreference = this.preferenceMapper.getUserPref(pref_id);
		return userPreference;
	}
	
	public Long findPrefByUserId(String userId, String catId) {
		Long pref_id = this.preferenceMapper.findPrefByUserId(userId, catId);
		return pref_id;
	}
	
    public Integer findScoreByPref(Long prefId) {
    	Integer score = this.preferenceMapper.findScoreByPref(prefId);
    	return score;
    }
    
    public void updateScore(UserPreference userPreference) {
    	this.preferenceMapper.updateScore(userPreference);
    }

}
