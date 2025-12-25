package com.fairplay.domain;

public class Schedule {
	private int id;
  private int memberId;
  private int groupId;
  private String title;
  private String memo;
  private String scheduleDate;
  private String visibility;
  private String color; 
	
	public Schedule() {}

	public Schedule(int id, int memberId, int groupId, String title, String memo, String scheduleDate,
			String visibility, String color) {
		super();
		this.id = id;
		this.memberId = memberId;
		this.groupId = groupId;
		this.title = title;
		this.memo = memo;
		this.scheduleDate = scheduleDate;
		this.visibility = visibility;
		this.color = color;
	}
	
	public String getStart() {
    return this.scheduleDate;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
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

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public String getScheduleDate() {
		return scheduleDate;
	}

	public void setScheduleDate(String scheduleDate) {
		this.scheduleDate = scheduleDate;
	}

	public String getVisibility() {
		return visibility;
	}

	public void setVisibility(String visibility) {
		this.visibility = visibility;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	@Override
	public String toString() {
		return "Schedule [id=" + id + ", memberId=" + memberId + ", groupId=" + groupId + ", title=" + title + ", memo="
				+ memo + ", scheduleDate=" + scheduleDate + ", visibility=" + visibility + ", color=" + color
				+ "]";
	}

}
