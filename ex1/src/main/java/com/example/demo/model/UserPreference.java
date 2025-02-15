package com.example.demo.model;

public class UserPreference {
	private Long pref_id;
    private String cat_id;
    private int pref_score;
	public Long getPref_id() {
		return pref_id;
	}
	public void setPref_id(Long pref_id) {
		this.pref_id = pref_id;
	}
	public String getCat_id() {
		return cat_id;
	}
	public void setCat_id(String cat_id) {
		this.cat_id = cat_id;
	}
	public int getPref_score() {
		return pref_score;
	}
	public void setPref_score(int pref_score) {
		this.pref_score = pref_score;
	}

  
}
