package com.fairplay.domain;

public class MemberMonthlyScore {
	private Integer memberId;		// 멤버 ID
    private String nickname;        // 닉네임
    private int score;              // 해당 월 점수
    private String yearMonth;		// 년-월 
    
	public MemberMonthlyScore() {}
	
	public MemberMonthlyScore(Integer memberId, String nickname, int score, String yearMonth) {
		super();
		this.memberId = memberId;
		this.nickname = nickname;
		this.score = score;
		this.yearMonth = yearMonth;
	}
	public Integer getMemberId() {
		return memberId;
	}
	public void setMemberId(Integer memberId) {
		this.memberId = memberId;
	}
	public String getNickname() {
		return nickname;
	}
	public void setNickname(String nickname) {
		this.nickname = nickname;
	}
	public int getScore() {
		return score;
	}
	public void setScore(int score) {
		this.score = score;
	}

	public String getYearMonth() {
		return yearMonth;
	}

	public void setYearMonth(String yearMonth) {
		this.yearMonth = yearMonth;
	}

	@Override
	public String toString() {
		return "MemberMonthlyScore [memberId=" + memberId + ", nickname=" + nickname + ", score=" + score
				+ ", yearMonth=" + yearMonth + "]";
	}

}
