package com.fairplay.repository;

import java.util.List;

import com.fairplay.domain.Group;

public interface GroupRepository {
	void save(Group group);			// 그룹 저장
	List<Group> readAll();			// 전체 그룹 조회
	Group findById(int id);			// ID 기반 단일 조회
	void update(Group group);		// 그룹 정보 수정
	void delete(int id);			// 그룹 삭제
}
