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
	
	private RowMapper<Todo> todoRowMapper = new RowMapper<Todo>() {
		public Todo mapRow(ResultSet rs, int rowNum) throws SQLException {
			Todo todo = new Todo();
			todo.setId(rs.getInt("id"));
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
		String sql = "INSERT INTO todo (group_id, title, completed, difficulty_point) VALUES (?, ?, ?, ?)";
		template.update(sql,
			todo.getGroup_id(),
			todo.getTitle(),
			todo.isCompleted(),
			todo.getDifficulty_point()
		);
	}

	@Override
	public void update(Todo todo) {
		String sql = "UPDATE todo SET title = ?, assigned_to = ?, due_date = ?, completed = ?, difficulty_point = ? WHERE id = ?";
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
}
