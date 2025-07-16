package com.fairplay.service;

import java.util.List;

import com.fairplay.domain.Group;

public interface GroupService {
	
	void save (Group group);			// 그룹 등록
	
	List<Group> readAll();				// 전체 그룹 조회
	
	Group findById(int id);				// ID 기반 단일 조회
	
	void update(Group group);			// 그룹 수정
	
	void delete(int id);				// 그룹 삭제
}
