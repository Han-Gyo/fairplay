package com.fairplay.repository;

import java.time.LocalDate;
import java.util.List;
import com.fairplay.domain.Todo;
import com.fairplay.domain.TodoSimple;

public interface TodoRepository {
	// ✅ 기본 CRUD
	List<Todo> findAll();                     				// 전체 할 일 목록 조회
	Todo findById(int id);                    				// ID로 특정 할 일 조회
	void insert(Todo todo);                   				// 할 일 등록
	void update(Todo todo);                   				// 할 일 수정
	void deleteById(int id);                 				// ID로 할 일 삭제

	// ✅ 상태 관련
	void complete(int id);                    				// 할 일 완료 처리

	// ✅ 신청 관련
	void updateAssignedStatus(int todoId, int memberId); 	// 담당자 등록
	void resetAssignedStatus(int todoId);                 	// 담당자 해제 (신청 취소)
	List<Todo> findByAssignedMember(int memberId);       	// 특정 사용자의 할 일 조회
	List<Todo> findCompletedTodos();
	List<Todo> findNotDone(int memberId);
	List<TodoSimple> findTodosByDateAndMember(LocalDate date, int memberId);
	List<Todo> findByGroupId(int groupId);
	List<Todo> findByGroupIdAndAssignedTo(int groupId, int memberId);
	List<Todo> findCompletedWithoutHistory(int groupId, int memberId);
}