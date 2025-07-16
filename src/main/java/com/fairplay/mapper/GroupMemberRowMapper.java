package com.fairplay.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.fairplay.domain.GroupMember;

// DB의 group_member 테이블 한 행(Row)를 GroupMember 객체로 매핑하는 클래스
public class GroupMemberRowMapper implements RowMapper<GroupMember>{

	@Override
	public GroupMember mapRow(ResultSet rs, int rowNum) throws SQLException {
		GroupMember groupMember = new GroupMember();
		groupMember.setId(rs.getInt("id"));
		groupMember.setGroupId(rs.getInt("group_id"));
		groupMember.setMemberId(rs.getInt("member_id"));
		groupMember.setRole(rs.getString("role"));
		groupMember.setWeeklyScore(rs.getInt("weekly_score"));
		groupMember.setTotalScore(rs.getInt("total_score"));
		groupMember.setWarningCount(rs.getInt("warning_count"));
		return groupMember;
	}

	
}
