package com.fairplay.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.fairplay.domain.GroupMemberInfoDTO;

public class GroupMemberInfoRowMapper implements RowMapper<GroupMemberInfoDTO>{

	@Override
	public GroupMemberInfoDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
		GroupMemberInfoDTO dto = new GroupMemberInfoDTO();
		dto.setNickname(rs.getString("nickname"));
		dto.setRealName(rs.getString("real_name"));
		dto.setRole(rs.getString("role"));
		dto.setTotalScore(rs.getInt("total_score"));
		dto.setWeeklyScore(rs.getInt("weekly_score"));
		dto.setWarningCount(rs.getInt("warning_count"));
		dto.setId(rs.getInt("id"));
		dto.setGroupId(rs.getInt("group_id"));
		return dto;
	}

	
}
