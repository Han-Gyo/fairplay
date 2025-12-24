package com.fairplay.repository;

import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import java.sql.PreparedStatement;
import java.sql.Statement;

import com.fairplay.domain.Todo;
import com.fairplay.domain.TodoSimple;

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
			todo.setId(rs.getInt("id"));							 									// 기본 키
			todo.setGroup_id(rs.getInt("group_id"));				 						// 그룹 ID
			todo.setTitle(rs.getString("title"));					 							// 제목
			todo.setAssigned_to((Integer) rs.getObject("assigned_to"));	// 담당자 ID
			todo.setStatus(rs.getString("status"));											// 상태
			todo.setDue_date(rs.getTimestamp("due_date"));			 				// 마감일
			todo.setCompleted(rs.getBoolean("completed"));			 				// 완료 여부
			todo.setDifficulty_point(rs.getInt("difficulty_point")); 		// 난이도 점수
			return todo;
		}
	};
	
	// 전체 할 일 목록 조회 (내림차순 정렬)
	@Override
	public List<Todo> findAll() {
		String sql = "SELECT * FROM todo ORDER BY id DESC";
		return template.query(sql, todoRowMapper);
	}
	
	@Override
	public List<Todo> findByAssignedMember(int memberId) {
		String sql = "SELECT * FROM todo WHERE assigned_to = ? ORDER BY id DESC";
		return template.query(sql, todoRowMapper, memberId);
	}
	
	// 할 일 등록
	@Override
	public void insert(Todo todo) {
	    String sql = "INSERT INTO todo (title, group_id, assigned_to, due_date, difficulty_point, completed, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
	    System.out.println("[DB 저장 전] status 확인: " + todo.getStatus());
	    
	    KeyHolder keyHolder = new GeneratedKeyHolder();
	    
	    template.update(connection -> {

        PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, todo.getTitle());
        ps.setInt(2, todo.getGroup_id());
        
        if (todo.getAssigned_to() != null && todo.getAssigned_to() > 0) {
            ps.setInt(3, todo.getAssigned_to());
        } else {
            ps.setNull(3, java.sql.Types.INTEGER);
        }
        
        if (todo.getDue_date() != null) {
	          ps.setTimestamp(4, new java.sql.Timestamp(todo.getDue_date().getTime()));
	      } else {
	          ps.setNull(4, java.sql.Types.TIMESTAMP);
	      }
        ps.setInt(5, todo.getDifficulty_point());
        ps.setBoolean(6, todo.isCompleted());
        ps.setString(7, todo.getStatus());
        return ps;
	    }, keyHolder);


    if (keyHolder.getKey() != null) {
        int newId = keyHolder.getKey().intValue();
        todo.setId(newId);
        System.out.println("[DB] 방금 생성된 Todo ID: " + newId);
    }
}
	
	// 할 일 수정
	@Override
	public void update(Todo todo) {
		String sql = "UPDATE todo SET title = ?, assigned_to = ?, due_date = ?, completed = ?, difficulty_point = ?, status = ? WHERE id = ?";
		// 특정 할 일 수정
		template.update(sql,
			todo.getTitle(),							// 제목
			todo.getAssigned_to(),				// 담당자 ID
			todo.getDue_date(),						// 마감일
			todo.isCompleted(),						// 완료 여부
			todo.getDifficulty_point(),		// 난이도
			todo.getStatus(),							// 상태
			todo.getId()									// 수정 대상 ID
		);
	}
	
	@Override
	public void updateAssignedStatus(int todoId, int memberId) {
		System.out.println("[DB] updateAssignedStatus 실행됨! todo_id = " + todoId + ", memberId = " + memberId);
		String sql = "UPDATE todo SET assigned_to = ?, status = ? WHERE id = ?";
	    template.update(sql, memberId, "신청완료", todoId);
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
	// [신청 취소] 담당자 해제 + 상태 초기화
	@Override
	public void resetAssignedStatus(int todoId) {
		String sql = "UPDATE todo SET assigned_to = NULL, status ='미신청' WHERE id =?";
		template.update(sql, todoId);
	}

	@Override
	public List<Todo> findCompletedTodos() {
		String sql = "SELECT * FROM todo WHERE completed = true ORDER BY id DESC";
		System.out.println("✅ [DB] 완료된 할 일 목록 조회됨");
		return template.query(sql, todoRowMapper);
	}

	@Override
	public List<Todo> findNotDone(int memberId) {
		String sql = "SELECT * FROM todo WHERE assigned_to = ? AND completed = false";
		return template.query(sql, todoRowMapper, memberId);
	}

	@Override
	public List<TodoSimple> findTodosByDateAndMember(LocalDate date, int memberId) {
	    String sql = """
	        SELECT t.id, t.title, m.nickname
	        FROM todo t
	        JOIN member m ON t.assigned_to = m.id
	        WHERE DATE(t.due_date) = ?
	          AND t.group_id IN (
	              SELECT gm.group_id FROM group_member gm WHERE gm.member_id = ?
	          )
	    """;

	    return template.query(sql,
	        (rs, rowNum) -> new TodoSimple(
	            rs.getInt("id"),
	            rs.getString("title"),
	            rs.getString("nickname")
	        ),
	        Date.valueOf(date),
	        memberId
	    );
	}

	@Override
	public List<Todo> findByGroupId(int groupId) {
	    // 그룹 ID를 사용하여 해당 그룹의 Todo만 조회
	    String sql = "SELECT * FROM todo WHERE group_id = ? ORDER BY id DESC";
	    System.out.println("[DB] 그룹 ID(" + groupId + ")로 할 일 목록 조회됨");
	    return template.query(sql, todoRowMapper, groupId); // groupId를 파라미터로 넘김
	}

	@Override
	public List<Todo> findByGroupIdAndAssignedTo(int groupId, int memberId) {
		String sql = "SELECT * FROM todo WHERE group_id = ? AND assigned_to = ? AND completed = false";

    return template.query(sql, todoRowMapper, groupId, memberId);
	}
	
	@Override
	public List<Todo> findCompletedWithoutHistory(int groupId, int memberId) {
	    String sql = 
	        "SELECT t.* " +
	        "FROM todo t " +
	        "LEFT JOIN history h ON t.id = h.todo_id " +
	        "WHERE t.group_id = ? " +
	        "AND t.assigned_to = ? " +
	        "AND h.id IS NULL";

	    return template.query(sql, todoRowMapper, groupId, memberId);
	}
	
}