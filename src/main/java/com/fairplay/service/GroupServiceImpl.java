package com.fairplay.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fairplay.domain.Group;
import com.fairplay.domain.GroupMember;
import com.fairplay.repository.GroupMemberRepository;
import com.fairplay.repository.GroupRepository;

// 그룹 관련 서비스 로직 구현 클래스
@Service
public class GroupServiceImpl implements GroupService{
	
	private final GroupRepository groupRepository;
	private final GroupMemberRepository groupMemberRepository;
	
	// 생성자 주입 방식 (의존성 주입)
	@Autowired
	public GroupServiceImpl(GroupRepository groupRepository,
							GroupMemberRepository groupMemberRepository) {
		this.groupRepository = groupRepository;
		this.groupMemberRepository = groupMemberRepository;
	}

	// 그룹생성 요청으로 전달된 group 데이터를 저장 (Create)
	@Override
	public void save(Group group) {
		
		// 그룹 저장
		groupRepository.save(group);	// group.getId()가 여기서 auto_increment로 생김
		
		// 그룹장 자동 등록
		GroupMember gm = new GroupMember();
		gm.setGroupId(group.getId());				// 생성된 그룹 ID
		gm.setMemberId(group.getLeaderId());		// 그룹 생성자의 ID (컨트롤러에서 set 해줘야 함)
		gm.setRole("LEADER");						// 무조건 LEADER로 지정
		gm.setTotalScore(0);						// 초기값
		gm.setWeeklyScore(0);						// 초기값
		gm.setWarningCount(0);						// 초기값
		
		// 저장
		groupMemberRepository.save(gm);
	}

	// 전체 그룹 목록 조회 (Read_all)
	@Override
	public List<Group> readAll() {
		
		// DB 조회 로직은 Repository에 위임하고 결과 반환
		return groupRepository.readAll();
	}

	// 1개의 그룹 조회 (Read_one)
	@Override
	public Group findById(int id) {
		
		// DB 조회 로직은 Repository에 위임하고 결과 반환
		return groupRepository.findById(id);
	}

	@Override
	public void update(Group group) {
		//그룹수정 요청으로 전달된 group 데이터를 저장 (Update)
		groupRepository.update(group);
		
	}

	// 그룹 삭제 요청을 처리하는 서비스 로직 (Delete)
	@Override
	public void delete(int id) {
		
		// 전달받은 그룹 ID를 기반으로 Repository에 삭제 요청
		groupRepository.delete(id);
		
	}

	@Override
	public void updateLeader(int groupId, int newLeaderId) {
		groupRepository.updateLeader(groupId, newLeaderId);
	}
	
	
}
