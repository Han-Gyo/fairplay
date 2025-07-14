package com.fairplay.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.Group;
import com.fairplay.mapper.GroupRowMapper;

// 실제 SQL을 실행할 Repository 구현체 (JDBC 활용)
@Repository
public class GroupRepositoryImpl implements GroupRepository{
	
	@Autowired
	private JdbcTemplate jdbcTemplate; // 

	@Override
	public void save(Group group) {
		
		// 그룹 정보를 DB에 저장하기 위한 SQL 구문 (id (AUTO_INCREMENT), created_at은 DB에서 자동 처리됨)
		String sql = "INSERT INTO `group` (name, description, code, max_member, public_status, profile_img, admin_comment) VALUES (?, ?, ?, ?, ?, ?, ?)";
		
		// JdbcTemplate를 사용하여 SQL 실행 각 물음표 자리에 순서대로 group 객체의 값이 매핑됨
		jdbcTemplate.update(sql,
		    group.getName(),          // 그룹 이름
		    group.getDescription(),   // 그룹 설명
	        group.getCode(),          // 초대 코드
	        group.getMaxMember(),    // 최대 인원
	        group.getPublicStatus(),      // 공개 여부
	        group.getProfile_img(),   // 대표 이미지 파일명
		    group.getAdmin_comment()  // 그룹장이 쓴 한 줄 메시지
		);
	}

	@Override
	public List<Group> readAll() {
		String sql = "SELECT * FROM `group` ORDER BY created_at DESC"; // 최신 순 정렬
		return jdbcTemplate.query(sql, new GroupRowMapper());
	}

	@Override
	public Group findById(int id) {
	    
	    // id 값으로 특정 그룹을 조회하는 SQL
	    String sql = "SELECT * FROM `group` WHERE id = ?";

	    try {
	        // queryForObject()는 결과가 1건일 때 사용하며,
	        // RowMapper를 통해 ResultSet → Group 객체로 매핑됨
	        return jdbcTemplate.queryForObject(sql, new GroupRowMapper(), id);
	        
	    } catch (EmptyResultDataAccessException e) {
	        // 조회 결과가 없을 경우 null 반환 (예: 존재하지 않는 id)
	        return null;
	    }
	}


	@Override
	public void update(Group group) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void delete(int id) {
		// TODO Auto-generated method stub
		
	}
	
}
