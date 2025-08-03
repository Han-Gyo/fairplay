package com.fairplay.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
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
import com.fairplay.util.FileUploadUtil;

@Controller
@RequestMapping("/mypage")
public class MyPageController {

    @Autowired
    private MemberService memberService;
    
    @Autowired
    private FileUploadUtil fileUploadUtil;

    // 🔹 마이페이지 진입 (/mypage)
    @GetMapping
    public String myPage(HttpSession session, Model model) {

        // 로그인 정보 확인
        Member loginMember = (Member) session.getAttribute("loginMember");

        // 🔒 비로그인 또는 탈퇴 회원은 로그인으로 보냄
        if (loginMember == null || loginMember.getStatus() != MemberStatus.ACTIVE) {
            session.invalidate();
            return "redirect:/login";
        }

        // 로그인한 회원 정보 조회 (DB 최신 데이터)
        int memberId = loginMember.getId();
        Member member = memberService.findById(memberId);

        // 모델에 담아서 JSP에 전달
        model.addAttribute("member", member);

        return "myPage"; // → /WEB-INF/views/myPage.jsp
    }

    
    // 수정된 회원 데이터를 DB에 반영하고 전체 회원 목록 또는 마이페이지로 리다이렉트
 	@PostMapping("/update")
 	public String update(@ModelAttribute Member member,
			             @RequestParam(required = false) String from,
			             @RequestParam(required = false, defaultValue = "false") String resetProfileImage,
			             @RequestParam(required = false) MultipartFile profileImageFile,
			             HttpServletRequest request,
			             HttpSession session) {
 		
 		// 최종 저장할 프사 가지고 있는지 확인 로그 찍어보기
 		System.out.println("최종 저장할 프로필 이미지 파일명: " + member.getProfileImage());

		// 전화번호 합치기
		String phone = request.getParameter("phone1") + "-" +
		          request.getParameter("phone2") + "-" +
		          request.getParameter("phone3");
		member.setPhone(phone);
		
		// 로그인한 사용자 정보 유지
		Member loginUser = (Member) session.getAttribute("loginMember");
		if (loginUser != null) {
		member.setStatus(loginUser.getStatus());
		}
		
		// 프로필 이미지 처리
		if ("true".equals(resetProfileImage)) {
		    // 🔄 기본 이미지로 초기화 (null 저장하면 JSP에서 404 발생 가능 → 기본 이미지 파일명으로 대체)
		    member.setProfileImage("default_profile.png"); 
		} else if (profileImageFile != null && !profileImageFile.isEmpty()) {
		    // 📦 새로운 이미지 업로드 (파일명 정제 및 실패 대비)
		    String fileName = fileUploadUtil.saveFile(profileImageFile);
		    
		    if (fileName != null) {
		        member.setProfileImage(fileName); // ✅ 새 이미지 성공 시 저장
		    } else {
		        System.out.println("❌ 파일 저장 실패로 기존 이미지 유지");
		        String currentImage = memberService.findById(member.getId()).getProfileImage();
		        member.setProfileImage(currentImage); // ⛑ 실패 시 기존 이미지 유지
		    }
		} else {
		    // 🔄 아무것도 업로드 안 했을 때 → 기존 이미지 유지
		    String currentImage = memberService.findById(member.getId()).getProfileImage();
		    member.setProfileImage(currentImage);
		}

		
		// DB 업데이트
		memberService.update(member);
		
		// 세션 최신화
		if (loginUser != null && loginUser.getId() == member.getId()) {
		    Member updatedMember = memberService.findById(member.getId());  // DB에서 최신 데이터 조회
		    session.setAttribute("loginMember", updatedMember);             // 확실하게 세션 업데이트
		}
		
		// 마이페이지에서 왔다면 마이페이지로
		if ("mypage".equals(from)) {
		return "redirect:/mypage";
		}
		
		return "redirect:/member/members"; // 관리자용 목록
		}
    
    
 	// 비밀번호 변경
    @PostMapping("/changePw")
    public String changePassword(@RequestParam String currentPassword,
                                  @RequestParam String newPassword,
                                  @RequestParam String confirmPassword,
                                  HttpSession session,
                                  Model model) {

        // 🔐 세션에서 로그인된 사용자 가져오기
        Member loginMember = (Member) session.getAttribute("loginMember");

        if (loginMember == null) {
            model.addAttribute("error", "로그인이 필요합니다.");
            return "redirect:/member/login";
        }

        // 🔐 현재 비밀번호가 일치하지 않을 경우
        if (!memberService.checkPassword(loginMember.getId(), currentPassword)) {
            model.addAttribute("error", "현재 비밀번호가 틀렸습니다.");
            return "memberEditForm"; // 같은 뷰로 이동
        }

        // 🔐 새 비밀번호와 확인 비밀번호가 일치하지 않을 경우
        if (!newPassword.equals(confirmPassword)) {
            model.addAttribute("error", "새 비밀번호가 일치하지 않습니다.");
            return "memberEditForm";
        }

        // 🔐 비밀번호 변경 실행
        memberService.changePassword(loginMember.getId(), newPassword);

        // ✅ 성공 메시지 전달
        model.addAttribute("message", "비밀번호가 성공적으로 변경되었습니다.");
        return "memberEditForm";
    }
    
    
    // 마이페이지에서 닉네임 중복 검사
    @GetMapping(value = "/checkNicknameAjax", produces = "application/json")
    @ResponseBody
    public Map<String, String> checkNicknameAjax(@RequestParam("nickname") String nickname,
                                                 HttpSession session) {

        Member loginMember = (Member) session.getAttribute("loginMember");

        Map<String, String> result = new HashMap<>();

        if (loginMember == null) {
            result.put("result", "unauthorized");
            return result;
        }

        boolean isDuplicate = !nickname.equals(loginMember.getNickname())
                            && memberService.isDuplicatedNickname(nickname);

        result.put("result", isDuplicate ? "duplicate" : "available");
        return result;
    }




}
