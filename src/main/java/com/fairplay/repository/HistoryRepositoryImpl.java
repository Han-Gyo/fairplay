package com.fairplay.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.History;

@Repository
public class HistoryRepositoryImpl implements HistoryRepository{
	@Autowired
	private JdbcTemplate jdbcTemplate;

	// 전체 히스토리 조회
	@Override
	public List<History> findAll() {
		String sql ="SELECT * FROM history ORDER BY completed_at DESC";
		return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(History.class)) ;
	}

	@Override
	public void save(History history) {
		// 기록 추가 (insert)
		String sql = "INSERT INTO history (member_id, todo_id, completed_at, photo, memo, score, `check`, check_member)" + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		jdbcTemplate.update(sql,
			history.getMember_id(),
			history.getTodo_id(),
			history.getCompleted_at(),
			history.getPhoto(),
			history.getMemo(),
			history.getScore(),
			history.isCheck(),
			history.getCheck_member());
	}

	@Override
	public History findById(int id) {
		// id로 기록 1개 조회
		String sql = "SELECT * FROM history WHERE id = ?";
		                                            // 자바 객체로 자동 매핑해주는 클래스
 		return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(History.class), id);
	}

	@Override
	public List<History> findByTodoId(int todo_id) {
		// 특정 할일의 전체 기록 조회
		String sql ="SELECT * FROM history WHERE todo_id = ?";
		return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(History.class), todo_id);
	}

	@Override
	public List<History> findByMemberId(int member_id) {
		// 특정 멤버의 전체 기록 조회
		String sql = "SELECT * FROM history WHERE member_id = ?";
		return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(History.class), member_id);
	}

	@Override
	public void update(History history) {
		// 기록 수정
		String sql = "UPDATE history SET completed_at = ?, photo = ?, memo = ?, `check` = ?, check_member = ? WHERE id = ?";
		jdbcTemplate.update(sql,
			history.getCompleted_at(),
			history.getPhoto(),
			history.getMemo(),
			history.isCheck(),
			history.getCheck_member(),
			history.getId());
		
	}

	@Override
	public void delete(int id) {
		// 기록 삭제
		String sql = "DELETE FROM history WHERE id =?";
		jdbcTemplate.update(sql, id);
	}
	
	
}
