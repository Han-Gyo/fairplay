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

import com.fairplay.domain.Wallet;
import com.fairplay.service.MemberService;
import com.fairplay.service.WalletService;

@Controller
@RequestMapping("/wallet")
public class WalletController {

    private final HomeController homeController;
    
    @Autowired
    private MemberService memberService;
	
	@Autowired
	private WalletService walletService;

    WalletController(HomeController homeController) {
        this.homeController = homeController;
    }
	
	// ✅ [GET] 전체 목록 조회 - /wallet?member_id=1
	@GetMapping
	public String list(@RequestParam("member_id") int member_id, Model model) {
		System.out.println("📋 지출 목록 조회: member_id = " + member_id);
		
		List<Wallet> walletList = walletService.findByMemberId(member_id);
		model.addAttribute("walletList", walletList);
		model.addAttribute("member_id", member_id);
		return "wallet";
	}
	
	// ✅ [GET] 항목 등록 폼 페이지 - /wallet/create
	@GetMapping("/create")
	public String addWallet (HttpSession session, Model model) {
		System.out.println("📝 지출 등록 폼 진입");
		
		Integer member_id = (Integer) session.getAttribute("member_id");
		
		System.out.println(member_id);
		
		model.addAttribute("wallet", new Wallet());
		model.addAttribute("member_id", member_id);
		
		return "walletCreateForm";
	}
	
	// ✅ [POST] 항목 저장 처리 - /wallet/save
	@PostMapping("/save")
	public String save(@ModelAttribute Wallet wallet) {
		
		System.out.println(wallet.getMember_id());
		
		walletService.save(wallet);
		System.out.println("💾 지출 저장: " + wallet);
		return "redirect:/wallet?member_id=" + wallet.getMember_id();
	}
	
	// ✅ [GET] 항목 수정 폼 - /wallet/edit?id=5
	@GetMapping("/edit")
	public String update(@RequestParam("id") int id, Model model) {
		System.out.println("✏️ 수정 폼 진입: id = " + id);

		Wallet wallet = walletService.findById(id);
		model.addAttribute("wallet",wallet);
		return "walletCreateForm";
	}
	
	// ✅ [POST] 항목 수정 처리 - /wallet/update
	@PostMapping("/update")
	public String update(@ModelAttribute Wallet wallet) {
		System.out.println("🔄 지출 수정: " + wallet);

		walletService.update(wallet);
		return "redirect:/wallet?member_id=" + wallet.getMember_id();
	}
	
	// ✅ [GET] 항목 삭제 처리 - /wallet/delete?id=5&member_id=1
	@GetMapping("/delete")
	public String delete (@RequestParam("id") int id, @RequestParam("member_id") int member_id) {
		System.out.println("🗑️ 지출 삭제: id = " + id + ", member_id = " + member_id);

		walletService.delete(id);
		return "redirect:/wallet?member_id=" + member_id;
	}
	
	// ✅ [GET] 단가 비교 보기 - /wallet/compare?member_id=1&itemName=라면
	@GetMapping("/compare")
	public String compare (@RequestParam("member_id") int member_id,
						   @RequestParam("item_name") String item_name,
						   Model model) {
		System.out.println("🔍 단가 비교 요청: member_id = " + member_id + ", item_name = " + item_name);

		List<Wallet> compareList = walletService.comparePriceByItemName(member_id, item_name);
		model.addAttribute("compareList",compareList);
		model.addAttribute("item_name",item_name);
		return "walletCompare";
	}
}
