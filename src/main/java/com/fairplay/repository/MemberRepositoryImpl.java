package com.fairplay.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.Member;

@Repository
public class MemberRepositoryImpl implements MemberRepository{
	
	// Spring 설정에 등록된 JdbcTemplate Bean을 주입받음
	@Autowired 
	private JdbcTemplate jdbcTemplate;
	
	@Override
	public void save(Member member) {
	    // 회원 정보를 DB에 저장하는 SQL문 (id는 auto_increment라 제외)
	    String sql = "INSERT INTO member (user_id, password, real_name, nickname, email, address, phone, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

	    // JdbcTemplate을 통해 INSERT 실행
	    jdbcTemplate.update(sql, 
	        member.getUser_id(),
	        member.getPassword(),
	        member.getReal_name(),  
	        member.getNickname(),
	        member.getEmail(),
	        member.getAddress(),
	        member.getPhone(),
	        member.getStatus()
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
		
		String sql = "UPDATE member SET user_id = ?, nickname = ?, email = ?, address = ?, phone = ? WHERE id = ?";
		
		jdbcTemplate.update(sql,
			member.getUser_id(),
			member.getNickname(),
			member.getEmail(),
			member.getAddress(),
			member.getPhone(),
			member.getId()
		);
		
		
	}


	@Override
	public void deactivate(int id) {
		String sql = "update member set status = 'INACTIVE' where id =?";
		jdbcTemplate.update(sql, id);
	}


	@Override
	public Member findByUserId(String user_id) {
		String sql = "select * from member where user_id =?";
		return jdbcTemplate.queryForObject(sql, new MemberRowMapper(), user_id);
	}
	
	
	

}
