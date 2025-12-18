package com.fairplay.service;

import java.util.List;

import com.fairplay.domain.GroupMonthlyScore;
import com.fairplay.domain.History;
import com.fairplay.domain.MemberMonthlyScore;

public interface HistoryService {

	// 조회 기능
	List<History> getAllHistories();															// 전체 기록 조회
	List<History> getAllHistoriesWithDetails();										// 전체 기록 + 제목/닉네임 포함
	List<History> getHistoriesByTodoId(int id);										// 특정 할일의 기록 목록
	List<History> getHistoriesByMemberId(int id);									// 특정 멤버의 기록 목록
	List<History> getHistoriesByTodoIdWithDetails(int todo_id);		// 특정 할일 + 상세정보 포함
	List<History> getHistoriesByGroupIdWithDetails(int groupId);	// 그룹별 기록 + 제목/닉네임 포함
	History getHistoryById(int id);																// 기록 1건 조회
	History getHistoryByIdWithDetails(int id);										// 기록 1건 + 제목/닉네임 포함

	// 수정/등록/삭제 기능
	void addHistory(History history);															// 기록 추가
	void updateHistory(History history);													// 기록 수정
	void deleteHistory(int id);																		// 기록 삭제

	// 월간 점수 기능
	List<GroupMonthlyScore> getGroupMonthlyScore(int groupId, String yearMonth);		// 그룹별 월간 점수
	List<MemberMonthlyScore> getMemberMonthlyScore(int groupId, String yearMonth);	// 멤버별 월간 점수
}
