package com.fairplay.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.fairplay.domain.Group;

// DB의 group 테이블 한 행(Row)를 Group 객체로 매핑하는 클래스
public class GroupRowMapper implements RowMapper<Group>{

	@Override
	public Group mapRow(ResultSet rs, int rowNum) throws SQLException {
		Group group = new Group();
		group.setId(rs.getInt("id"));							// ID 매핑
		group.setName(rs.getString("name"));					// 그룹 이름
		group.setDescription(rs.getString("description"));		// 그룹 설명
		group.setCode(rs.getString("code"));					// 초대 코드
		group.setMaxMember(rs.getInt("max_member"));			// 최대 인원
		group.setPublicStatus(rs.getBoolean("public_status"));	// 공개 여부
		group.setProfile_img(rs.getString("profile_img"));		// 이미지 파일명
		group.setCreated_at(rs.getTimestamp("created_at"));		// 생성일시
		group.setAdmin_comment(rs.getString("admin_comment"));	// 관리자 메시지
		group.setLeaderId(rs.getInt("leader_id"));				// 그룹장 ID
		return group;
	}
	
	

}
