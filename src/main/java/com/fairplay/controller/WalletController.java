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

import com.fairplay.domain.Member;
import com.fairplay.domain.Wallet;
import com.fairplay.service.WalletService;

@Controller
@RequestMapping("/wallet")
public class WalletController {
	
	@Autowired
	private WalletService walletService;

	// [GET] 전체 목록 조회
	@GetMapping
	public String list(HttpSession session , Model model) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/member/login";
		}
		System.out.println("지출 목록 조회: loginMember = " + loginMember);
		
		int member_id = loginMember.getId();
		List<Wallet> walletList = walletService.findByMemberId(member_id);
		model.addAttribute("walletList", walletList);
		System.out.println("walletList" + walletList);
		model.addAttribute("member_id", member_id);
		return "wallet";
	}
	
	// [GET] 항목 등록 폼 페이지
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
	
	// [POST] 항목 저장 처리
	@PostMapping("/save")
	public String save(@ModelAttribute Wallet wallet, HttpSession session) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/member/login";
		}
		System.out.println("save() 진입 - member_id: " + wallet.getMember_id());
		
		wallet.setMember_id(loginMember.getId());
		walletService.save(wallet);
		System.out.println("지출 저장: " + wallet);
		return "redirect:/wallet?member_id=" + wallet.getMember_id();
	}
	
	// [GET] 항목 수정 폼
	@GetMapping("/edit")
	public String update(@RequestParam("id") int id, Model model) {
		System.out.println("수정 폼 진입: id = " + id);
		Wallet wallet = walletService.findById(id);
		
		model.addAttribute("wallet",wallet);
		model.addAttribute("member_id", wallet.getMember_id());
		return "walletCreateForm";
	}
	
	// [POST] 항목 수정 처리
	@PostMapping("/update")
	public String update(@ModelAttribute Wallet wallet) {
		System.out.println("지출 수정: " + wallet);

		walletService.update(wallet);
		return "redirect:/wallet?member_id=" + wallet.getMember_id();
	}
	
	// [GET] 항목 삭제 처리
	@GetMapping("/delete")
	public String delete (@RequestParam("id") int id, @RequestParam("member_id") int member_id) {
		System.out.println("🗑지출 삭제: id = " + id + ", member_id = " + member_id);

		walletService.delete(id);
		return "redirect:/wallet?member_id=" + member_id;
	}
	
	// [GET] 단가 비교 보기
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
