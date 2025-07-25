package com.fairplay.service;

import java.util.List;
import com.fairplay.domain.Todo;

public interface TodoService {
	// ✅ 기본 CRUD
	List<Todo> getTodoList();                     // 전체 할 일 목록 조회
	Todo findById(int id);                        // ID로 특정 할 일 조회
	void addTodo(Todo todo);                      // 새로운 할 일 등록
	void updateTodo(Todo todo);                   // 기존 할 일 수정
	void deleteTodo(int id);                      // 할 일 삭제

	// ✅ 상태 관련
	void completeTodo(int id);                    // 할 일 완료 처리

	// ✅ 신청 관련
	boolean assignTodo(int todoId, int memberId); // 할 일 담당자 신청 (선착순)
	void unassignTodo(int todoId);                // 신청 취소 (담당자 해제)
	List<Todo> getTodosByMemberId(int memberId);  // 특정 사용자가 신청한 할 일 목록
	List<Todo> getCompletedTodos();
	List<Todo> findNotDone(int memberId);
}

