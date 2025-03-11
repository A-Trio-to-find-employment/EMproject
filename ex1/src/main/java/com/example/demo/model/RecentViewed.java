package com.example.demo.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class RecentViewed {
	private Long recentViewId;
    private String userId;
    private Long isbn;
    private String viewedAt;
}
