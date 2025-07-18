package com.fairplay.repository;

import java.util.List;

import com.fairplay.domain.History;

public interface HistoryRepository {
	List<History> findAll();					// 기록 전체보기
	List<History> findAllWithDetails();			// 히스토리 + 제목 + 닉네임 포함 전체 조회
	List<History> findByTodoId(int todo_id);	// 특정 할일에 대한 모든 기록 가져오기
	List<History> findByMemberId(int member_id);// 특정 멤버가 한 모든 기록 가져오기
	List<History> findByTodoIdWithDetails(int todo_id); // ✨ 추가
	History findById(int id);					// id로 기록 하나 가져오기 (select)
	History findByIdWithDetails(int id);		// 상세 조회용 (id로 단일 히스토리 조회 + 제목/닉네임 포함)
	void save(History history); 				// 기록 하나 추가 (insert)
	void update (History history); 				// 기록 수정
	void delete (int id);						// 기록 삭제
}
