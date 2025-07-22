package com.fairplay.repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
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
	    
	    // 그룹 정보를 DB에 저장하기 위한 SQL 구문 (id는 AUTO_INCREMENT, created_at은 DB에서 자동 처리됨)
	    String sql = "INSERT INTO `group` (name, description, code, max_member, public_status, profile_img, admin_comment, leader_id) " +
	                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

	    // ✅ 자동 생성된 기본 키(id)를 반환받기 위한 KeyHolder 생성
	    KeyHolder keyHolder = new GeneratedKeyHolder();

	    // ✅ PreparedStatement를 생성하고, RETURN_GENERATED_KEYS 옵션으로 insert 후 생성된 ID를 가져옴
	    jdbcTemplate.update(connection -> {
	        PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS); // ← 자동 생성된 ID를 얻기 위한 설정
	        ps.setString(1, group.getName());              // 그룹 이름
	        ps.setString(2, group.getDescription());       // 그룹 설명
	        ps.setString(3, group.getCode());              // 초대 코드
	        ps.setInt(4, group.getMaxMember());            // 최대 인원
	        ps.setBoolean(5, group.isPublicStatus());      // 공개 여부
	        ps.setString(6, group.getProfile_img());       // 대표 이미지 파일명
	        ps.setString(7, group.getAdmin_comment());     // 그룹장이 쓴 한 줄 메시지
	        ps.setInt(8, group.getLeaderId());             // 그룹 생성자 ID
	        return ps;
	    }, keyHolder);

	    // ✅ insert 후 자동 생성된 그룹 ID 값을 Group 객체에 설정 → 이후 서비스에서 group.getId()로 사용 가능
	    group.setId(keyHolder.getKey().intValue());
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
	    String sql = "UPDATE `group` SET "
	            + "name = ?, "
	            + "description = ?, "
	            + "code = ?, "
	            + "max_member = ?, "
	            + "public_status = ?, "
	            + "profile_img = ?, "
	            + "admin_comment = ? "
	            + "WHERE id = ?";

	    jdbcTemplate.update(sql,
	        group.getName(),
	        group.getDescription(),
	        group.getCode(),
	        group.getMaxMember(),
	        group.isPublicStatus(),
	        group.getProfile_img(),
	        group.getAdmin_comment(),
	        group.getId()   // WHERE용 id
	    );
	}

	@Override
	public void delete(int id) {
		String sql = "DELETE FROM `group` WHERE id = ?";
		
		// JdbcTemplate를 사용해 SQL 실행, id 값 바인딩
		jdbcTemplate.update(sql, id);
		
	}
	
}
