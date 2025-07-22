package com.fairplay.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fairplay.domain.Group;
import com.fairplay.domain.GroupMember;
import com.fairplay.domain.Member;
import com.fairplay.service.GroupMemberService;
import com.fairplay.service.GroupService;

@Controller
@RequestMapping("/groupmember")
public class GroupMemberController {
	
	private final GroupMemberService groupMemberService;
	private final GroupService groupService;
	
	// 생성자 주입
	@Autowired
	public GroupMemberController(GroupMemberService groupMemberService,
								 GroupService groupService) {
		this.groupMemberService = groupMemberService;
		this.groupService = groupService;
	}
	
	
	// 그룹 가입 폼 보기
	@GetMapping("/create")
	public String createForm(@RequestParam("groupId") int groupId,
							 HttpSession session,
							 RedirectAttributes redirectAttributes,
							 Model model) {
		
		System.out.println("그룹 가입 폼 함수 입장");
		
		// 로그인 확인
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
			redirectAttributes.addFlashAttribute("msg", "로그인이 필요합니다.");
			return "redirect:/member/login";
		}
		
		// 그룹 정보 확인
		Group group = groupService.findById(groupId);
		if (group == null) {
			redirectAttributes.addFlashAttribute("msg", "존재하지 않는 그룹입니다.");
			return "redirect:/group/list";
		}
		
		// 뷰로 group 데이터 전달
		model.addAttribute("group", group);
		return "groupMemberCreateForm";
	}
	
	
	// 그룹 가입 처리
	@PostMapping("/create")
	public String createGroupMember(@RequestParam("groupId") int groupId,
	                                @RequestParam(value = "inviteCode", required = false) String inviteCode,
	                                HttpSession session,
	                                RedirectAttributes redirectAttributes) {

	    // 세션에서 로그인한 사용자 확인
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        redirectAttributes.addFlashAttribute("msg", "로그인이 필요합니다.");
	        return "redirect:/member/login";
	    }

	    // 그룹 정보 가져오기
	    Group group = groupService.findById(groupId);
	    if (group == null) {
	        redirectAttributes.addFlashAttribute("msg", "존재하지 않는 그룹입니다.");
	        return "redirect:/group/list";
	    }

	    // ❗ 초대코드가 null이면 빈 문자열로 처리 (null 예외 방지)
	    if (inviteCode == null || !inviteCode.equals(group.getCode())) {
	        redirectAttributes.addFlashAttribute("msg", "초대코드가 올바르지 않습니다.");
	        return "redirect:/groupmember/create?groupId=" + groupId;
	    }

	    // 가입 처리
	    GroupMember groupMember = new GroupMember();
	    groupMember.setGroupId(groupId);
	    groupMember.setMemberId(loginMember.getId());
	    groupMember.setWeeklyScore(0);
	    groupMember.setTotalScore(0);
	    groupMember.setWarningCount(0);
	    groupMember.setRole("MEMBER");

	    groupMemberService.save(groupMember);

	    redirectAttributes.addFlashAttribute("msg", "그룹에 성공적으로 가입되었습니다.");
	    return "redirect:/group/detail?id=" + groupId;
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
