package com.fairplay.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.GroupMember;
import com.fairplay.domain.GroupMemberInfoDTO;
import com.fairplay.mapper.GroupMemberInfoRowMapper;
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
	public void delete(int groupId, int memberId) {
		
		String sql = "delete from group_member where group_id = ? AND member_id = ?";
		
		jdbcTemplate.update(sql, groupId, memberId);
		
	}

	@Override
	public boolean isGroupMember(int groupId, int memberId) {
		
		// 주어진 그룹 ID와 멤버 ID가 모두 일치하는 데이터가 group_member 테이블에 존재하는지 확인하는 SQL
		String sql = "select count(*) from group_member where group_id = ? and member_id = ?";
		
		// 쿼리 결과를 Integer 타입으로 받아옴 (조건에 맞는 레코드 수)
		Integer count = jdbcTemplate.queryForObject(sql, Integer.class, groupId, memberId);
		
		// count가 null이 아니고 0보다 크면 -> 가입된 멤버로 판단하여 true 반환
		return count != null && count > 0;
	}

	@Override
	public List<GroupMemberInfoDTO> findMemberInfoByGroupId(int groupId) {
		String sql = "SELECT gm.id, gm.group_id, gm.member_id, m.nickname, m.real_name, " +
	             	 "gm.role, gm.total_score, gm.weekly_score, gm.warning_count " +
	             	 "FROM group_member gm " +
	             	 "JOIN member m ON gm.member_id = m.id " +
	             	 "WHERE gm.group_id = ?";


						
		return jdbcTemplate.query(sql, new GroupMemberInfoRowMapper(), groupId);
	}

	@Override
	public int countByGroupId(int groupId) {
		String sql = "SELECT COUNT(*) FROM group_member WHERE group_id = ?";
		return jdbcTemplate.queryForObject(sql, Integer.class, groupId);
	}

	// 그룹장 탈퇴 전용 처리
	@Override
	public void deleteByMemberIdAndGroupId(int memberId, int groupId) {
		String sql = "DELETE FROM group_member WHERE member_id = ? AND group_id = ?";
	    jdbcTemplate.update(sql, memberId, groupId);
	}

	// 그룹 내 역할 조회
	@Override
	public String findRoleByMemberIdAndGroupId(int memberId, int groupId) {
		String sql = "SELECT role FROM group_member WHERE member_id = ? AND group_id = ?";
	    return jdbcTemplate.queryForObject(sql, String.class, memberId, groupId);
	}

	// 그룹 내에서 리더를 제외한 멤버 목록 조회 (위임 대상)
	@Override
	public List<GroupMemberInfoDTO> findMembersExcludingLeader(int groupId) {
		String sql = "SELECT gm.id, gm.group_id, gm.member_id, m.nickname, m.real_name, " +
	             "gm.role, gm.total_score, gm.weekly_score, gm.warning_count " +
	             "FROM group_member gm " +
	             "JOIN member m ON gm.member_id = m.id " +
	             "WHERE gm.group_id = ? AND gm.role != 'LEADER'";

		return jdbcTemplate.query(sql, new GroupMemberInfoRowMapper(), groupId);
	}

	@Override
	public void updateRoleToLeader(int groupId, int memberId) {
		String sql = "UPDATE group_member SET role = 'LEADER' WHERE group_id = ? AND member_id = ?";
		jdbcTemplate.update(sql, groupId, memberId);
	}
	

}
