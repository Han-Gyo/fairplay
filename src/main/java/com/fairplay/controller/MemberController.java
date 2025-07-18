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
		
		System.out.println("회원가입 createForm 함수 진입"); // 디버깅용 오류 없으면 삭제
		
		return "memberCreateForm";
	}
	
	// 회원가입 폼 제출 시 회원 등록 처리 (Create)
	@PostMapping("/create")
	public String createMember(@ModelAttribute Member member) {
		
		// 일반 사용자는 항상 USER 고정 시키기
		member.setRole("USER");
		
		// Service 계층에 회원 정보 저장 요청
		memberService.save(member);
		
		// 회원 목록 페이지로 리다이렉트
		return "redirect:/member/login";
	}
	
	// 전체 회원 목록을 조회하여 뷰에 전달 (Read_all)
	@GetMapping("/members")
	public String memberList(HttpSession session, Model model) {
		
		// 세션에서 로그인 사용자 정보 꺼내기
		Member loginUser = (Member) session.getAttribute("loginMember");
		
		// 로그인 안 했거나 관리자 아니면 -> 홈으로 이동
		if (loginUser == null || !"ADMIN".equals(loginUser.getRole())) {
			return "redirect:/";
		}
		
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
	
	// 수정된 회원 데이터를 DB에 반영하고 전체 회원 목록 또는 마이페이지로 리다이렉트
	@PostMapping("/update")
	public String update(@ModelAttribute Member member,
						 @RequestParam(required = false) String from,
						 HttpSession session) {
		
		memberService.update(member);
		
		// 세션에 로그인 사용자 정보 갱신
		Member loginUser = (Member) session.getAttribute("loginMember");
		if (loginUser != null && loginUser.getId() == member.getId()) {
			session.setAttribute("loginMember", member);
		}
		
		// 분기 처리 : 마이페이지 수정 -> 마이페이지로
		if ("mypage".equals(from)) {
			return "redirect:/member/mypage";
		}
		
		
		// 그 외(관리자 등)은 전체 회원 목록으로 이동
		return "redirect:/member/members";
	}
	
	
	// 회원 탈퇴 (하드삭제x 소프트삭제o 사용자가 마음 돌리거나 법적으로 특정 기간동안 보관해야함.)
	@PostMapping("/deactivate")
	public String deactivate(@RequestParam("id") int id, HttpSession session) {
		memberService.deactivate(id);	// status -> 'INACTIVE'일 때 ↓
		session.invalidate();			// 로그아웃 처리 (세션 종료)
		return "redirect:/"; 			// 홈화면 리다이렉트
	}
	
	
	// 마이페이지 진입
	@GetMapping("/mypage")
	public String myPage(HttpSession session, Model model) {
		
		// 로그인 여부 확인
		Member loginMember = (Member) session.getAttribute("loginMember");
		
		if (loginMember == null) {
			return "redirect:/login"; // 로그인 안 되어 있으면 로그인 페이지로
		}
		
		// 탈퇴한 회원이면 접근 제한
		if (!"ACTIVE".equals(loginMember.getStatus())) {
			session.invalidate();	// 세션도 종료시켜버림
			return "redirect:/";	// 홈으로 강제 이동
		}
		
		// 본인 정보만 모델에 담기
		int memberId = loginMember.getId();
		Member member = memberService.findById(memberId);
		model.addAttribute("member", member);
		
		return "myPage";
	}
	
	
	// 로그인 폼 이동
	@GetMapping("/login")
	public String loginForm() {
		System.out.println("로그인 폼 이동 함수 진입");
		return "login";
	}
	
	
	// 로그인 처리
	@PostMapping("/login")
	public String login(@RequestParam String user_id, 
			@RequestParam String password, 
			HttpSession session, 
			Model model) {
		Member member = memberService.findByUserId(user_id);
		
		if (member == null || !member.getPassword().equals(password)){
			model.addAttribute("loginError", "아이디 또는 비밀번호가 올바르지 않습니다.");
			return "login";
		}
		
		session.setAttribute("loginMember", member);
		return "home";
	}
	
	
	@GetMapping("/logout")
	public String logout(HttpSession session) {
	    session.invalidate(); // 세션 삭제
	    return "redirect:/";  // 홈으로 리다이렉트
	}

}
