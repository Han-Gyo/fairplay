package com.fairplay.repository;

import java.util.List;

import com.fairplay.domain.Wallet;

public interface WalletRepository {
	void save(Wallet wallet); 											// 가계부 항목 저장
	Wallet findById(int id); 											// ID로 항목 1개 조회
	List<Wallet> findByMemberId(int memberId); 							// 특정 사용자의 전체 항목 조회
	void update(Wallet wallet); 										// 가계부 항목 수정
	void delete(int id); 												// ID로 항목 삭제
	List<Wallet> comparePriceByItemName(int memberId, String itemName); // 같은 품목명의 가격 비교 (구매처별로)
}