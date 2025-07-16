package com.fairplay.repository;

import java.util.List;
import com.fairplay.domain.Todo;

public interface TodoRepository {
	List<Todo> findAll();		// 전체 목록
	void insert(Todo todo);		// 등록
	void update(Todo todo);		// 수정
	void deleteById(int id);	// 삭제
	void complete(int id);		// 완료
	Todo findById(int id);		// 특정 할 일 조회
}