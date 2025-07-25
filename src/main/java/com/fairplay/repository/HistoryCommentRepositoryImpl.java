package com.fairplay.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.HistoryComment;

@Repository
public class HistoryCommentRepositoryImpl implements HistoryCommentRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // ✅ 댓글 등록
    @Override
    public void save(HistoryComment comment) {
        String sql = "INSERT INTO history_comment (history_id, member_id, content) VALUES (?, ?, ?)";
        jdbcTemplate.update(sql, comment.getHistoryId(), comment.getMemberId(), comment.getContent());
    }

    // ✅ 특정 히스토리 ID로 댓글 목록 조회
    @Override
    public List<HistoryComment> findByHistoryId(int historyId) {
        String sql = """
            SELECT hc.*, m.nickname
            FROM history_comment hc
            JOIN member m ON hc.member_id = m.id
            WHERE hc.history_id = ?
            ORDER BY hc.created_at ASC
        """;

        return jdbcTemplate.query(sql, new Object[]{historyId}, commentRowMapper());
    }

    // ✅ 댓글 삭제
    @Override
    public void delete(int id) {
        String sql = "DELETE FROM history_comment WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }

    // ✅ 댓글 단건 조회
    @Override
    public HistoryComment findById(int id) {
        String sql = """
            SELECT hc.*, m.nickname
            FROM history_comment hc
            JOIN member m ON hc.member_id = m.id
            WHERE hc.id = ?
        """;

        return jdbcTemplate.queryForObject(sql, new Object[]{id}, commentRowMapper());
    }

    // ✅ RowMapper
    private RowMapper<HistoryComment> commentRowMapper() {
        return new RowMapper<HistoryComment>() {
            @Override
            public HistoryComment mapRow(ResultSet rs, int rowNum) throws SQLException {
                HistoryComment comment = new HistoryComment();
                comment.setId(rs.getInt("id"));
                comment.setHistoryId(rs.getInt("history_id"));
                comment.setMemberId(rs.getInt("member_id"));
                comment.setContent(rs.getString("content"));
                comment.setNickname(rs.getString("nickname"));
                comment.setCreatedAt(rs.getDate("created_at"));
                comment.setUpdatedAt(rs.getDate("updated_at"));
                return comment;
            }
        };
    }
}
