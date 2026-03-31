package com.fairplay.repository;

import java.util.List;

import com.fairplay.domain.Wallet;

public interface WalletRepository {
	void save(Wallet wallet); 																					// 가계부 항목 저장
	void update(Wallet wallet); 																				// 가계부 항목 수정
	void delete(int id); 																								// ID로 항목 삭제
	Wallet findById(int id); 																						// ID로 항목 1개 조회
	List<Wallet> findByMemberId(int memberId); 													// 특정 사용자의 전체 항목 조회
	List<Wallet> comparePriceByItemName(int memberId, String itemName); // 같은 품목명의 가격 비교
	List<Wallet> findByGroupId(int groupId);														// 그룹 ID로 내역 조회하는 메서드 추가
}