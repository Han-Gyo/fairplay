package com.fairplay.domain;

public class GroupMonthlyScore {
	private Integer groupId;		// 그룹ID
	private String yearMonth;		// 년-월 
	private Integer totalScore;		// 해당 월의 총점
	
	public GroupMonthlyScore() {}
	
	public GroupMonthlyScore(Integer groupId, String yearMonth, Integer totalScore) {
		super();
		this.groupId = groupId;
		this.yearMonth = yearMonth;
		this.totalScore = totalScore;
	}
	public Integer getGroupId() {
		return groupId;
	}
	public void setGroupId(Integer groupId) {
		this.groupId = groupId;
	}
	public String getYearMonth() {
		return yearMonth;
	}
	public void setYearMonth(String yearMonth) {
		this.yearMonth = yearMonth;
	}
	public Integer getTotalScore() {
		return totalScore;
	}
	public void setTotalScore(Integer totalScore) {
		this.totalScore = totalScore;
	}
	@Override
	public String toString() {
		return "GroupMonthlyScore [groupId=" + groupId + ", yearMonth=" + yearMonth + ", totalScore=" + totalScore
				+ "]";
	}
}