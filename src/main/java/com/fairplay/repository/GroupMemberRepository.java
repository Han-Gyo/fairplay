 package com.fairplay.repository;

import java.util.List;

import com.fairplay.domain.GroupMember;
import com.fairplay.domain.GroupMemberInfoDTO;

public interface GroupMemberRepository {

	void save(GroupMember groupMember);
	
	List<GroupMember> findByGroupId(int groupId);
	
	GroupMember findById(int id);
	
	void update(GroupMember groupmember);
	
	void delete(int id);
	
	boolean isGroupMember(int groupId, int memberId);
	
	// 그룹 ID로 그룹 멤버 정보(닉네임, 이름 포함) 조회
	List<GroupMemberInfoDTO> findMemberInfoByGroupId(int groupId);
	
}
