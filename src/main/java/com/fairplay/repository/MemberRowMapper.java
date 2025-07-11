package com.fairplay.repository;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.fairplay.domain.Member;

// ResultSet의 한 행을 Member 객체로 매핑하는 클래스
public class MemberRowMapper implements RowMapper<Member>{

	@Override
	public Member mapRow(ResultSet rs, int rowNum) throws SQLException {
		Member member = new Member();
		member.setId(rs.getInt("id"));
		member.setUsername(rs.getString("username"));
		member.setPassword(rs.getString("password"));
		member.setNickname(rs.getString("nickname"));
		member.setEmail(rs.getString("email"));
		member.setAddress(rs.getString("address"));
		member.setPhone(rs.getString("phone"));
		member.setStatus(rs.getString("status"));
		member.setCreated_at(rs.getTimestamp("created_at").toLocalDateTime());
		return member;
	}
	
	

}
