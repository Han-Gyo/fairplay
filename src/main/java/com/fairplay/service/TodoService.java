package com.fairplay.service;

import java.util.List;
import com.fairplay.domain.Todo;

public interface TodoService {
	List<Todo> getTodoList();                   // 전체 할 일 조회
	void addTodo(Todo todo);                    // 할 일 추가
	void updateTodo(Todo todo);                 // 할 일 수정
	void deleteTodo(int id);                    // 할 일 삭제
	void completeTodo(int id);                  // 할 일 완료 처리
	Todo findById(int id);                      // ID로 할 일 조회
}

