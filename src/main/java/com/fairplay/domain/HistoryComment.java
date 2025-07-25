package com.fairplay.domain;

import java.sql.Date;

public class HistoryComment {
	private int id;             // 댓글 ID
    private int historyId;      // 어떤 히스토리에 대한 댓글인지
    private int memberId;       // 댓글 작성자
    private String content;     // 댓글 내용
    private String nickname;    // 닉네임
    private Date createdAt;     // 생성일
    private Date updatedAt;     // 수정일
    
	public HistoryComment() {}
	
	public HistoryComment(int id, int historyId, int memberId, String content, String nickname, Date createdAt, Date updatedAt) {
		super();
		this.id = id;
		this.historyId = historyId;
		this.memberId = memberId;
		this.content = content;
		this.nickname = nickname;
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getHistoryId() {
		return historyId;
	}
	public void setHistoryId(int historyId) {
		this.historyId = historyId;
	}
	public int getMemberId() {
		return memberId;
	}
	public void setMemberId(int memberId) {
		this.memberId = memberId;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Date getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
	public Date getUpdatedAt() {
		return updatedAt;
	}
	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}
	
	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	@Override
	public String toString() {
		return "HistoryComment [id=" + id + ", historyId=" + historyId + ", memberId=" + memberId + ", content="
				+ content + ", nickname=" + nickname + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + "]";
	}
	
}
