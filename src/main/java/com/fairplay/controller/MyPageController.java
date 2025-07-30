package com.fairplay.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fairplay.domain.Member;
import com.fairplay.enums.MemberStatus;
import com.fairplay.service.MemberService;

@Controller
@RequestMapping("/mypage")
public class MyPageController {

    @Autowired
    private MemberService memberService;
    

    // 마이페이지 진입
    @GetMapping
    public String myPage(HttpSession session, Model model) {
        Member loginMember = (Member) session.getAttribute("loginMember");

        if (loginMember == null || loginMember.getStatus() != MemberStatus.ACTIVE) {
            session.invalidate();
            return "redirect:/login";
        }

        Member member = memberService.findById(loginMember.getId());
        model.addAttribute("member", member);

        return "myPage"; // 이건 memberEditForm.jsp일 수도 있음 (실제로는 수정 폼)
    }

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
}
