package com.fairplay.domain;

public class TodoSimple {
	private Integer id;
	private String title;
	private String nickname;
	
	public TodoSimple() {}
	public TodoSimple(Integer id, String title, String nickname) {
		super();
		this.id = id;
		this.title = title;
		this.nickname = nickname;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	
	
}
