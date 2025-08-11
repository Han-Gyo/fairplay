package com.fairplay.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fairplay.domain.Wallet;
import com.fairplay.repository.WalletRepository;
@Service
public class WalletServiceImpl implements WalletService{

	@Autowired
	private WalletRepository walletRepository;
	
	// 새 항목 저장
	@Override
	public void save(Wallet wallet) {
		walletRepository.save(wallet);
	}
	
	// 특정 회원의 전체 내역 조회
	@Override
	public List<Wallet> findByMemberId(int memberId) {
		 return walletRepository.findByMemberId(memberId);
	}
	
	// 단일 항목 조회
	@Override
	public Wallet findById(int id) {
		return walletRepository.findById(id);
	}
	
	// 항목 수정
	@Override
	public void update(Wallet wallet) {
		walletRepository.update(wallet);
	}
	
	// 항목 삭제
	@Override
	public void delete(int id) {
		walletRepository.delete(id);
	}
	
	// 같은 품목명 기준, 구매처별 단가 비교
	@Override
	public List<Wallet> comparePriceByItemName(int memberId, String itemName) {
		return walletRepository.comparePriceByItemName(memberId, itemName);
	}
	
}
