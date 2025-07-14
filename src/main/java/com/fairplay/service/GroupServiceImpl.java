package com.fairplay.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fairplay.domain.Group;
import com.fairplay.repository.GroupRepository;

@Service
public class GroupServiceImpl implements GroupService{
	
	private final GroupRepository groupRepository;
	
	// 생성자 주입 방식 (의존성 주입)
	@Autowired
	public GroupServiceImpl(GroupRepository groupRepository) {
		this.groupRepository = groupRepository;
	}

	// 그룹생성 요청으로 전달된 group 데이터를 저장 (Create)
	@Override
	public void save(Group group) {
		groupRepository.save(group);
		
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
		// TODO Auto-generated method stub
		
	}

	@Override
	public void delete(int id) {
		// TODO Auto-generated method stub
		
	}
	
	
}
