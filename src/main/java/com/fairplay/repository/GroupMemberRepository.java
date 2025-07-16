package com.fairplay.repository;

import java.util.List;

import com.fairplay.domain.GroupMember;

public interface GroupMemberRepository {

	void save(GroupMember groupMember);
	
	List<GroupMember> findByGroupId(int groupId);
	
	GroupMember findById(int id);
	
	void update(GroupMember groupmember);
	
	void delete(int id);
	
	
}
