package com.fairplay.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.Member;
import com.fairplay.enums.MemberStatus;
import com.fairplay.mapper.MemberRowMapper;

@Repository
public class MemberRepositoryImpl implements MemberRepository {
    
    // Spring 설정에 등록된 JdbcTemplate Bean을 주입받음
    @Autowired 
    private JdbcTemplate jdbcTemplate;
    
    @Override
    public void save(Member member) {
        // 회원 정보를 DB에 저장하는 SQL문 (id는 auto_increment라 제외)
        String sql = "INSERT INTO member (user_id, password, real_name, nickname, email, address, phone, status, role, profile_image) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        jdbcTemplate.update(sql, 
            member.getUser_id(),
            member.getPassword(),
            member.getReal_name(),  
            member.getNickname(),
            member.getEmail(),
            member.getAddress(),
            member.getPhone(),
            member.getStatus().name(),     // enum을 DB에 저장할 때 문자열로 변환
            member.getRole(),
            member.getProfileImage()
        );
    }
    
    // 전체 회원 목록 조회 (Read_all)
    @Override
    public List<Member> readAll() {
        String sql = "SELECT * FROM member";
        return jdbcTemplate.query(sql, new MemberRowMapper());
    }

    // 특정 회원 조회 (Read_one)
    @Override
    public Member findById(int id) {
        String sql = "SELECT * FROM member WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, new MemberRowMapper(), id);
    }

	// 특정 회원 업데이트 (Update)
    @Override
    public void update(Member member) {
        String sql = "UPDATE member SET user_id = ?, password = ?, real_name = ?, nickname = ?, email = ?, address = ?, phone = ?, status = ?, profile_image = ?, inactive_at = ? WHERE id = ?";
        
        jdbcTemplate.update(sql,
            member.getUser_id(),
            member.getPassword(),
            member.getReal_name(),
            member.getNickname(),
            member.getEmail(),
            member.getAddress(),
            member.getPhone(),
            member.getStatus().name(),
            member.getProfileImage(),
            member.getInactive_at(),
            member.getId()
        );
    }



    @Override
    public void deactivate(int id) {
        // enum을 사용해 상태를 'INACTIVE'로 설정 (소프트 삭제)
        String sql = "UPDATE member SET status = ?, inactive_at = NOW() WHERE id = ?";
        jdbcTemplate.update(sql, MemberStatus.INACTIVE.name(), id);
    }

    @Override
    public Member findByUserId(String user_id) {
        String sql = "SELECT * FROM member WHERE user_id = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new MemberRowMapper(), user_id);
        } catch (EmptyResultDataAccessException e) {
            return null; // 결과가 없으면 null 반환
        }
    }

    // 사용자 아이디 중복 여부 확인 (ACTIVE 회원만)
    @Override
    public boolean existsByUserId(String userId) {
        String sql = "SELECT COUNT(*) FROM member WHERE user_id = ? AND status = 'ACTIVE'";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, userId);
        return count != null && count > 0;
    }

    // 닉네임 존재 여부 확인 (ACTIVE 회원만)
    @Override
    public boolean existsByNickname(String nickname) {
        String sql = "SELECT COUNT(*) FROM member WHERE nickname = ? AND status = 'ACTIVE'";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, nickname);
        return count != null && count > 0;
    }

    // 이메일 존재 여부 확인 (ACTIVE 회원만)
    @Override
    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM member WHERE email = ? AND status = 'ACTIVE'";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, email);
        return count != null && count > 0;
    }

    @Override
    public Member findByUserIdAndEmail(String userId, String email) {
        String sql = "SELECT * FROM member WHERE user_id = ? AND email = ? AND status = 'ACTIVE'";
        try {
            return jdbcTemplate.queryForObject(sql, new MemberRowMapper(), userId, email);
        } catch (EmptyResultDataAccessException e) {
            return null;
        }
    }

    // 이메일로 회원 조회
    @Override
    public Member findByEmail(String email) {
        String sql = "SELECT * FROM member WHERE email = ? AND status = 'ACTIVE'";
        return jdbcTemplate.queryForObject(sql, new MemberRowMapper(), email);
    }

    // 비밀번호로만 업데이트
    @Override
    public int updatePassword(Member member) {
        String sql = "UPDATE member SET password = ? WHERE id = ?";
        return jdbcTemplate.update(sql, member.getPassword(), member.getId());
    }

    // 회원의 비밀번호를 ID 기준으로 수정
    @Override
    public void updatePassword(int id, String encodedPassword) {
        String sql = "UPDATE member SET password = ? WHERE id = ?";
        jdbcTemplate.update(sql, encodedPassword, id);
    }

    // 실명 + 이메일로 회원 조회 (아이디 찾기용, ACTIVE 회원만)
    @Override
    public Member findByRealNameAndEmail(String realName, String email) {
        String sql = "SELECT * FROM member WHERE real_name = ? AND email = ? AND status = 'ACTIVE'";
        List<Member> result = jdbcTemplate.query(sql, new MemberRowMapper(), realName, email);
        return result.isEmpty() ? null : result.get(0);
    }
}