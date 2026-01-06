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
import com.fairplay.domain.GroupMemberInfoDTO;
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
		
		System.out.println("그룹 가입 폼 함수 입장"); // 문제 없으면 삭제
		
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
	public String list(@RequestParam("groupId")int groupId,
					   HttpSession session,
					   Model model) {
		
		// 그룹 정보 조회
		Group group = groupService.findById(groupId);
		if (group == null) {
			return "redirect:/group/groups";	// 잘못된 그룹 ID 조회 경우 목록으로 리다이렉트
		}
		
		// 닉네임/실명 포함된 멤버 정보 조회 (DTO 기반)
		List<GroupMemberInfoDTO> groupMembers = groupMemberService.findMemberInfoByGroupId(groupId);
		model.addAttribute("groupMembers", groupMembers);	// 전체 멤버 리스트 전달
		model.addAttribute("group", group);	// 그룹 정보 전달
		
		// 로그인 사용자 정보 추출
		Member loginMember = (Member) session.getAttribute("loginMember");
		// JSP에서 조건 분기용
		model.addAttribute("loginMember", loginMember);
		
		// 로그인 사용자가 해당 그룹에 가입한 상태인지 확인
		boolean isMember = false;
		if (loginMember != null) {
			isMember = groupMemberService.isGroupMember((long) groupId, (long) loginMember.getId());
		}
		model.addAttribute("isMember", isMember);	// JSP 조건 판단용
		
		return "groupMemberList";	// 뷰 페이지로 이동
		
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
	
	// 그룹장이 다른 멤버를 강퇴하거나 본인이 스스로 탈퇴할 수 있도록 처리 (Delete)
	@PostMapping("delete")
	public String delete(@RequestParam int groupId,
						 @RequestParam int memberId,
						 HttpSession session) {
		
		// id 값들 제대로 받아왔는지 확인 문제 없으면 삭제
		System.out.println("삭제 요청 들어옴" + "groupId = " + groupId);
		System.out.println("삭제 요청 들어옴" + "memberId = " + memberId);
		
		// 로그인 여부 체크
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
			// 로그인하지 않은 사용자는 로그인 페이지로 이동
			return "redirect:/member/login";
		}
		
		// 그룹 정보 조회 (리더 ID 확인용)
		Group group = groupService.findById(groupId);
		
		// 본인 탈퇴인지 확인
		boolean isSelf = loginMember.getId() == memberId;
		
		// 그룹장(리더)이 다른 멤버를 강퇴하는 경우인지 확인
		boolean isLeaderKick = loginMember.getId() == group.getLeaderId();
		
		
		// 위 두 조건에 해당하지 않으면 -> 무단 접근으로 간주하고 -> 차단
		if (!isSelf && !isLeaderKick) {
			return "redirect:/group/detail?id=" + groupId;
		}
		
		// 탈퇴 또는 강퇴 처리
		groupMemberService.delete(groupId, memberId);
		
		// 본인이 스스로 탈퇴한 경우 -> 홈으로 이동
		if (isSelf) {
			return "redirect:/";
		}
		
		
		// 그룹장이 다른 멤버를 강퇴한 경우 -> 그룹 멤버 목록 페이지로 이동
		return "redirect:/groupmember/list?groupId=" + groupId;
	}
	
	
	 
	// 그룹장이면서 멤버가 1명일 경우에만 탈퇴 가능 (그룹장 혼자 그룹에 있을 때)
	@PostMapping("/leave")
	public String leaveGroup(@RequestParam("groupId") int groupId,
	                         HttpSession session,
	                         RedirectAttributes ra) {

	    // 세션에서 로그인한 사용자 정보 가져오기
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    int memberId = loginMember.getId();

	    // 현재 사용자의 그룹 내 역할 조회 (LEADER or MEMBER)
	    String role = groupMemberService.findRoleByMemberIdAndGroupId(memberId, groupId);

	    // 현재 그룹 멤버 수 조회
	    int memberCount = groupMemberService.countByGroupId(groupId);

	    // 그룹장인데 다른 멤버가 있는 경우 → 탈퇴 불가
	    if ("LEADER".equals(role) && memberCount > 1) {
	        ra.addFlashAttribute("msg", "그룹장이 탈퇴하려면 먼저 다른 멤버에게 리더를 위임해야 합니다.");
	        return "redirect:/group/detail?id=" + groupId;
	    }

	    // 리더이면서 혼자일 경우 -> 그룹 삭제
	    if ("LEADER".equals(role) && memberCount == 1) {
	    	
	        groupService.delete(groupId); // 그룹 삭제
	    }

	    // 공통 탈퇴 처리
	    groupMemberService.leaveGroup(memberId, groupId); 

	    ra.addFlashAttribute("msg", "그룹에서 탈퇴되었습니다.");
	    return "redirect:/group/groups";
	}

	
	// 위임 대상 선택 폼 이동
	@GetMapping("/transferForm")
	public String showTransferForm(@RequestParam("groupId") int groupId, Model model) {
		
		// 그룹 정보
		Group group = groupService.findById(groupId);
		model.addAttribute("group", group);
		
		// 그룹 내 일반 멤버 목록 (리더 제외)
		List<GroupMemberInfoDTO> members = groupMemberService.findMembersExcludingLeader(groupId);
		model.addAttribute("members", members);
		
		return "transferForm";
	}
	
	// 위임 대상 선택 후 처리
	@PostMapping("/transferAndLeave")
	public String transferLeaderAndLeave(@RequestParam("groupId") int groupId,
										 @RequestParam("newLeaderId") int newLeaderId,
										 HttpSession session,
										 RedirectAttributes ra) {
		
		Member loginMember = (Member) session.getAttribute("loginMember");
		int currentLeaderId = loginMember.getId();
		
		// 리더 권한 위임
		groupMemberService.updateRoleToLeader(groupId, newLeaderId);
		
		// group 테이블의 leader_id 업데이트
		groupService.updateLeader(groupId, newLeaderId);
		
		// 기존 그룹장 탈퇴 (group_member 행 삭제)
		groupMemberService.leaveGroup(currentLeaderId, groupId);
		
		ra.addFlashAttribute("msg", "리더 권한을 위임하고 그룹을 탈퇴했습니다.");
		return "redirect:/group/groups";
	}
	
}
