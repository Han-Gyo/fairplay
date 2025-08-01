package com.fairplay.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.fairplay.domain.Member;
import com.fairplay.enums.MemberStatus;
import com.fairplay.service.MemberService;

@Controller
@RequestMapping("/mypage")
public class MyPageController {

    @Autowired
    private MemberService memberService;
    

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
