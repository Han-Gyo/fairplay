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

import com.fairplay.domain.Member;
import com.fairplay.service.MemberService;

@Controller
@RequestMapping("/member")
public class MemberController {

	// 회원 관련 비즈니스 로직을 처리하는 서비스 객체
	@Autowired
	private MemberService memberService;
	
	// 회원 등록 폼 페이지로 이동 (Create)
	@GetMapping("/create")
	public String createForm() {
		
		System.out.println("createForm 진입"); // 디버깅용 오류 없으면 삭제
		
		return "createForm";
	}
	
	// 회원가입 폼 제출 시 회원 등록 처리 (Create)
	@PostMapping("/create")
	public String createMember(@ModelAttribute Member member) {
		// Service 계층에 회원 정보 저장 요청
		memberService.save(member);
		
		// 회원 목록 페이지로 리다이렉트
		return "redirect:/member/members";
	}
	
	// 전체 회원 목록을 조회하여 뷰에 전달 (Read_all)
	@GetMapping("/members")
	public String memberList(Model model) {
		
		// 전체 회원 데이터 조회
		List<Member> members = memberService.readAll();
		
		// 모델에 회원 리스트 데이터 추가
		model.addAttribute("members", members);
		
		// 회원 목록 JSP 뷰 반환
		return "members";
	}
	
	// 특정 회원을 조회하여 수정 폼 이동 (read_one)
	@GetMapping("/edit")
	public String findById(@RequestParam("id")int id, Model model) {
		
		// id 기반으로 회원 데이터 조회
		Member member = memberService.findById(id);
		
		// JSP로 해당 객체 데이터 전달
		model.addAttribute("member", member);
		
		// 수정 폼 페이지 반환
		return "memberEditForm";
	}
	
	// 수정된 회원 데이터를 DB에 반영하고 전체 회원 목록 페이지로 리다이렉트
	@PostMapping("/update")
	public String update(@ModelAttribute Member member) {
		memberService.update(member);
		return "redirect:/member/members";
	}
	
	// 회원 탈퇴
	@GetMapping("/delete")
	public String delete(@RequestParam("id") int id) {
		memberService.delete(id);
		return "redirect:/member/members";
	}
}
