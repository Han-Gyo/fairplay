package com.fairplay.service;

import java.util.List;

import com.fairplay.domain.Wallet;

public interface WalletService {
	void save (Wallet wallet); 																						// 새 항목 저장
	void update (Wallet wallet); 																					// 항목 수정
	void delete (int id); 																								// 항목 삭제
	Wallet findById (int id); 																						// ID로 항목 하나 조회
	List<Wallet> findByMemberId (int memberId); 													// 회원 기준 전체 내역 조회
	List<Wallet> comparePriceByItemName (int memberId, String itemName);	// 같은 품목명의 가격 비교
	List<Wallet> findByGroupId(int groupId); 															// 그룹 ID로 내역 조회하는 메서드 추가
}