package com.fairplay.domain;

import java.time.LocalDateTime;

public class Schedule {
	private int memberId;
	private int groupId;
	private String title;
	private LocalDateTime startDate; 
    private LocalDateTime endDate;
	private String visibility;
	private String memo;
	
	public Schedule() {}



	public Schedule(int memberId, int groupId, String title, LocalDateTime startDate, LocalDateTime endDate,
			String visibility, String memo) {
		super();
		this.memberId = memberId;
		this.groupId = groupId;
		this.title = title;
		this.startDate = startDate;
		this.endDate = endDate;
		this.visibility = visibility;
		this.memo = memo;
	}



	public int getMemberId() {
		return memberId;
	}

	public void setMemberId(int memberId) {
		this.memberId = memberId;
	}

	public int getGroupId() {
		return groupId;
	}

	public void setGroupId(int groupId) {
		this.groupId = groupId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public LocalDateTime getStartDate() {
		return startDate;
	}

	public void setStartDate(LocalDateTime startDate) {
		this.startDate = startDate;
	}

	public LocalDateTime getEndDate() {
		return endDate;
	}

	public void setEndDate(LocalDateTime endDate) {
		this.endDate = endDate;
	}

	public String getVisibility() {
		return visibility;
	}

	public void setVisibility(String visibility) {
		this.visibility = visibility;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}
}
