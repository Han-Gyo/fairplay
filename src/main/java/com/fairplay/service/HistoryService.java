package com.fairplay.service;

import java.util.List;

import com.fairplay.domain.History;

public interface HistoryService {
	List<History> getAllHistories();							// 전체 기록 조회
	List<History> getAllHistoriesWithDetails();					// 모든 기록 + 상세정보 조회
	List<History> getHistoriesByTodoId (int id);				// 특정 할일(Todo)의 기록 목록 조회
	List<History> getHistoriesByMemberId (int id);				// 특정 사용자(Member)의 기록 목록 조회
	List<History> getHistoriesByTodoIdWithDetails(int todo_id); // 특정 할일의 기록 + 상세정보 조회
	History getHistoryById (int id);							// 기록 1개 조회
	History getHistoryByIdWithDetails(int id);			// 기록 1개 + 상세정보 조회
	void addHistory (History history);							// 기록 추가
	void updateHistory (History history);						// 기록 수정
	void deleteHistory (int id);								// 기록 삭제
}
