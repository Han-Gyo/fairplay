package com.fairplay.service;

import java.util.List;

import com.fairplay.domain.GroupMember;
import com.fairplay.domain.GroupMemberInfoDTO;

public interface GroupMemberService {

	void save(GroupMember groupMember);				// 그룹 가입 등록 (가입 처리)
	
	List<GroupMember> findByGroupId(int groupId);	// 특정 그룹에 속한 멤버 전체 조회
	
	GroupMember findById(int id);					// 그룹멤버 PK(id)로 단일 멤버 조회 (수정/삭제 시 사용)
	
	void update(GroupMember groupMember);			// 그룹멤버 정보 수정 (역할, 점수, 경고 등)
	
	void delete(int groupId, int memberId);
	
	boolean isGroupMember(int groupId, int memberId);
	
	// 그룹 ID로 그룹 멤버 정보 (nickname, realName 포함된 DTO) 조회
	List<GroupMemberInfoDTO> findMemberInfoByGroupId(int groupId);
	
	// 현재 인원 수 조회용 메서드
	int countByGroupId(int groupId);
	
	// 그룹장 전용 탈퇴 처리 
	void leaveGroup(int memberId, int groupId);
	
	// 특정 멤버의 그룹 내 역할 조회 (LEADER or MEMBER)
	String findRoleByMemberIdAndGroupId(int memberId, int groupId);
}
