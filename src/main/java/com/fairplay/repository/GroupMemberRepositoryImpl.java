package com.fairplay.repository;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.Group;
import com.fairplay.domain.GroupMember;
import com.fairplay.domain.GroupMemberInfoDTO;
import com.fairplay.mapper.GroupMemberInfoRowMapper;
import com.fairplay.mapper.GroupMemberRowMapper;

@Repository
public class GroupMemberRepositoryImpl implements GroupMemberRepository {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public GroupMemberRepositoryImpl(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // 그룹 멤버 저장 (가입 처리)
    @Override
    public void save(GroupMember groupMember) {
        // weekly_score → monthly_score로 변경
        // NEW: last_counted_month 추가
        String sql = "INSERT INTO group_member (group_id, member_id, role, monthly_score, total_score, warning_count, last_counted_month) VALUES (?, ?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql,
            groupMember.getGroupId(),
            groupMember.getMemberId(),
            groupMember.getRole(),
            groupMember.getMonthlyScore(),
            groupMember.getTotalScore(),
            groupMember.getWarningCount(),
            groupMember.getLastCountedMonth()
        );
    }


    // 특정 그룹에 속한 멤버 전체 조회
    @Override
    public List<GroupMember> findByGroupId(int groupId) {
        String sql = "SELECT * FROM group_member WHERE group_id = ?";
        return jdbcTemplate.query(sql, new GroupMemberRowMapper(), groupId);
    }

    // PK(id)로 그룹 멤버 단일 조회
    @Override
    public GroupMember findById(int id) {
        String sql = "SELECT * FROM group_member WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, new GroupMemberRowMapper(), id);
    }

    // 그룹 멤버 정보 수정 (역할, 점수, 경고 등)
    @Override
    public void update(GroupMember groupmember) {
        // weekly_score → monthly_score로 변경
        // NEW: last_counted_month 추가
        String sql = "UPDATE group_member SET role = ?, monthly_score = ?, total_score = ?, warning_count = ?, last_counted_month = ? WHERE id = ?";
        jdbcTemplate.update(sql,
            groupmember.getRole(),
            groupmember.getMonthlyScore(),
            groupmember.getTotalScore(),
            groupmember.getWarningCount(),
            groupmember.getLastCountedMonth(), // NEW
            groupmember.getId()
        );
    }


    // 그룹 멤버 삭제
    @Override
    public void delete(int groupId, int memberId) {
        String sql = "DELETE FROM group_member WHERE group_id = ? AND member_id = ?";
        jdbcTemplate.update(sql, groupId, memberId);
    }

    // 특정 멤버가 그룹에 속해 있는지 여부 확인
    @Override
    public boolean isGroupMember(Long groupId, Long memberId) {
        String sql = "SELECT COUNT(*) FROM group_member WHERE group_id = ? AND member_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, groupId, memberId);
        return count != null && count > 0;
    }

    // 그룹 ID로 그룹 멤버 정보(닉네임, 이름 포함) 조회
    @Override
    public List<GroupMemberInfoDTO> findMemberInfoByGroupId(int groupId) {
        // weekly_score → monthly_score로 변경
        String sql = "SELECT gm.id, gm.group_id, gm.member_id, m.nickname, m.real_name, " +
                     "gm.role, gm.total_score, gm.monthly_score, gm.warning_count " +
                     "FROM group_member gm " +
                     "JOIN member m ON gm.member_id = m.id " +
                     "WHERE gm.group_id = ?";
        return jdbcTemplate.query(sql, new GroupMemberInfoRowMapper(), groupId);
    }

    // 그룹 내 현재 인원 수 조회
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

    // 그룹 내 특정 멤버의 역할 조회
    @Override
    public String findRoleByMemberIdAndGroupId(int memberId, int groupId) {
        String sql = "SELECT role FROM group_member WHERE member_id = ? AND group_id = ?";
        return jdbcTemplate.queryForObject(sql, String.class, memberId, groupId);
    }

    // 그룹 내에서 리더를 제외한 멤버 목록 조회 (리더 위임 대상)
    @Override
    public List<GroupMemberInfoDTO> findMembersExcludingLeader(int groupId) {
        // weekly_score → monthly_score로 변경
        String sql = "SELECT gm.id, gm.group_id, gm.member_id, m.nickname, m.real_name, " +
                     "gm.role, gm.total_score, gm.monthly_score, gm.warning_count " +
                     "FROM group_member gm " +
                     "JOIN member m ON gm.member_id = m.id " +
                     "WHERE gm.group_id = ? AND gm.role != 'LEADER'";
        return jdbcTemplate.query(sql, new GroupMemberInfoRowMapper(), groupId);
    }

    // 새로운 리더로 역할 변경
    @Override
    public void updateRoleToLeader(int groupId, int memberId) {
        String sql = "UPDATE group_member SET role = 'LEADER' WHERE group_id = ? AND member_id = ?";
        jdbcTemplate.update(sql, groupId, memberId);
    }

    // 내가 가입한 그룹 리스트 반환 (그룹명, ID 포함)
    @Override
    public List<Group> findGroupsByMemberId(Long memberId) {
        String sql = "SELECT g.id, g.name " +
                     "FROM group_member gm " +
                     "JOIN `group` g ON gm.group_id = g.id " +
                     "WHERE gm.member_id = ?";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Group group = new Group();
            group.setId(rs.getInt("id"));
            group.setName(rs.getString("name"));
            return group;
        }, memberId);
    }

    // 로그인 사용자의 최근 가입 그룹 ID 반환
    @Override
    public Integer findLatestGroupIdByMember(int memberId) {
        String sql =
            "SELECT group_id " +
            "FROM group_member " +
            "WHERE member_id = ? " +
            "ORDER BY id DESC " +   // 최근 가입 = PK(id) 기준 내림차순
            "LIMIT 1";
        List<Integer> ids = jdbcTemplate.query(sql, (rs, i) -> rs.getInt("group_id"), memberId);
        return ids.isEmpty() ? null : ids.get(0);
    }

    // 가장 오래된 비리더 멤버 ID 조회
    @Override
    public Integer findOldestNonLeaderMemberId(int groupId) {
        String sql =
            "SELECT member_id " +
            "FROM group_member " +
            "WHERE group_id = ? AND role != 'LEADER' " +
            "ORDER BY id ASC " + // PK(id) 오름차순을 '오래된 가입'의 근사치로 사용
            "LIMIT 1";
        List<Integer> ids = jdbcTemplate.query(sql, (rs, i) -> rs.getInt("member_id"), groupId);
        return ids.isEmpty() ? null : ids.get(0);
    }

	@Override
	public GroupMember findByGroupIdAndMemberId(int groupId, int memberId) {
        // NEW: last_counted_month도 함께 조회됨
        String sql = "SELECT * FROM group_member WHERE group_id = ? AND member_id = ?";
        return jdbcTemplate.queryForObject(sql, new GroupMemberRowMapper(), groupId, memberId);
    }

	// NEW: 집계 중복 방지용 last_counted_month만 업데이트하는 메서드
    @Override
    public void updateLastCountedMonth(int groupMemberId, String yearMonth) {
        String sql = "UPDATE group_member SET last_counted_month = ? WHERE id = ?";
        jdbcTemplate.update(sql, yearMonth, groupMemberId);
    }


    
    
}