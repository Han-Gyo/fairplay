package com.fairplay.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
		System.out.println("그룹 가입 폼 함수 입장");
		return "groupMemberCreateForm";
	}
	
	
	// 그룹 가입 처리
	@PostMapping("/create")
	public String create(@ModelAttribute GroupMember groupMember) {
		System.out.println("그룹 가입 처리 함수 입장");
		
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
	
	// 특정 그룹의 멤버 전체 조회 (Read_all)
	@GetMapping("/list")
	public String list(@RequestParam("groupId")int groupId, Model model) {
		
		// Service를 통해 그룹 ID로 멤버 리스트 조회
		List<GroupMember> groupMembers = groupMemberService.findByGroupId(groupId);
		
		// 조회된 리스트를 모델에 담아 뷰로 전달
		model.addAttribute("groupMembers", groupMembers);
		
		return "groupMemberList";
		
	}
	
	// 특정 그룹 멤버 수정하는 뷰페이지 이동
	@GetMapping("/edit")
	public String editForm(@RequestParam("id")int id, Model model) {
		GroupMember gm = groupMemberService.findById(id);
		model.addAttribute("groupMember", gm);
		return "groupMemberEditForm";
	}
	
	// 특정 그룹 멤버 수정 (update)
	@PostMapping("update")
	public String update(@ModelAttribute GroupMember groupMember) {
		groupMemberService.update(groupMember);
		return "redirect:/groupmember/list?groupId=" + groupMember.getGroupId();
	}
	
	// 특정 그룹 멤버 추방 (Delete)
	@GetMapping("delete")
	public String delete(@RequestParam("id")int id, @RequestParam("groupId") int groupId) {
		
		// 삭제 로직 실행
		groupMemberService.delete(id);
		
		// 2. 삭제 후, 해당 그룹의 멤버 목록 페이지로 리다이렉트 → groupId를 다시 전달해야 해당 그룹 멤버 목록을 조회할 수 있음
		return "redirect:/groupmember/list?groupId=" + groupId;
	}
}
