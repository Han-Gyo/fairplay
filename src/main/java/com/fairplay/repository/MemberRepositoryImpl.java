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
public class MemberRepositoryImpl implements MemberRepository{
	
	// Spring 설정에 등록된 JdbcTemplate Bean을 주입받음
	@Autowired 
	private JdbcTemplate jdbcTemplate;
	
	@Override
	public void save(Member member) {
	    // 회원 정보를 DB에 저장하는 SQL문 (id는 auto_increment라 제외)
		String sql = "INSERT INTO member (user_id, password, real_name, nickname, email, address, phone, status, profile_image) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

	    // JdbcTemplate을 통해 INSERT 실행
	    jdbcTemplate.update(sql, 
	        member.getUser_id(),
	        member.getPassword(),
	        member.getReal_name(),  
	        member.getNickname(),
	        member.getEmail(),
	        member.getAddress(),
	        member.getPhone(),
	        member.getStatus().name(),		// enum을 DB에 저장할 때 문자열로 변환
	        member.getProfileImage()
	    );
	}

	
	// 전체 회원 목록 조회 (Read_all)
	@Override
	public List<Member> readAll() {
		
		String sql = "select * from member";
		
		// 조회 결과를 MemberRowMapper를 통해 Member 객체로 매핑
		return jdbcTemplate.query(sql, new MemberRowMapper());
	}

	// 특정 회원 조회 (Read_one)
	@Override
	public Member findById(int id) {
		
		String sql = "SELECT * FROM member Where id = ?";
		
		// queryForObject는 단일 결과 반환할 때 사용
		return jdbcTemplate.queryForObject(sql, new MemberRowMapper(), id);
	}

	// 특정 회원 업데이트 (Update)
	@Override
	public void update(Member member) {
		
		String sql = "UPDATE member SET real_name = ?, nickname = ?, email = ?, address = ?, phone = ?, status = ?, profile_image = ? WHERE id = ?";
		
		jdbcTemplate.update(sql,
			member.getReal_name(),
			member.getNickname(),
			member.getEmail(),
			member.getAddress(),
			member.getPhone(),
			member.getStatus().name(),   // enum을 문자열로 저장
			member.getProfileImage(),
			member.getId()
		);
		
		
	}


	@Override
	public void deactivate(int id) {
		// enum을 사용해 상태를 'INACTIVE'로 설정 (소프트 삭제)
		String sql = "UPDATE member SET status = ? WHERE id = ?";
		jdbcTemplate.update(sql, MemberStatus.INACTIVE.name(), id);
	}


	@Override
	public Member findByUserId(String user_id) {
		String sql = "select * from member where user_id =?";
		return jdbcTemplate.queryForObject(sql, new MemberRowMapper(), user_id);
	}

	// 사용자 아이디 중복 여부 확인
	@Override
	public boolean existsByUserId(String userId) {
		// SQL : user_id 기준으로 카운트 조회
		String sql = "SELECT COUNT(*) FROM member WHERE user_id =?";
		
		// queryForObject로 결과 1개(Integer) 받아오기
		Integer count = jdbcTemplate.queryForObject(sql, Integer.class, userId);
		
		System.out.println("💾 DB 조회 결과 count: " + count); // 로그 추가
		
		// count가 1 이상이면 true 반환 (중복 있음)
		return count != null && count > 0; // 존재하면 true 
	}


	// 닉네임 존재 여부 확인
	@Override
	public boolean existsByNickname(String nickname) {
		// 닉네임으로 중복 여부 조회 쿼리 실행
		String sql = "SELECT COUNT(*) FROM member WHERE nickname = ?";
		Integer count = jdbcTemplate.queryForObject(sql, Integer.class, nickname);
		
		// 1개 이상 존재하면 중복
		return count != null && count > 0;
	}

	
	// 이메일 존재 여부 확인 (중복검사)
	@Override
	public boolean existsByEmail(String email) {
		String sql = "SELECT COUNT(*) FROM member WHERE email = ?";
		Integer count = jdbcTemplate.queryForObject(sql, Integer.class, email);
		
		System.out.println("DB 조회 결과 email: " + count);
		return count != null && count > 0;
	}


	@Override
	public Member findByUserIdAndEmail(String userId, String email) {
		String sql = "SELECT * FROM member WHERE user_id = ? AND email = ?";
		
		try {
			return jdbcTemplate.queryForObject(sql, new MemberRowMapper(), userId, email);
		} catch (EmptyResultDataAccessException e) {
			return null;
		}
	}


	// 이메일로 회원 조회
	@Override
	public Member findByEmail(String email) {
		String sql = "SELECT * FROM member WHERE email = ?";
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


	// 실명 + 이메일로 회원 조회 (아이디 찾기용)
	@Override
	public Member findByRealNameAndEmail(String realName, String email) {
	    String sql = "SELECT * FROM member WHERE real_name = ? AND email = ?";
	    
	    List<Member> result = jdbcTemplate.query(sql, new MemberRowMapper(), realName, email);
	    
	    return result.isEmpty() ? null : result.get(0);
	}
	
	
	
	
	
}
