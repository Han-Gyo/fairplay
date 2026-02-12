package com.fairplay.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.fairplay.domain.GroupMember;

// 내부 로직, 서비스, DB 업데이트용.
public class GroupMemberRowMapper implements RowMapper<GroupMember> {

    @Override
    public GroupMember mapRow(ResultSet rs, int rowNum) throws SQLException {
        GroupMember groupMember = new GroupMember();
        groupMember.setId(rs.getInt("id"));
        groupMember.setGroupId(rs.getInt("group_id"));
        groupMember.setMemberId(rs.getInt("member_id"));
        groupMember.setRole(rs.getString("role"));
        groupMember.setMonthlyScore(rs.getInt("monthly_score"));   // weekly → monthly로 변경
        groupMember.setTotalScore(rs.getInt("total_score"));
        groupMember.setWarningCount(rs.getInt("warning_count"));
        groupMember.setLastCountedMonth(rs.getString("last_counted_month"));
        return groupMember;
    }
}