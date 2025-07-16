package com.fairplay.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.GroupMember;
import com.fairplay.mapper.GroupMemberRowMapper;

@Repository
public class GroupMemberRepositoryImpl implements GroupMemberRepository{

	private final JdbcTemplate jdbcTemplate;
	
	@Autowired
	public GroupMemberRepositoryImpl(JdbcTemplate jdbcTemplate) {
		this.jdbcTemplate = jdbcTemplate;
	}
	
	@Override
	public void save(GroupMember groupMember) {
		
		String sql = "insert into group_member (group_id, member_id, role, weekly_score, total_score, warning_count) VALUES (?, ?, ?, ?, ?, ?)";
		
		jdbcTemplate.update(sql,
			groupMember.getGroupId(),
			groupMember.getMemberId(),
			groupMember.getRole(),
			groupMember.getWeeklyScore(),
			groupMember.getTotalScore(),
			groupMember.getWarningCount()
		);
	}

	@Override
	public List<GroupMember> findByGroupId(int groupId) {

		String sql = "select * from group_member where group_id = ?";
		
		return jdbcTemplate.query(sql, new GroupMemberRowMapper(), groupId);
		
	}

	@Override
	public GroupMember findById(int id) {
		
		// SQL문 : group_member 테이블에서 PK(id)로 한 명 조회
		String sql = "select * from group_member where id = ?";
		
		// 이미 정의된 RowMapper 클래스 재사용
		return jdbcTemplate.queryForObject(sql, new GroupMemberRowMapper(), id);
	}

	@Override
	public void update(GroupMember groupmember) {
		
		String sql = "UPDATE group_member SET role = ?, weekly_score = ?, total_score = ?, warning_count = ? WHERE id = ?";
		
		jdbcTemplate.update(sql,
			groupmember.getRole(),
			groupmember.getWeeklyScore(),
			groupmember.getTotalScore(),
			groupmember.getWarningCount(),
			groupmember.getId() // where id = ?		
		);
	}

	@Override
	public void delete(int id) {
		
		String sql = "delete from group_member where id = ?";
		
		jdbcTemplate.update(sql, id);
		
	}
	
	
	

}
