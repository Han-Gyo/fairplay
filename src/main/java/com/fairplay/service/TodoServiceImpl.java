package com.fairplay.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fairplay.domain.Todo;
import com.fairplay.repository.TodoRepository;

@Service
public class TodoServiceImpl implements TodoService{

	@Autowired
	private TodoRepository todoRepository;

	// ✅ 전체 목록 조회
	@Override
	public List<Todo> getTodoList() {
		System.out.println("📋 할 일 전체 목록 조회");
		return todoRepository.findAll();
	}
	// ✅ 할 일 추가
	@Override
	public void addTodo(Todo todo) {
		// todo.setCompleted(false);
		todoRepository.insert(todo);
		
		System.out.println("할 일 추가됨 : " + todo.getTitle());
	}
	// ✅ 할 일 수정
	@Override
	public void updateTodo(Todo todo) {
		todoRepository.update(todo);
		System.out.println("✏️ 할 일 수정됨: " + todo);
	}
	// ✅ 할 일 삭제
	@Override
	public void deleteTodo(int id) {
		todoRepository.deleteById(id);
		System.out.println("🗑️ 삭제된 ID: " + id);
	}
	// ✅ 할 일 완료 처리
	@Override
	public void completeTodo(int id) {
		todoRepository.complete(id);
		System.out.println("✅ 완료 처리된 ID: " + id);
	}
	// ✅ 특정 ID로 할 일 하나 조회
	@Override
	public Todo findById(int id) {
		return todoRepository.findById(id);
	}
}