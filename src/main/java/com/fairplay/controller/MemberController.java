 package com.fairplay.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fairplay.domain.Member;
import com.fairplay.enums.MemberStatus;
import com.fairplay.service.MemberService;

@Controller
@RequestMapping("/member")
public class MemberController {

	// 회원 관련 비즈니스 로직을 처리하는 서비스 객체
	@Autowired
	private MemberService memberService;
	
	// 비밀번호 암호화 처리 객체
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	// 회원 등록 폼 페이지로 이동 (Create)
	@GetMapping("/create")
	public String createForm() {
		
		System.out.println("회원가입 createForm 함수 진입"); // 디버깅용 오류 없으면 삭제
		
		return "memberCreateForm";
	}
	
	// 회원가입 폼 제출 시 회원 등록 처리 (Create)
	@PostMapping("/create")
	public String createMember(@ModelAttribute Member member,
            @RequestParam(value = "profileImageFile", required = false) MultipartFile profileImageFile,
            HttpServletRequest request) {

		// 업로드된 이미지 처리
		if (profileImageFile != null && !profileImageFile.isEmpty()) {
		// 저장 경로 설정
		String uploadDir = "C:/upload/profile/"; // 환경에 맞게 수정
		String originalFilename = profileImageFile.getOriginalFilename();
		String savedFileName = UUID.randomUUID().toString() + "_" + originalFilename.replaceAll("[^a-zA-Z0-9.]", "_");
		File dest = new File(uploadDir + savedFileName);
		
		try {
		profileImageFile.transferTo(dest); // 실제 파일 저장
		System.out.println("파일 저장 성공: " + savedFileName);
		
		// DB에는 "profile/" 경로 포함해서 저장
		member.setProfileImage(savedFileName);
		} catch (IOException e) {
		e.printStackTrace();
		System.out.println("파일 저장 실패: " + e.getMessage());
		member.setProfileImage("default_profile.png");
		}
		} else {
		member.setProfileImage("default_profile.png");
		}
		
		// 이미지 업로드 디버깅 로그
		System.out.println("파일 업로드 여부: " + profileImageFile);
		if (profileImageFile != null) {
		System.out.println("파일명: " + profileImageFile.getOriginalFilename());
		System.out.println("isEmpty? " + profileImageFile.isEmpty());
		}
		
		// 비밀번호 암호화
		String rawPassword = member.getPassword();
		String encodedPassword = passwordEncoder.encode(rawPassword);
		member.setPassword(encodedPassword);
		
		// 회원 상태는 무조건 ACTIVE
		member.setStatus(MemberStatus.ACTIVE);
		
		// 일반 사용자는 항상 USER
		member.setRole("USER");
		
		// 휴대폰 번호가 3-4-4로 나눠져 있을 경우
		String phone = request.getParameter("phone1") + "-" +
		    request.getParameter("phone2") + "-" +
		    request.getParameter("phone3");
		member.setPhone(phone);
		
		// 저장 요청
		memberService.save(member);
		
		// 로그인 페이지로 리다이렉트
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
	
	
	
	// 회원 탈퇴 (하드삭제x 소프트삭제o 사용자가 마음 돌리거나 법적으로 특정 기간동안 보관해야함.)
	@PostMapping("/deactivate")
	public String deactivate(@RequestParam("id") int id, HttpSession session) {
		memberService.deactivate(id);	// status -> 'INACTIVE'일 때 ↓
		
		session.invalidate();			// 로그아웃 처리 (세션 종료)
		
		return "redirect:/"; 			// 홈화면 리다이렉트
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
	                    HttpSession session, Model model) {

	    Member member = memberService.findByUserId(user_id);

	    // BCrypt 암호화된 비밀번호 비교
	    if (member == null 
	        || !passwordEncoder.matches(password, member.getPassword()) 
	        || member.getStatus() != MemberStatus.ACTIVE) {

	        model.addAttribute("loginError", "로그인할 수 없는 계정입니다.");
	        return "login";
	    }

	    session.setAttribute("loginMember", member);
	    return "redirect:/";
	}

	
	// 로그아웃
	@GetMapping("/logout")
	public String logout(HttpSession session) {
	    session.invalidate(); // 세션 삭제
	    return "redirect:/";  // 홈으로 리다이렉트
	}

	// 로그인 전 사용자가 접근한 URI를 세션에 저장해두는 메서드
	@GetMapping("/setRedirect")
	public String setRedirect(@RequestParam String redirectURI, HttpSession session) {

	    // 사용자가 원래 가려던 URI를 세션에 저장
	    session.setAttribute("redirectURI", redirectURI);

	    // 로그인 페이지로 이동
	    return "redirect:/member/login";
	}
	
	// 아이디 중복 확인 요청 처리 (AJAX 비동기 요청)
	@GetMapping(value = "/checkId", produces = "application/json")
	@ResponseBody
	public Map<String, String> checkId(@RequestParam("user_id") String userId) {
	    System.out.println(" checkId() 진입");
	    System.out.println(" 전달받은 userId: " + userId);
	    
	    boolean isDuplicate = memberService.isDuplicatedId(userId);

	    Map<String, String> result = new HashMap<>();
	    if (isDuplicate) {
	        result.put("result", "duplicate");
	    } else {
	        result.put("result", "available");
	    }
	    return result;
	}

	// 닉네임 중복 확인 요청 처리
	@GetMapping(value = "/checkNickname", produces = "application/json")
	@ResponseBody
	public Map<String, String> checkNickname(@RequestParam("nickname") String nickname){
		
		System.out.println("checkNickname() 진입: " + nickname);
		
		// 서비스 계층을 통해 닉네임 중복 여부 확인
		boolean isDuplicate = memberService.isDuplicatedNickname(nickname);
		
		// 클라이언트에 JSON 형태로 결과 반환
		Map<String, String> result = new HashMap<>();
		result.put("result", isDuplicate ? "duplicate" : "available");
		
		return result;
	}

	// 이메일 중복 확인 요청 처리 (AJAX 비동기 요청)
	@GetMapping(value = "/checkEmail", produces = "application/json")
	@ResponseBody
	public Map<String, String> checkEmail(@RequestParam("email") String email) {
	    System.out.println("checkEmail() 진입: " + email);

	    // 서비스 계층을 통해 이메일 중복 여부 확인
	    boolean isDuplicate = memberService.isDuplicatedEmail(email);

	    // 클라이언트에 JSON 형태로 결과 반환
	    Map<String, String> result = new HashMap<>();
	    result.put("result", isDuplicate ? "duplicate" : "available");

	    return result;
	}




}
