package com.fairplay.service;

import java.util.Date;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fairplay.domain.GroupMonthlyScore;
import com.fairplay.domain.History;
import com.fairplay.domain.MemberMonthlyScore;
import com.fairplay.repository.HistoryRepository;

@Service
public class HistoryServiceImpl implements HistoryService{
	
	@Autowired
	private HistoryRepository historyRepository;
	
	// 기록 전체 보기
	@Override
	public List<History> getAllHistories() {
		return historyRepository.findAll();
	}
	
	
	@Override
	public History getHistoryByIdWithDetails(int id) {
	    History history = historyRepository.findByIdWithDetails(id);

	    Date latestCommentDate = historyRepository.findLatestCommentDateByHistoryId(history.getId());
	    if (latestCommentDate != null && latestCommentDate.after(history.getCompleted_at())) {
	        history.setNewComment(true);
	    }

	    return history;
	}

	@Override
	public List<History> getAllHistoriesWithDetails() {
	    List<History> historyList = historyRepository.findAllWithDetails();

	    for (History history : historyList) {
	        Date latestCommentDate = historyRepository.findLatestCommentDateByHistoryId(history.getId());
	        if (latestCommentDate != null && latestCommentDate.after(history.getCompleted_at())) {
	            history.setNewComment(true);
	        }
	    }

	    return historyList;
	}
	
	@Override
	public List<History> getHistoriesByGroupIdWithDetails(int groupId) {
	    // 그룹 ID로 히스토리 조회 및 코멘트 여부 확인
	    List<History> historyList = historyRepository.findAllWithDetailsByGroupId(groupId);

	    for (History history : historyList) {
	        Date latestCommentDate = historyRepository.findLatestCommentDateByHistoryId(history.getId());
	        if (latestCommentDate != null && latestCommentDate.after(history.getCompleted_at())) {
	            history.setNewComment(true);
	        }
	    }
	    return historyList;
	}
	
	// 기록 추가
	@Override
	public void addHistory(History history) {
		historyRepository.save(history);
		
	}

	// id로 기록 조회
	@Override
	public History getHistoryById(int id) {
		return historyRepository.findById(id);
	}

	// 특정 할일의 기록 목록 조회
	@Override
	public List<History> getHistoriesByTodoId(int todo_id) {
		return historyRepository.findByTodoId(todo_id);
	}

	// 특정 멤버의 기록 목록 조회
	@Override
	public List<History> getHistoriesByMemberId(int member_id) {
		return historyRepository.findByMemberId(member_id);
	}

	// 기록 수정
	@Override
	public void updateHistory(History history) {
		historyRepository.update(history);
	}

	// 기록삭제
	@Override
	public void deleteHistory(int id) {
		historyRepository.delete(id);
	}

	@Override
	public List<History> getHistoriesByTodoIdWithDetails(int todo_id) {
		return historyRepository.findByTodoIdWithDetails(todo_id);
	}


	@Override
	public List<GroupMonthlyScore> getGroupMonthlyScore(int groupId, String yearMonth) {
		System.out.println("📌 [Service] 그룹 월간 점수 요청 - groupId: " + groupId + ", yearMonth: " + yearMonth);
		return historyRepository.findGroupMonthlyScore(groupId, yearMonth);
	}


	@Override
	public List<MemberMonthlyScore> getMemberMonthlyScore(int groupId, String yearMonth) {
		System.out.println("📌 [Service] 멤버 월간 점수 요청 - groupId: " + groupId + ", yearMonth: " + yearMonth);
		return historyRepository.findMemberMonthlyScore(groupId, yearMonth);
	}

}
