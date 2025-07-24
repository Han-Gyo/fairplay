package com.fairplay.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fairplay.domain.GroupMember;
import com.fairplay.domain.GroupMemberInfoDTO;
import com.fairplay.repository.GroupMemberRepository;
import com.fairplay.repository.GroupRepository;

@Service
public class GroupMemberServiceImpl implements GroupMemberService{

	
	private final GroupMemberRepository gmRepo;
	private final GroupRepository groupRepository;
	
	// 생성자 주입 방식 (의존성 주입)
	@Autowired
	public GroupMemberServiceImpl(GroupMemberRepository gmRepo,
								  GroupRepository groupRepository) {
		this.gmRepo = gmRepo;
		this.groupRepository = groupRepository;
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
	public void delete(int groupId, int memberId) {
		System.out.println("삭제 요청 들어옴: " + groupId + ", " + memberId);  // 삭제 요청으로 Id 값들 잘 들어오는지 확인
		gmRepo.delete(groupId, memberId);
		
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

	// 그룹 멤버 수 조회
	@Override
	public int countByGroupId(int groupId) {
	    return gmRepo.countByGroupId(groupId); 
	}

	// 그룹 탈퇴 로직 구현
	@Override
	public void leaveGroup(int memberId, int groupId) {
		
		// 그룹 멤버에서 본인 row 삭제
		gmRepo.deleteByMemberIdAndGroupId(memberId, groupId);
		
		// 삭제 후 남은 인원 수 체크
		int remaining = gmRepo.countByGroupId(groupId);
		
		// 남은 인원이 0이면 그룹 자체 삭제
		if (remaining == 0) {
			groupRepository.deleteById(groupId);
		}
	}

	// 그룹 내 역할 조회
	@Override
	public String findRoleByMemberIdAndGroupId(int memberId, int groupId) {
		return gmRepo.findRoleByMemberIdAndGroupId(memberId, groupId);
	}

	
	
	
	
}
