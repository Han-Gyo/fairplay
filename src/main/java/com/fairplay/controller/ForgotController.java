package com.fairplay.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fairplay.domain.Member;
import com.fairplay.service.MailService;
import com.fairplay.service.MemberService;

@Controller
@RequestMapping("/forgot")
public class ForgotController {
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	@Autowired
	private MailService mailService; // 이메일 발송 서비스 주입
	
	
	
	// 비밀번호 재설정 폼 진입
	@GetMapping("")
	public String forgotPwForm() {
		return "forgotPwForm";	// /WEB-INF/views/forgotPwForm.jsp
	}


    // 사용자가 이메일을 입력하면 임시 비밀번호 발급 요청
    @PostMapping("/sendTempPw")
    public String sendTempPassword(@RequestParam("user_id") String userId,
    							   @RequestParam("email") String email, 
    							   Model model) {
        try {
            // 핵심 로직은 Service로 위임됨
            memberService.sendTempPassword(userId, email);

            model.addAttribute("message", "임시 비밀번호가 이메일로 발송되었습니다.");
        } catch (RuntimeException e) {
            model.addAttribute("error", e.getMessage());
        }

        return "forgotPwResult"; // 결과 메시지를 보여줄 JSP
    }

}
