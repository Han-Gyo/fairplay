package com.fairplay.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.fairplay.domain.Member;
import com.fairplay.enums.MemberStatus;

public class MemberRowMapper implements RowMapper<Member>{

	@Override
    public Member mapRow(ResultSet rs, int rowNum) throws SQLException {
		System.out.println("🔥🔥 MemberRowMapper 실행됨 🔥🔥");
		
        Member member = new Member();
        member.setId(rs.getInt("id"));
        member.setUser_id(rs.getString("user_id"));
        member.setReal_name(rs.getString("real_name"));
        member.setNickname(rs.getString("nickname"));
        member.setEmail(rs.getString("email"));
        member.setAddress(rs.getString("address"));
        member.setPhone(rs.getString("phone"));
        member.setPassword(rs.getString("password"));
        member.setStatus(MemberStatus.valueOf(rs.getString("status")));
        member.setCreated_at(rs.getTimestamp("created_at").toLocalDateTime());
        member.setProfileImage(rs.getString("profile_image"));
        return member;
    }
	
	
}
