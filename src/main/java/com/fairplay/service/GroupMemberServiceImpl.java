package com.fairplay.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fairplay.domain.GroupMember;
import com.fairplay.repository.GroupMemberRepository;

@Service
public class GroupMemberServiceImpl implements GroupMemberService{

	
	private final GroupMemberRepository gmRepo;
	
	// 생성자 주입 방식 (의존성 주입)
	@Autowired
	public GroupMemberServiceImpl(GroupMemberRepository gmRepo) {
		this.gmRepo = gmRepo;
	}
	
	@Override
	public void save(GroupMember groupMember) {
		
		gmRepo.save(groupMember);
	}

	@Override
	public List<GroupMember> findByGroupId(int groupId) {
		
		return gmRepo.findByGroupId(groupId);
	}

	@Override
	public GroupMember findById(int id) {
		
		return gmRepo.findById(id);
	}

	@Override
	public void update(GroupMember groupMember) {
		gmRepo.update(groupMember);
		
	}

	@Override
	public void delete(int id) {
		gmRepo.delete(id);
		
	}

	@Override
	public boolean isGroupMember(int groupId, int memberId) {
		
		return gmRepo.isGroupMember(groupId, memberId);
	}
	
	
}
