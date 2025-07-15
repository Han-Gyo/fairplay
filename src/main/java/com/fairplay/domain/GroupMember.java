package com.fairplay.domain;


 // 그룹-멤버 연결 DTO
 // group_member 테이블과 매핑

public class GroupMember {

    /** 고유 ID (PK) */
    private Integer id;

    /** 소속 그룹 ID (FK) */
    private Integer groupId;

    /** 사용자 ID (FK) */
    private Integer memberId;

    /** 역할 (LEADER 또는 MEMBER) */
    private String role;

    /** 이번 주 누적 점수 */
    private Integer weeklyScore;

    /** 전체 누적 점수 */
    private Integer totalScore;

    /** 공정성 경고 횟수 */
    private Integer warningCount;

    /** 기본 생성자 (Spring 바인딩용 필수) */
    public GroupMember() {}

    /** 전체 필드를 초기화하는 생성자 (테스트나 DB 삽입용) */
    public GroupMember(Integer id, Integer groupId, Integer memberId, String role,
                       Integer weeklyScore, Integer totalScore, Integer warningCount) {
        this.id = id;
        this.groupId = groupId;
        this.memberId = memberId;
        this.role = role;
        this.weeklyScore = weeklyScore;
        this.totalScore = totalScore;
        this.warningCount = warningCount;
    }

    // Getter & Setter

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }

    public Integer getMemberId() {
        return memberId;
    }

    public void setMemberId(Integer memberId) {
        this.memberId = memberId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Integer getWeeklyScore() {
        return weeklyScore;
    }

    public void setWeeklyScore(Integer weeklyScore) {
        this.weeklyScore = weeklyScore;
    }

    public Integer getTotalScore() {
        return totalScore;
    }

    public void setTotalScore(Integer totalScore) {
        this.totalScore = totalScore;
    }

    public Integer getWarningCount() {
        return warningCount;
    }

    public void setWarningCount(Integer warningCount) {
        this.warningCount = warningCount;
    }
}
