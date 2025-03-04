package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.mapper.PreferenceMapper;
import com.example.demo.model.Book;
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
	
    public Double findScoreByPref(Long prefId) {
    	Double score = this.preferenceMapper.findScoreByPref(prefId);
    	return score;
    }
    
    public void updateScore(UserPreference userPreference) {
    	this.preferenceMapper.updateScore(userPreference);
    }
    public void DeleteUserPreference(String cat_id) {//jws가 추가하고 가요 카테고리 지울려면 유저 선호도 조사에 있는거 지워야 합니다.
    	this.preferenceMapper.DeleteUserPreference(cat_id);
    }
    
    public List<UserPreference> getUserTopCat(String user_id) {
    	List<UserPreference> upList = this.preferenceMapper.getUserTopCat(user_id);
    	return upList;
    }
    public List<Long> getRecommendedBooks(Map<String, Object> paramMap) {
        // 선호 카테고리를 기반으로 추천 도서 조회
        List<Long> recommendedBooks = this.preferenceMapper.getRecommendedBooks(paramMap);
        return recommendedBooks;
    }
    public List<Long> getRecommendedBookList(Map<String, Object> paramMap){
    	List<Long> recommendedISBNList = this.preferenceMapper.getRecommendedBooks(paramMap);
        return recommendedISBNList;
    }

}
