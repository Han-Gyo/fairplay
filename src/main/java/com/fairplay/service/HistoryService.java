package com.fairplay.service;

import java.util.List;

import com.fairplay.domain.History;

public interface HistoryService {
	List<History> getAllHistories();				// 전체 기록보기 
	List<History> getAllHistoriesWithDetails();		
	List<History> getHistoriesByTodoId (int id);	// 특정 할일의 모든 기록
	List<History> getHistoriesByMemberId (int id);	// 특정 사용자의 기록
	List<History> getHistoriesByTodoIdWithDetails(int todo_id);
	History getHistoryById (int id);				// 단일 조회
	History getHistoryByIdWithDetails(int id);
	void addHistory (History history);				// 기록 추가
	void updateHistory (History history);			// 기록 수정
	void deleteHistory (int id);					// 기록 삭제
	
}
