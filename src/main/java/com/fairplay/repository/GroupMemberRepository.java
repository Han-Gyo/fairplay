 package com.fairplay.repository;

import java.util.List;

import com.fairplay.domain.GroupMember;
import com.fairplay.domain.GroupMemberInfoDTO;

public interface GroupMemberRepository {

	void save(GroupMember groupMember);
	
	List<GroupMember> findByGroupId(int groupId);
	
	GroupMember findById(int id);
	
	void update(GroupMember groupmember);
	
	void delete(int groupId, int memberId);
	
	boolean isGroupMember(int groupId, int memberId);
	
	// 그룹 ID로 그룹 멤버 정보(닉네임, 이름 포함) 조회
	List<GroupMemberInfoDTO> findMemberInfoByGroupId(int groupId);
	
	// 현재 인원 수 조회용 메서드
	int countByGroupId(int groupId);

	// 그룹장 탈퇴 전용 처리
	void deleteByMemberIdAndGroupId(int memberId, int groupId);
	
	// 그룹 내에서 해당 멤버의 역할 조회
	String findRoleByMemberIdAndGroupId(int memberId, int groupId);
	
}
