package com.fairplay.domain;

import java.time.LocalDate;

public class Schedule {
	private int member_id;
	private int group_id;
	private String title;
	private LocalDate date;
	private String visibility;
	
	public Schedule() {}
	
	public Schedule(int member_id, int group_id, String title, LocalDate date, String visibility) {
		super();
		this.member_id = member_id;
		this.group_id = group_id;
		this.title = title;
		this.date = date;
		this.visibility = visibility;
	}
	
	public int getMember_id() {
		return member_id;
	}
	public void setMember_id(int member_id) {
		this.member_id = member_id;
	}
	public int getGroup_id() {
		return group_id;
	}
	public void setGroup_id(int group_id) {
		this.group_id = group_id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public LocalDate getDate() {
		return date;
	}
	public void setDate(LocalDate date) {
		this.date = date;
	}
	public String getVisibility() {
		return visibility;
	}
	public void setVisibility(String visibility) {
		this.visibility = visibility;
	}
}
