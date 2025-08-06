package com.fairplay.repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.NeededItemDTO;

@Repository
public class NeededItemRepositoryImpl implements NeededItemRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // RowMapper 정의 (DB → DTO 변환)
    private RowMapper<NeededItemDTO> neededItemRowMapper = new RowMapper<NeededItemDTO>() {
        @Override
        public NeededItemDTO mapRow(ResultSet rs, int rowNum) throws SQLException {
            NeededItemDTO item = new NeededItemDTO();
            item.setId(rs.getLong("id"));
            item.setGroupId(rs.getLong("group_id"));
            item.setItemName(rs.getString("item_name"));
            item.setQuantity(rs.getInt("quantity"));
            item.setAddedBy(rs.getLong("added_by"));
            item.setPurchased(rs.getBoolean("is_purchased"));
            item.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            item.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
            item.setWriterNickname(rs.getString("nickname"));
            return item;
        }
    };

    // 그룹별 물품 전체 조회
    @Override
    public List<NeededItemDTO> findAllByGroupId(Long groupId) {
        String sql = "SELECT n.*, m.nickname " +
                     "FROM needed_item n " +
                     "JOIN member m ON n.added_by = m.id " +
                     "WHERE n.group_id = ? " +
                     "ORDER BY n.created_at DESC";

        return jdbcTemplate.query(sql, neededItemRowMapper, groupId);
    }


    // 단일 항목 조회 (수정용)
    @Override
    public NeededItemDTO findById(Long id) {
        String sql = "SELECT * FROM needed_item WHERE id = ?";
        return jdbcTemplate.queryForObject(sql, neededItemRowMapper, id);
    }

    // 항목 등록
    @Override
    public int save(NeededItemDTO item) {
        String sql = "INSERT INTO needed_item (group_id, item_name, quantity, added_by) VALUES (?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                item.getGroupId(),
                item.getItemName(),
                item.getQuantity(),
                item.getAddedBy()
        );
    }

    // 항목 수정
    @Override
    public int update(NeededItemDTO item) {
        String sql = "UPDATE needed_item SET item_name = ?, quantity = ?, updated_at = NOW() WHERE id = ?";
        return jdbcTemplate.update(sql,
                item.getItemName(),
                item.getQuantity(),
                item.getId()
        );
    }

    // 항목 삭제
    @Override
    public int delete(Long id) {
        String sql = "DELETE FROM needed_item WHERE id = ?";
        return jdbcTemplate.update(sql, id);
    }

    // 구매 여부 토글 (is_purchased)
    @Override
    public int updatePurchasedStatus(Long id, boolean isPurchased) {
        String sql = "UPDATE needed_item SET is_purchased = ?, updated_at = NOW() WHERE id = ?";
        return jdbcTemplate.update(sql, isPurchased, id);
    }
}
