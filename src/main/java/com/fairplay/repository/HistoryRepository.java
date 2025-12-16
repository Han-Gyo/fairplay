package com.fairplay.repository;

import java.util.Date;
import java.util.List;

import com.fairplay.domain.GroupMonthlyScore;
import com.fairplay.domain.History;
import com.fairplay.domain.MemberMonthlyScore;

public interface HistoryRepository {

	// 📌 기본 히스토리 조회
	List<History> findAll();							// 전체 기록 조회
	List<History> findByTodoId(int todo_id);			// 특정 할일의 기록 조회
	List<History> findByMemberId(int member_id);		// 특정 멤버의 기록 조회
	History findById(int id);							// ID로 단일 기록 조회

	// 📌 상세 히스토리 조회 (연관 정보 포함)
	List<History> findAllWithDetails();					// 전체 기록 + 할 일 제목 + 멤버 닉네임
	List<History> findByTodoIdWithDetails(int todo_id);	// 특정 할일의 기록 + 멤버 정보
	History findByIdWithDetails(int id);				// 단일 기록 상세 조회 + 연관 정보

	// 📌 히스토리 저장/수정/삭제
	void save(History history); 						// 기록 추가
	void update(History history); 						// 기록 수정
	void delete(int id);								// 기록 삭제

	// 📌 부가 기능
	Date findLatestCommentDateByHistoryId(int historyId);	// 가장 최근 댓글 작성일 조회

	// 📌 통계 관련
	List<GroupMonthlyScore> findGroupMonthlyScore(int groupId, String yearMonth);	// 그룹별 월간 점수
	List<MemberMonthlyScore> findMemberMonthlyScore(int groupId, String yearMonth);	// 멤버별 월간 점수
	List<History> findAllWithDetailsByGroupId(int groupId);

}
