package com.fairplay.domain;

import java.util.Date;

public class History {
	private int id;                	// 기록 ID
	private int member_id;         	// 회원 ID
	private int todo_id;           	// 할 일 ID
	private Date completed_at;     	// 완료 날짜
	private String photo;          	// 인증 사진
	private String memo;           	// 메모 내용
	private Integer score;         	// 점수
	private boolean check;         	// 확인 여부
	private Integer check_member;  	// 확인한 사람 ID
	private Todo todo;				// Todo 객체 전체
	private Member member;			// Member 객체 전체
	public History() {}
	
	public History(int id, int member_id, int todo_id, Date completed_at, String photo, String memo, int score,
			boolean check, Integer check_member) {
		super();
		this.id = id;
		this.member_id = member_id;
		this.todo_id = todo_id;
		this.completed_at = completed_at;
		this.photo = photo;
		this.memo = memo;
		this.score = score;
		this.check = check;
		this.check_member = check_member;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getMember_id() {
		return member_id;
	}
	public void setMember_id(int member_id) {
		this.member_id = member_id;
	}
	public int getTodo_id() {
		return todo_id;
	}
	public void setTodo_id(int todo_id) {
		this.todo_id = todo_id;
	}
	public Date getCompleted_at() {
		return completed_at;
	}
	public void setCompleted_at(Date completed_at) {
		this.completed_at = completed_at;
	}
	public String getPhoto() {
		return photo;
	}
	public void setPhoto(String photo) {
		this.photo = photo;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public Integer getScore() {
		return score;
	}
	public void setScore(Integer score) {
		this.score = score;
	}
	public boolean isCheck() {
		return check;
	}
	public void setCheck(boolean check) {
		this.check = check;
	}
	public Integer getCheck_member() {
		return check_member;
	}
	public void setCheck_member(Integer check_member) {
		this.check_member = check_member;
	}

	public Todo getTodo() {
		return todo;
	}

	public void setTodo(Todo todo) {
		this.todo = todo;
	}

	public Member getMember() {
		return member;
	}

	public void setMember(Member member) {
		this.member = member;
	}

	@Override
	public String toString() {
		return "History [id=" + id + ", member_id=" + member_id + ", todo_id=" + todo_id + ", completed_at="
				+ completed_at + ", photo=" + photo + ", memo=" + memo + ", score=" + score + ", check=" + check
				+ ", check_member=" + check_member + ", todo=" + todo + ", member=" + member + "]";
	}

}