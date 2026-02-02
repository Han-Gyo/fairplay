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

		// 로그인 확인
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

		// 정원 체크
		int currentMemberCount = groupMemberService.countByGroupId(groupId);
		if (group.getMaxMember() != null && currentMemberCount >= group.getMaxMember()) {
			redirectAttributes.addFlashAttribute("msg", "그룹 정원이 가득 차서 가입할 수 없습니다.");
			return "redirect:/group/detail?id=" + groupId;
		}

		// 초대코드 검증
		if (inviteCode == null || !inviteCode.equals(group.getCode())) {
			redirectAttributes.addFlashAttribute("msg", "초대코드가 올바르지 않습니다.");
			return "redirect:/groupmember/create?groupId=" + groupId;
		}

		// 가입 처리
		GroupMember groupMember = new GroupMember();
		groupMember.setGroupId(groupId);
		groupMember.setMemberId(loginMember.getId());
		groupMember.setMonthlyScore(0);
		groupMember.setTotalScore(0);
		groupMember.setWarningCount(0);
		groupMember.setRole("MEMBER");

		groupMemberService.save(groupMember);

		redirectAttributes.addFlashAttribute("msg", "그룹에 성공적으로 가입되었습니다.");
		return "redirect:/group/detail?id=" + groupId;
	}

	// 특정 그룹의 멤버 전체 조회
	@GetMapping("/list")
	public String list(@RequestParam("groupId")int groupId,
					   HttpSession session,
					   Model model) {
		
		Group group = groupService.findById(groupId);
		if (group == null) {
			return "redirect:/group/groups";
		}
		
		List<GroupMemberInfoDTO> groupMembers = groupMemberService.findMemberInfoByGroupId(groupId);
		model.addAttribute("groupMembers", groupMembers);
		model.addAttribute("group", group);
		
		Member loginMember = (Member) session.getAttribute("loginMember");
		model.addAttribute("loginMember", loginMember);
		
		boolean isMember = false;
		if (loginMember != null) {
			isMember = groupMemberService.isGroupMember((long) groupId, (long) loginMember.getId());
		}
		model.addAttribute("isMember", isMember);
		
		return "groupMemberList";
	}
	
	// 특정 그룹 멤버 수정하는 뷰페이지 이동
	@GetMapping("/edit")
	public String editForm(@RequestParam("id")int id, HttpSession session, Model model) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		GroupMember gm = groupMemberService.findById(id);
		Group group = groupService.findById(gm.getGroupId());

		// ✅ 권한 체크: 리더거나 자기 자신만 수정 가능
		if (loginMember == null || 
			(loginMember.getId() != group.getLeaderId() && loginMember.getId() != gm.getMemberId())) {
			return "redirect:/groupmember/list?groupId=" + gm.getGroupId();
		}

		model.addAttribute("groupMember", gm);
		model.addAttribute("group", group);
		return "groupMemberEditForm";
	}
	
	// 특정 그룹 멤버 수정
	@PostMapping("/update")
	public String update(@ModelAttribute GroupMember groupMember, HttpSession session) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		Group group = groupService.findById(groupMember.getGroupId());

		// ✅ 권한 체크: 리더거나 자기 자신만 수정 가능
		if (loginMember == null || 
			(loginMember.getId() != group.getLeaderId() && loginMember.getId() != groupMember.getMemberId())) {
			return "redirect:/groupmember/list?groupId=" + groupMember.getGroupId();
		}

		groupMemberService.update(groupMember);
		return "redirect:/groupmember/list?groupId=" + groupMember.getGroupId();
	}
	
	// 그룹장이 다른 멤버를 강퇴하거나 본인이 스스로 탈퇴할 수 있도록 처리
	@PostMapping("/delete")
	public String delete(@RequestParam int groupId,
						 @RequestParam int memberId,
						 HttpSession session) {
		
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/member/login";
		}
		
		Group group = groupService.findById(groupId);
		
		boolean isSelf = loginMember.getId() == memberId;
		boolean isLeaderKick = loginMember.getId() == group.getLeaderId();
		
		if (!isSelf && !isLeaderKick) {
			return "redirect:/group/detail?id=" + groupId;
		}
		
		groupMemberService.delete(groupId, memberId);
		
		if (isSelf) {
			return "redirect:/";
		}
		
		return "redirect:/groupmember/list?groupId=" + groupId;
	}
	
	// 그룹장이면서 멤버가 1명일 경우 혹은 일반 멤버 탈퇴 처리
	@PostMapping("/leave")
	public String leaveGroup(@RequestParam("groupId") int groupId,
							 HttpSession session,
							 RedirectAttributes ra) {

		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/member/login";
		}
		
		int memberId = loginMember.getId();
		String role = groupMemberService.findRoleByMemberIdAndGroupId(memberId, groupId);
		int memberCount = groupMemberService.countByGroupId(groupId);

		if ("LEADER".equals(role) && memberCount > 1) {
			ra.addFlashAttribute("msg", "다른 멤버가 있는 경우 리더 권한을 위임해야 합니다.");
			return "redirect:/groupmember/transferForm?groupId=" + groupId;
		}

		if ("LEADER".equals(role) && memberCount <= 1) {
			groupService.delete(groupId); 
		}

		groupMemberService.leaveGroup(memberId, groupId); 

		ra.addFlashAttribute("msg", "그룹에서 성공적으로 탈퇴되었습니다.");
		return "redirect:/group/groups";
	}

    // 위임 대상 선택 폼 이동
    @GetMapping("/transferForm")
    public String showTransferForm(@RequestParam("groupId") int groupId, Model model) {
        Group group = groupService.findById(groupId);
        model.addAttribute("group", group);

        // 리더를 제외한 멤버 목록 조회 (위임 대상)
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
        if (loginMember == null) return "redirect:/member/login";

        int currentLeaderId = loginMember.getId();

        // 1. 차기 리더에게 권한 위임 (GroupMember 테이블의 role 업데이트)
        groupMemberService.updateRoleToLeader(groupId, newLeaderId);

        // 2. group 테이블의 leader_id 정보 업데이트
        groupService.updateLeader(groupId, newLeaderId);

        // 3. 기존 그룹장 탈퇴 처리
        groupMemberService.leaveGroup(currentLeaderId, groupId);

        ra.addFlashAttribute("msg", "리더 권한을 위임하고 그룹을 성공적으로 탈퇴했습니다.");
        return "redirect:/group/groups";
    }
}