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
import com.fairplay.domain.Member;
import com.fairplay.domain.Wallet;
import com.fairplay.service.GroupMemberService;
import com.fairplay.service.WalletService;

@Controller
@RequestMapping("/wallet")
public class WalletController {
	
	@Autowired
	private WalletService walletService;
	@Autowired
	private GroupMemberService groupMemberService;

	// 전체 목록 조회
	@GetMapping
	public String list(@RequestParam(value = "groupId", required = false) Integer groupIdParam,
      HttpSession session, Model model, RedirectAttributes ra) {
	  Member loginMember = (Member) session.getAttribute("loginMember");
	  if (loginMember == null) {
	    ra.addFlashAttribute("error", "로그인이 필요합니다.");
	    return "redirect:/member/login";
	  }

	  int member_id = loginMember.getId();

	  // 1. 내가 가입한 그룹 리스트 조회
	  List<Group> groupList = groupMemberService.findGroupsByMemberId((long) member_id);
	  if (groupList.isEmpty()) {
	    ra.addFlashAttribute("error", "소속된 그룹이 없습니다. 그룹에 먼저 가입해주세요.");
	    return "redirect:/"; // 혹은 그룹 생성 페이지
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
	
	// 항목 등록 폼 페이지
	@GetMapping("/create")
	public String addWallet (HttpSession session, Model model) {
		System.out.println("지출 등록 폼 진입");
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/member/login";
		}
		
		int member_id = loginMember.getId();
		model.addAttribute("wallet", new Wallet());
		model.addAttribute("member_id", member_id);
		
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

	  Integer currentGroupId = (Integer) session.getAttribute("currentGroupId");
	  wallet.setGroup_id(currentGroupId);
		
		walletService.save(wallet);
		System.out.println("지출 저장: " + wallet);
		return "redirect:/wallet";
	}
	
	// 항목 수정 폼
	@GetMapping("/edit")
	public String update(@RequestParam("id") int id, Model model) {
		System.out.println("수정 폼 진입: id = " + id);
		Wallet wallet = walletService.findById(id);
		
		model.addAttribute("wallet",wallet);
		model.addAttribute("member_id", wallet.getMember_id());
		return "walletCreateForm";
	}
	
	// 항목 수정 처리
	@PostMapping("/update")
	public String update(@ModelAttribute Wallet wallet) {
		System.out.println("지출 수정: " + wallet);

		walletService.update(wallet);
		return "redirect:/wallet";
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
