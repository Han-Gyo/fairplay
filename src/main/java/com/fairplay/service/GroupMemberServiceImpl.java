package com.fairplay.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fairplay.domain.GroupMember;
import com.fairplay.domain.GroupMemberInfoDTO;
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

	// 그룹 ID로 닉네임/이름 포함한 멤버 정보 조회
	@Override
	public List<GroupMemberInfoDTO> findMemberInfoByGroupId(int groupId) {
		return gmRepo.findMemberInfoByGroupId(groupId);
	}
	
	
	
}
