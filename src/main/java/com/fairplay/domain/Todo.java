package com.fairplay.domain;

import java.util.Date;

public class Todo {
	private int id; 						// 할 일 고유 ID
	private int group_id; 					// 소속 그룹 ID
	private String title; 					// 할 일 내용
	private Integer assigned_to; 			// 담당자 ID 
	private String status;        			// 🔥 상태: "신청완료", "미신청"
	private Date due_date; 					// 마감 기한
	private boolean completed; 				// 완료 여부 (기본값: false)
	private int difficulty_point; 			// 노동 강도 (1~5점)
	
	// 기본 생성자
	public Todo() {}
	
	// 전체 필드 포함 생성자
	public Todo(int id, int group_id, String title, Integer assigned_to, Date due_date, boolean completed,
		int difficulty_point) {
		super();
		this.id = id;
		this.group_id = group_id;
		this.title = title;
		this.assigned_to = assigned_to;
		this.due_date = due_date;
		this.completed = completed;
		this.difficulty_point = difficulty_point;
	}
	
	// Getter & Setter
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
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
	public Integer getAssigned_to() {
		return assigned_to;
	}
	public void setAssigned_to(Integer assigned_to) {
		this.assigned_to = assigned_to;
	}
	public String getStatus() {
		return status;
	}
	
	public void setStatus(String status) {
		this.status = status;
	}
	public Date getDue_date() {
		return due_date;
	}
	public void setDue_date(Date due_date) {
		this.due_date = due_date;
	}
	public boolean isCompleted() {
		return completed;
	}
	public void setCompleted(boolean completed) {
		this.completed = completed;
	}
	public int getDifficulty_point() {
		return difficulty_point;
	}
	public void setDifficulty_point(int difficulty_point) {
		this.difficulty_point = difficulty_point;
	}

	@Override
	public String toString() {
		return "Todo [id=" + id + ", group_id=" + group_id + ", title=" + title + ", assigned_to=" + assigned_to
				+ ", status=" + status + ", due_date=" + due_date + ", completed=" + completed + ", difficulty_point="
				+ difficulty_point + "]";
	}
	
}