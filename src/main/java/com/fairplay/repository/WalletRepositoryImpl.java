package com.fairplay.repository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import com.fairplay.domain.Wallet;

@Repository
public class WalletRepositoryImpl implements WalletRepository{

	@Autowired
	public JdbcTemplate jdbcTemplate;
	
	// 새 항목 저장
	@Override
	public void save(Wallet wallet) {
	    String sql = "INSERT INTO wallet (member_id, group_id, item_name, category, price, quantity, unit, unit_count, store, type, purchase_date, memo) " +
	                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

	    jdbcTemplate.update(sql,
	        wallet.getMember_id(),
	        wallet.getGroup_id(),
	        wallet.getItem_name(),
	        wallet.getCategory(),
	        wallet.getPrice(),
	        wallet.getQuantity(),
	        wallet.getUnit(),
	        wallet.getUnit_count(),
	        wallet.getStore(),
	        wallet.getType(),
	        new java.sql.Date(wallet.getPurchase_date().getTime()),
	        wallet.getMemo()
	    );
	}
	// 단일 항목 조회
	@Override
	public Wallet findById(int id) {
		String sql = "SELECT * FROM wallet WHERE id = ?";
		return jdbcTemplate.queryForObject(sql,walletRowMapper(), id);
	}
	// 사용자 전체 내역 조회
	@Override
	public List<Wallet> findByMemberId(int memberId) {
		String sql = "SELECT * FROM wallet WHERE member_id = ? ORDER BY purchase_date DESC";
		return jdbcTemplate.query(sql, walletRowMapper(), memberId);
	}
	// 항목 수정
	@Override
	public void update(Wallet wallet) {
		String sql = "UPDATE wallet SET group_id=?, item_name=?, category=?, price=?, "
				+ "quantity=?, unit=?, unit_count=?, store=?, type=?, "
				+ "purchase_date=?, memo=? WHERE id=?";
		
		jdbcTemplate.update(sql,
			wallet.getGroup_id(),
			wallet.getItem_name(),
			wallet.getCategory(),
			wallet.getPrice(),
			wallet.getQuantity(),
			wallet.getUnit(),
			wallet.getUnit_count(),
			wallet.getStore(),
			wallet.getType(),
			new java.sql.Date(wallet.getPurchase_date().getTime()),
			wallet.getMemo(),
			wallet.getId()
			
		);
	}
	// 항목 삭제
	@Override
	public void delete(int id) {
		String sql = "DELETE FROM wallet WHERE id = ?";
		jdbcTemplate.update(sql, id);
	}

	@Override
	public List<Wallet> comparePriceByItemName(int memberId, String itemName) {
		String sql = "SELECT * FROM wallet " +
                "WHERE member_id = ? AND item_name = ? AND type = '지출' " +
                "ORDER BY (price / NULLIF(unit_count, 0)) ASC";

		return jdbcTemplate.query(sql, walletRowMapper(), memberId, itemName);
	}
	
	private RowMapper<Wallet> walletRowMapper() {
	    return (rs, rowNum) -> {
	        Wallet wallet = new Wallet();
	        wallet.setId(rs.getInt("id"));
	        wallet.setMember_id(rs.getInt("member_id"));
	        wallet.setGroup_id(rs.getInt("group_id"));
	        wallet.setItem_name(rs.getString("item_name"));
	        wallet.setCategory(rs.getString("category"));
	        wallet.setPrice(rs.getInt("price"));
	        wallet.setQuantity(rs.getInt("quantity"));
	        wallet.setUnit(rs.getString("unit"));
	        wallet.setUnit_count(rs.getInt("unit_count"));
	        wallet.setStore(rs.getString("store"));
	        wallet.setType(rs.getString("type"));
	        wallet.setPurchase_date(rs.getDate("purchase_date"));
	        wallet.setMemo(rs.getString("memo"));
	        wallet.setCreated_at(rs.getTimestamp("created_at"));
	        return wallet;
	    };
	}
	
	//WalletRepositoryImpl.java 에 추가
	@Override
	public List<Wallet> findByGroupId(int groupId) {
	   String sql = "SELECT * FROM wallet WHERE group_id = ? ORDER BY purchase_date DESC";
	   return jdbcTemplate.query(sql, walletRowMapper(), groupId);
	}
}