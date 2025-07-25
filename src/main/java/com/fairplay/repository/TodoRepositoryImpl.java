package com.fairplay.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.Todo;

@Repository
public class TodoRepositoryImpl implements TodoRepository{
	
	private JdbcTemplate template;
	
	@Autowired
	public void setJdbctemplate(DataSource dataSource) {
		this.template = new JdbcTemplate(dataSource);
	}
	// DB 결과(ResultSet)를 Todo 객체로 매핑
	private RowMapper<Todo> todoRowMapper = new RowMapper<Todo>() {
		public Todo mapRow(ResultSet rs, int rowNum) throws SQLException {
			Todo todo = new Todo();
			todo.setId(rs.getInt("id"));							 // 기본 키
			todo.setGroup_id(rs.getInt("group_id"));				 // 그룹 ID
			todo.setTitle(rs.getString("title"));					 // 제목
			todo.setAssigned_to(rs.getInt("assigned_to"));			 // 담당자 ID
			todo.setDue_date(rs.getTimestamp("due_date"));			 // 마감일 (timestamp)
			todo.setCompleted(rs.getBoolean("completed"));			 // 완료 여부
			todo.setDifficulty_point(rs.getInt("difficulty_point")); // 난이도 점수
			return todo;
		}
	};
	
	// 전체 할 일 목록 조회 (내림차순 정렬)
	@Override
	public List<Todo> findAll() {
		String sql = "SELECT * FROM todo ORDER BY id DESC";
		return template.query(sql, todoRowMapper);
	}
	
	// 할 일 등록
	@Override
	public void insert(Todo todo) {
		String sql = "INSERT INTO todo (title, group_id, assigned_to, due_date, difficulty_point, completed) VALUES (?, ?, ?, ?, ?, ?)";
		template.update(sql,
			todo.getTitle(),           // 제목
			todo.getGroup_id(),        // 그룹 ID
			todo.getAssigned_to(),     // 담당자 ID
			todo.getDue_date(),        // 마감일
			todo.getDifficulty_point(),// 난이도
			todo.isCompleted()         // 완료 여부
		);
	}
	
	// 할 일 수정
	@Override
	public void update(Todo todo) {
		String sql = "UPDATE todo SET title = ?, assigned_to = ?, due_date = ?, completed = ?, difficulty_point = ? WHERE id = ?";
		// 특정 할 일 수정
		template.update(sql,
			todo.getTitle(),				// 제목
			todo.getAssigned_to(),			// 담당자 ID
			todo.getDue_date(),				// 마감일
			todo.isCompleted(),				// 완료 여부
			todo.getDifficulty_point(),		// 난이도
			todo.getId()					// 수정 대상 ID
		);
	}

	// 할 일 삭제 (ID 기준)
	@Override
	public void deleteById(int id) {
		String sql = "DELETE FROM todo WHERE id = ?";
		template.update(sql, id);
	}

	// 할 일 완료 처리 (completed = true)
	@Override
	public void complete(int id) {
		String sql = "UPDATE todo SET completed = true WHERE id = ?";
		template.update(sql, id);
	}

	// ID로 할 일 조회
	@Override
	public Todo findById(int id) {
		String sql = "SELECT * FROM todo WHERE id = ?";
		return template.queryForObject(sql, todoRowMapper, id);
	}

	
}