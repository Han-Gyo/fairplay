package com.fairplay.service;

import java.util.List;
import com.fairplay.domain.Todo;

public interface TodoService {
	List<Todo> getTodoList();									// 전체 할 일 목록 조회
	void addTodo(Todo todo); 									// 할 일 등록
	void updateTodo(Todo todo);									// 할 일 수정
	void deleteTodo(int id);									// 할 일 삭제
	void completeTodo(int id);									// 완료 처리
	Todo findById(int id);										// 특정 할 일 조회
}

