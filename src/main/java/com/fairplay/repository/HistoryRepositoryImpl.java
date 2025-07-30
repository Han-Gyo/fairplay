package com.fairplay.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.GroupMonthlyScore;
import com.fairplay.domain.History;
import com.fairplay.domain.Member;
import com.fairplay.domain.MemberMonthlyScore;
import com.fairplay.domain.Todo;

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

	@Override
	public List<History> findAllWithDetails() {
		String sql = "SELECT " +
				"history.id AS history_id, " +
				"history.member_id, " +
				"history.todo_id, " +
				"history.completed_at, " +
				"history.photo, " +
				"history.memo, " +
				"history.score, " +
				"history.check, " +
				"history.check_member, " +
				"todo.id AS todo_id, " +
				"todo.title AS todo_title, " +
				"member.id AS member_id, " +
				"member.nickname AS member_nickname " +
				"FROM history " +
				"JOIN todo ON history.todo_id = todo.id " +
				"JOIN member ON history.member_id = member.id " + 
				"ORDER BY history.completed_at DESC";
		
		return jdbcTemplate.query(sql, (rs, rowNum) -> {
			History history = new History();
			history.setId(rs.getInt("history_id"));
			history.setMember_id(rs.getInt("member_id"));
	        history.setTodo_id(rs.getInt("todo_id"));
	        history.setCompleted_at(rs.getTimestamp("completed_at"));
	        history.setPhoto(rs.getString("photo"));
	        history.setMemo(rs.getString("memo"));
	        history.setScore(rs.getInt("score"));
	        history.setCheck(rs.getBoolean("check"));
	        history.setCheck_member(rs.getInt("check_member"));

	        // Todo 객체 매핑
	        Todo todo = new Todo();
	        todo.setId(rs.getInt("todo_id"));
	        todo.setTitle(rs.getString("todo_title"));
	        history.setTodo(todo);  // History에 Todo 포함

	        // Member 객체 매핑
	        Member member = new Member();
	        member.setId(rs.getInt("member_id"));
	        member.setNickname(rs.getString("member_nickname"));
	        history.setMember(member);  // History에 Member 포함
			return history;
		});
		
	}
	
	@Override
	public Date findLatestCommentDateByHistoryId(int historyId) {
	    String sql = "SELECT MAX(created_at) FROM history_comment WHERE history_id = ?";
	    try {
	        return jdbcTemplate.queryForObject(sql, Date.class, historyId);
	    } catch (Exception e) {
	        return null;
	    }
	}

	@Override
	public History findByIdWithDetails(int id) {
		String sql = "SELECT " +
				"history.id AS history_id, " +
				"history.member_id, " +
				"history.todo_id, " +
				"history.completed_at, " +
				"history.photo, " +
				"history.memo, " +
				"history.score, " +
				"history.check, " +
				"history.check_member, " +
				"todo.id AS todo_id, " +
				"todo.title AS todo_title, " +
				"member.id AS member_id, " +
				"member.nickname AS member_nickname " +
				"FROM history " +
				"JOIN todo ON history.todo_id = todo.id " +
				"JOIN member ON history.member_id = member.id " +
				"WHERE history.id = ?";

		return jdbcTemplate.queryForObject(sql, (rs, rowNum) -> {
			History h = new History();
			h.setId(rs.getInt("history_id"));
			h.setMember_id(rs.getInt("member_id"));
			h.setTodo_id(rs.getInt("todo_id"));
			h.setCompleted_at(rs.getTimestamp("completed_at"));
			h.setPhoto(rs.getString("photo"));
			h.setMemo(rs.getString("memo"));
			h.setScore(rs.getInt("score"));
			h.setCheck(rs.getBoolean("check"));
			h.setCheck_member(rs.getInt("check_member"));

			Todo todo = new Todo();
			todo.setId(rs.getInt("todo_id"));
			todo.setTitle(rs.getString("todo_title"));
			h.setTodo(todo);

			Member member = new Member();
			member.setId(rs.getInt("member_id"));
			member.setNickname(rs.getString("member_nickname"));
			h.setMember(member);

			return h;
		}, id);
	}
	
	@Override
	public List<History> findByTodoIdWithDetails(int todo_id) {
	    String sql = "SELECT " +
	            "history.id AS history_id, " +
	            "history.member_id, " +
	            "history.todo_id, " +
	            "history.completed_at, " +
	            "history.photo, " +
	            "history.memo, " +
	            "history.score, " +
	            "history.check, " +
	            "history.check_member, " +
	            "todo.id AS todo_id, " +
	            "todo.title AS todo_title, " +
	            "member.id AS member_id, " +
	            "member.nickname AS member_nickname " +
	            "FROM history " +
	            "JOIN todo ON history.todo_id = todo.id " +
	            "JOIN member ON history.member_id = member.id " +
	            "WHERE history.todo_id = ? " +
	            "ORDER BY history.completed_at DESC";

	    return jdbcTemplate.query(sql, (rs, rowNum) -> {
	        History history = new History();
	        history.setId(rs.getInt("history_id"));
	        history.setMember_id(rs.getInt("member_id"));
	        history.setTodo_id(rs.getInt("todo_id"));
	        history.setCompleted_at(new java.sql.Timestamp(System.currentTimeMillis())); 
	        history.setPhoto(rs.getString("photo"));
	        history.setMemo(rs.getString("memo"));
	        history.setScore(rs.getInt("score"));
	        history.setCheck(rs.getBoolean("check"));
	        history.setCheck_member(rs.getInt("check_member"));

	        // Todo
	        Todo todo = new Todo();
	        todo.setId(rs.getInt("todo_id"));
	        todo.setTitle(rs.getString("todo_title"));
	        history.setTodo(todo);

	        // Member
	        Member member = new Member();
	        member.setId(rs.getInt("member_id"));
	        member.setNickname(rs.getString("member_nickname"));
	        history.setMember(member);

	        return history;
	    }, todo_id);
	}
	
	// ✅ 그룹별 월간 총점 조회
	@Override
	public List<GroupMonthlyScore> findGroupMonthlyScore(int groupId, String yearMonth) {
		
		System.out.println("📌 [Repository] SQL 실행 - 그룹 월간 점수");
	    System.out.println("    ▶ groupId: " + groupId);
	    System.out.println("    ▶ yearMonth: " + yearMonth);
	    
		String sql = "SELECT " +
	            "t.group_id, " +
	            "DATE_FORMAT(h.completed_at, '%Y-%m'), " +  // alias 제거
	            "SUM(t.difficulty_point) " +
	            "FROM history h " +
	            "JOIN todo t ON h.todo_id = t.id " +
	            "WHERE t.group_id = ? " +
	            "AND DATE_FORMAT(h.completed_at, '%Y-%m') = ? " +
	            "GROUP BY t.group_id, DATE_FORMAT(h.completed_at, '%Y-%m')"; // alias 안씀

	    return jdbcTemplate.query(sql, new Object[]{groupId, yearMonth}, new RowMapper<GroupMonthlyScore>() {
	        @Override
	        public GroupMonthlyScore mapRow(ResultSet rs, int rowNum) throws SQLException {
	            return new GroupMonthlyScore(
	                rs.getInt(1),        // group_id
	                rs.getString(2),     // yearMonth (DATE_FORMAT 결과)
	                rs.getInt(3)         // total_score
	            );
	        }
	    });
	}
	
	// ✅ 멤버별 월간 점수 조회
	@Override
	public List<MemberMonthlyScore> findMemberMonthlyScore(int groupId, String yearMonth) {
	    System.out.println("🛠 [Repository] 멤버 월간 점수 SQL 실행");
	    System.out.println("  ▶ groupId: " + groupId);
	    System.out.println("  ▶ yearMonth: " + yearMonth);

	    String sql = 
	    	    "SELECT h.member_id, " +
	    	    "       m.nickname, " +
	    	    "       SUM(t.difficulty_point) AS score, " +
	    	    "       DATE_FORMAT(h.completed_at, '%Y-%m') " + 
	    	    "FROM history h " +
	    	    "JOIN todo t ON h.todo_id = t.id " +
	    	    "JOIN member m ON h.member_id = m.id " +
	    	    "WHERE t.group_id = ? " +
	    	    "  AND DATE_FORMAT(h.completed_at, '%Y-%m') = ? " +
	    	    "GROUP BY h.member_id, m.nickname, DATE_FORMAT(h.completed_at, '%Y-%m') " +
	    	    "ORDER BY score DESC";

	    return jdbcTemplate.query(sql, new Object[]{groupId, yearMonth}, new RowMapper<MemberMonthlyScore>() {
	        @Override
	        public MemberMonthlyScore mapRow(ResultSet rs, int rowNum) throws SQLException {
	            return new MemberMonthlyScore(
	                rs.getInt(1),
	                rs.getString(2),
	                rs.getInt(3),
	                rs.getString(4) 
	            );
	        }
	    });
	}
}
