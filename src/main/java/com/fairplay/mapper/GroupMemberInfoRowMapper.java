package com.fairplay.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.fairplay.domain.GroupMemberInfoDTO;

// DB 조회 결과를 GroupMemberInfoDTO로 매핑하는 클래스
// 닉네임, 실명 등 화면 표시용 정보 포함
public class GroupMemberInfoRowMapper implements RowMapper<GroupMemberInfoDTO> {

    @Override
    public GroupMemberInfoDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
        GroupMemberInfoDTO dto = new GroupMemberInfoDTO();
        dto.setNickname(rs.getString("nickname"));
        dto.setRealName(rs.getString("real_name"));
        dto.setRole(rs.getString("role"));
        dto.setTotalScore(rs.getInt("total_score"));
        dto.setMonthlyScore(rs.getInt("monthly_score"));   // weekly → monthly로 변경
        dto.setWarningCount(rs.getInt("warning_count"));
        dto.setId(rs.getInt("id"));
        dto.setGroupId(rs.getInt("group_id"));
        dto.setMemberId(rs.getInt("member_id"));
        return dto;
    }
}