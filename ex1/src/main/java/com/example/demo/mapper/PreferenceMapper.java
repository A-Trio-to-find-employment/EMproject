package com.example.demo.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.PreferenceTest;
import com.example.demo.model.UserPreference;

@Mapper
public interface PreferenceMapper {
	// USER_ID와 CAT_ID에 해당하는 PREF_ID를 조회
    Long findPrefByUserId(String userId, String catId);

    // PREF_ID에 해당하는 선호 점수 조회
    Integer findScoreByPref(Long prefId);

    // 선호 점수 업데이트
    void updateScore(UserPreference userPreference);
	Long getMaxPrefId();
	void insertPref(PreferenceTest preferenceTest);
	void insertUserPref(UserPreference userPreference);
	List<Long> getPrefIdByUser(String userId);
	UserPreference getUserPref(Long pref_id);
	void DeleteUserPreference(String cat_id);
}
