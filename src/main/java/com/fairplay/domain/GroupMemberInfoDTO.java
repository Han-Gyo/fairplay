package com.fairplay.domain;
// 멤버 조회 할 때 보여질것들
public class GroupMemberInfoDTO {

	private String nickname;
	private String realName;
	private String role;
	private int totalScore;
	private int weeklyScore;
	private int warningCount;
	private int id;			
	private int memberId;
	private int groupId;	// 그룹 ID -> 추방 시 필요
	
	
	
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public String getRealName() {
		return realName;
	}
	public void setRealName(String realName) {
		this.realName = realName;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public int getTotalScore() {
		return totalScore;
	}
	public void setTotalScore(int totalScore) {
		this.totalScore = totalScore;
	}
	public int getWeeklyScore() {
		return weeklyScore;
	}
	public void setWeeklyScore(int weeklyScore) {
		this.weeklyScore = weeklyScore;
	}
	public int getWarningCount() {
		return warningCount;
	}
	public void setWarningCount(int warningCount) {
		this.warningCount = warningCount;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getGroupId() {
		return groupId;
	}
	public void setGroupId(int groupId) {
		this.groupId = groupId;
	}
	public int getMemberId() {
		return memberId;
	}
	public void setMemberId(int memberId) {
		this.memberId = memberId;
	}
	
	
}
