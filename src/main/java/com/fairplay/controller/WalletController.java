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
import com.fairplay.domain.GroupMemberInfoDTO;
import com.fairplay.domain.Member;
import com.fairplay.domain.Wallet;
import com.fairplay.service.GroupMemberService;
import com.fairplay.service.GroupService;
import com.fairplay.service.WalletService;

@Controller
@RequestMapping("/wallet")
public class WalletController {
	
	@Autowired
	private WalletService walletService;
	@Autowired
	private GroupService groupService;
	@Autowired
	private GroupMemberService groupMemberService;

// 전체 목록 조회
@GetMapping
public String list(@RequestParam(value = "groupId", required = false) Integer groupIdParam,
    HttpSession session, Model model, RedirectAttributes ra) {
  Member loginMember = (Member) session.getAttribute("loginMember");
  if (loginMember == null) {
    ra.addFlashAttribute("error", "로그인 후 이용해주세요.");
    return "redirect:/member/login";
  }

  int member_id = loginMember.getId();

  // 1. 내가 가입한 그룹 리스트 조회
  List<Group> groupList = groupMemberService.findGroupsByMemberId((long) member_id);
  if (groupList.isEmpty()) {
  	ra.addFlashAttribute("error", "소속된 그룹이 없습니다. 그룹에 먼저 가입해주세요.");
    return "redirect:/group/groups";
  }

  // 2. URL 파라미터로 groupId가 들어오면 세션 갱신 (그룹 전환 대응)
  if (groupIdParam != null) {
    session.setAttribute("currentGroupId", groupIdParam);
  }

  // 3. 세션에 currentGroupId가 없으면 첫 번째 그룹으로 자동 설정
  if (session.getAttribute("currentGroupId") == null) {
    session.setAttribute("currentGroupId", groupList.get(0).getId());
  }

  Integer currentGroupId = (Integer) session.getAttribute("currentGroupId");

  // 4. 이 그룹의 멤버인지 검증
  boolean isMember = groupMemberService.isGroupMember((long) currentGroupId, (long) member_id);
  if (!isMember) {
    ra.addFlashAttribute("error", "해당 그룹의 멤버가 아닙니다.");
    return "redirect:/wallet?type=personal"; // 아니면 에러 페이지
  }

  // 5. 데이터 조회 (개인/그룹 선택에 따라)
  List<Wallet> walletList = walletService.findByGroupId(currentGroupId);
  
  model.addAttribute("walletList", walletList);
  model.addAttribute("member_id", member_id);
  model.addAttribute("groupId", currentGroupId);
  model.addAttribute("joinedGroups", groupList); 
  
  return "wallet";
}

//항목 등록 폼 페이지
@GetMapping("/create")
public String addWallet(@RequestParam(value = "groupId", required = false) Integer groupId,
                       HttpSession session, Model model, RedirectAttributes ra) {
	System.out.println("지출 등록 폼 진입");
 
		// 1. 로그인 체크
	Member loginMember = (Member) session.getAttribute("loginMember");
  if (loginMember == null) {
  	ra.addFlashAttribute("msg", "로그인 후 이용해주세요.");
    return "redirect:/member/login";
  }
	
	int memberId = loginMember.getId();

	if (groupId == null) {
    groupId = (Integer) session.getAttribute("currentGroupId");
  }
	
	// 2. 소속 그룹 리스트 가져오기
	List<Group> groupList = groupMemberService.findGroupsByMemberId((long) memberId);
  if (groupList.isEmpty()) {
  	ra.addFlashAttribute("error", "소속된 그룹이 없습니다. 그룹에 먼저 가입해주세요.");
    return "redirect:/group/groups";
  }
 
	// 3. 특정 그룹 정보 조회
	Group group = groupService.findById(groupId);
  if (group == null) {
    ra.addFlashAttribute("error", "존재하지 않는 그룹입니다.");
    return "redirect:/";
  }
 
	// 4. 그룹장 권한 체크
	if (group.getLeaderId() != memberId) {
    ra.addFlashAttribute("error", "그룹장만 할 일을 등록할 수 있습니다.");
    return "redirect:/todos?groupId=" + groupId;
  }

	List<GroupMemberInfoDTO> memberList = groupMemberService.findMemberInfoByGroupId(groupId);
  
  model.addAttribute("wallet", new Wallet());
  model.addAttribute("groupId", groupId);
  model.addAttribute("joinedGroups", groupList);
  model.addAttribute("memberList", memberList);
  model.addAttribute("member_id", memberId);
  
  return "walletCreateForm";
}
 
// 항목 저장 처리
@PostMapping("/save")
public String save(@ModelAttribute Wallet wallet, HttpSession session) {
	Member loginMember = (Member) session.getAttribute("loginMember");
	if (loginMember == null) {
		return "redirect:/member/login";
	}
	System.out.println("save() 진입 - member_id: " + wallet.getMember_id());
	
	wallet.setMember_id(loginMember.getId());

	if (wallet.getGroup_id() == null || wallet.getGroup_id() == 0) {
    Integer currentGroupId = (Integer) session.getAttribute("currentGroupId");
    wallet.setGroup_id(currentGroupId);
  }
	
	session.setAttribute("currentGroupId", wallet.getGroup_id());
	
	walletService.save(wallet);
	System.out.println("지출 저장: " + wallet);
	
	return "redirect:/wallet?groupId=" + wallet.getGroup_id();
}

// 항목 수정 폼
@GetMapping("/edit")
public String update(@RequestParam("id") int id, HttpSession session, Model model) {
	System.out.println("수정 폼 진입: id = " + id);
	//1. 로그인 체크 및 내 정보 가져오기
  Member loginMember = (Member) session.getAttribute("loginMember");
  if (loginMember == null) {
    return "redirect:/member/login";
  }
  int memberId = loginMember.getId();

  // 2. 수정할 데이터 조회
  Wallet wallet = walletService.findById(id);
  if (wallet == null) {
    return "redirect:/wallet";
  }

  // 3. 내가 가입한 그룹 리스트 조회해서 모델에 담기
  List<Group> groupList = groupMemberService.findGroupsByMemberId((long) memberId);
  
  model.addAttribute("wallet", wallet);
  model.addAttribute("member_id", wallet.getMember_id());
  model.addAttribute("joinedGroups", groupList); 
  model.addAttribute("groupId", wallet.getGroup_id()); 
  
	return "walletCreateForm";
}

// 항목 수정 처리
@PostMapping("/update")
public String update(@ModelAttribute Wallet wallet, HttpSession session) {
	System.out.println("지출 수정: " + wallet);

	walletService.update(wallet);

	session.setAttribute("currentGroupId", wallet.getGroup_id());
  return "redirect:/wallet?groupId=" + wallet.getGroup_id();
}

// 항목 삭제 처리
@GetMapping("/delete")
public String delete (@RequestParam("id") int id, @RequestParam("member_id") int member_id) {
	System.out.println("지출 삭제: id = " + id + ", member_id = " + member_id);

	walletService.delete(id);
	return "redirect:/wallet";
}

// 단가 비교 보기
@GetMapping("/compare")
public String compare (@RequestParam("member_id") int member_id,
					   @RequestParam("item_name") String item_name,
					   Model model) {
	System.out.println("단가 비교 요청: member_id = " + member_id + ", item_name = " + item_name);

	List<Wallet> compareList = walletService.comparePriceByItemName(member_id, item_name);
	System.out.println("비교 검색 결과: " + compareList);
	model.addAttribute("compareList",compareList);
	model.addAttribute("item_name",item_name);
	return "walletCompare";
	}
}
