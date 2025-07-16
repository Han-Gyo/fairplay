package com.fairplay.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.fairplay.domain.GroupMember;
import com.fairplay.service.GroupMemberService;

@Controller
@RequestMapping("/groupmember")
public class GroupMemberController {
	
	private final GroupMemberService groupMemberService;
	
	// 생성자 주입
	@Autowired
	public GroupMemberController(GroupMemberService groupMemberService) {
		this.groupMemberService = groupMemberService;
	}
	
	
	// 그룹 가입 폼 보기
	@GetMapping("/create")
	public String createForm() {
		return "groupMemberCreateForm";
	}
	
	
	// 그룹 가입 처리
	@PostMapping("/create")
	public String create(@ModelAttribute GroupMember groupMember) {
		
		// 점수 필드 기본값 세팅
		groupMember.setWeeklyScore(0);
		groupMember.setTotalScore(0);
		groupMember.setWarningCount(0);
		
		// 역할 MEMBER 강제 지정 (추후 확장 가능)
		groupMember.setRole("MEMBER");
		
		// 그룹 가입 정보 저장
		groupMemberService.save(groupMember);
		
		// 그룹 목록 페이지로 리다이렉트
		return "redirect:/group/groups";
		
	}
	
	
}
