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

    /** 이번 달 누적 점수 (weekly → monthly로 변경) */
    private Integer monthlyScore;

    /** 전체 누적 점수 */
    private Integer totalScore;

    /** 공정성 경고 횟수 */
    private Integer warningCount;

    public GroupMember() {}

    public GroupMember(Integer id, Integer groupId, Integer memberId, String role,
                       Integer monthlyScore, Integer totalScore, Integer warningCount) {
        this.id = id;
        this.groupId = groupId;
        this.memberId = memberId;
        this.role = role;
        this.monthlyScore = monthlyScore;
        this.totalScore = totalScore;
        this.warningCount = warningCount;
    }

    // Getter & Setter
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }

    public Integer getGroupId() { return groupId; }
    public void setGroupId(Integer groupId) { this.groupId = groupId; }

    public Integer getMemberId() { return memberId; }
    public void setMemberId(Integer memberId) { this.memberId = memberId; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Integer getMonthlyScore() { return monthlyScore; }
    public void setMonthlyScore(Integer monthlyScore) { this.monthlyScore = monthlyScore; }

    public Integer getTotalScore() { return totalScore; }
    public void setTotalScore(Integer totalScore) { this.totalScore = totalScore; }

    public Integer getWarningCount() { return warningCount; }
    public void setWarningCount(Integer warningCount) { this.warningCount = warningCount; }
}