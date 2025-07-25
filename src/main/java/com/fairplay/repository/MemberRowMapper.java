package com.fairplay.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.fairplay.domain.Member;
import com.fairplay.enums.MemberStatus;

// ResultSet의 한 행을 Member 객체로 매핑하는 클래스
public class MemberRowMapper implements RowMapper<Member>{

	@Override
	public Member mapRow(ResultSet rs, int rowNum) throws SQLException {
		Member member = new Member();
		member.setId(rs.getInt("id"));
		member.setUser_id(rs.getString("user_id"));
		member.setPassword(rs.getString("password"));
		member.setNickname(rs.getString("nickname"));
		member.setEmail(rs.getString("email"));
		member.setAddress(rs.getString("address"));
		member.setPhone(rs.getString("phone"));
		member.setStatus(MemberStatus.valueOf(rs.getString("status")));		// enum으로 status 매핑
		member.setCreated_at(rs.getTimestamp("created_at").toLocalDateTime());
		return member;
	}
	
	

}
