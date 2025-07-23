package com.fairplay.repository;

import java.util.List;
import com.fairplay.domain.Todo;

public interface TodoRepository {
	List<Todo> findAll();              		// 전체 할 일 목록 조회
	void insert(Todo todo);          	  	// 할 일 등록
	void update(Todo todo);            		// 할 일 수정
	void deleteById(int id);           		// ID로 할 일 삭제
	void complete(int id);             		// ID로 할 일 완료 처리
	Todo findById(int id);             		// ID로 할 일 조회
	void updateAssignedStatus(int todoId, int memberId);
}