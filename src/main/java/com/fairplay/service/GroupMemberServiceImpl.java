package com.fairplay.service;

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
	public void save(GroupMember groupmember) {
		
		
	}

	
}
