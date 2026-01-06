package com.fairplay.controller;

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

        return "forgotPwResult"; 
    }
    
    // 아이디 찾기 폼 이동
    @GetMapping("/forgotId")
    public String forgotIdForm() {
    	return "forgotIdForm";
    }
    
    
    
    // 이메일을 통해 아이디(user_id) 찾기 요청 처리
    @PostMapping("/findId")
    public String findIdByEmail(@RequestParam("real_name") String realName,
    							@RequestParam("email") String email,
    							Model model) {

        // Service 계층을 통해 이메일로 회원 정보 조회
        Member member = memberService.findByRealNameAndEmail(realName, email);

        // 해당 이메일로 가입된 회원이 없을 경우
        if (member == null) {
            model.addAttribute("error", " 이름 또는 이메일을 다시 확인해주세요.");
            return "forgotIdForm"; // 실패 시 다시 폼으로
        }

        // 회원 존재 → user_id를 메시지로 전달
        model.addAttribute("message", "가입된 아이디는 다음과 같습니다: " + member.getUser_id());

        return "forgotIdForm"; 
    }

}
