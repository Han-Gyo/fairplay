package com.fairplay.repository;

import java.util.List;

import com.fairplay.domain.Group;

public interface GroupRepository {
	void save(Group group);									// 그룹 저장
	List<Group> readAll();									// 전체 그룹 조회
	Group findById(int id);									// ID 기반 단일 조회
	void update(Group group);								// 그룹 정보 수정
	void delete(int id);									// 그룹 삭제
	void deleteById(int groupId);							// 그룹 테이블에서 해당 그룹 ID로 그룹 자체 삭제
	void updateLeader(int groupId, int newLeaderId);		// 그룹 리더 변경 SQL 메서드 선언
}