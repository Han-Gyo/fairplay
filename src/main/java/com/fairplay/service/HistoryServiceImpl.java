package com.fairplay.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.fairplay.domain.History;
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
	public void addHistory(History history) {
		// 기록 추가
		historyRepository.save(history);
		
	}

	@Override
	public History getHistoryById(int id) {
		// id로 기록 조회
		return historyRepository.findById(id);
	}

	@Override
	public List<History> getHistoriesByTodoId(int todo_id) {
		// 특정 할일의 기록 목록 조회
		return historyRepository.findByTodoId(todo_id);
	}

	@Override
	public List<History> getHistoriesByMemberId(int member_id) {
		// 특정 멤버의 기록 목록 조회
		return historyRepository.findByMemberId(member_id);
	}

	@Override
	public void updateHistory(History history) {
		// 기록 수정
		historyRepository.update(history);
	}

	@Override
	public void deleteHistory(int id) {
		// 기록삭제
		historyRepository.delete(id);
	}

}
