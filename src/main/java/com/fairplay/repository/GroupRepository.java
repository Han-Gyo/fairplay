package com.fairplay.repository;

import java.util.List;

import com.fairplay.domain.Group;

public interface GroupRepository {
	void save(Group group);			// 그룹 저장
	List<Group> readAll();			// 전체 그룹 조회
	
}
