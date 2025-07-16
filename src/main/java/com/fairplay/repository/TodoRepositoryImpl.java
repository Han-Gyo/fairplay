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
	// DB 결과(ResultSet)를 Todo 객체로 바꿔주는 매퍼
	private RowMapper<Todo> todoRowMapper = new RowMapper<Todo>() {
		public Todo mapRow(ResultSet rs, int rowNum) throws SQLException {
			Todo todo = new Todo();
			todo.setId(rs.getInt("id"));	// DB에서 id 가져와서 설정
			todo.setGroup_id(rs.getInt("group_id"));
			todo.setTitle(rs.getString("title"));
			todo.setAssigned_to(rs.getInt("assigned_to"));
			todo.setDue_date(rs.getTimestamp("due_date"));
			todo.setCompleted(rs.getBoolean("completed"));
			todo.setDifficulty_point(rs.getInt("difficulty_point"));
			return todo;
		}
	};
	
	@Override
	public List<Todo> findAll() {
		String sql = "SELECT * FROM todo ORDER BY id DESC";
		return template.query(sql, todoRowMapper);
	}

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

	@Override
	public void update(Todo todo) {
		String sql = "UPDATE todo SET title = ?, assigned_to = ?, due_date = ?, completed = ?, difficulty_point = ? WHERE id = ?";
		// 특정 할 일 수정
		template.update(sql,
			todo.getTitle(),
			todo.getAssigned_to(),
			todo.getDue_date(),
			todo.isCompleted(),
			todo.getDifficulty_point(),
			todo.getId()
		);
	}

	@Override
	public void deleteById(int id) {
		String sql = "DELETE FROM todo WHERE id = ?";
		template.update(sql, id);
	}

	@Override
	public void complete(int id) {
		String sql = "UPDATE todo SET completed = true WHERE id = ?";
		template.update(sql, id);
	}

	@Override
	public Todo findById(int id) {
		String sql = "SELECT * FROM todo WHERE id = ?";
		return template.queryForObject(sql, todoRowMapper, id);
	}
	
}