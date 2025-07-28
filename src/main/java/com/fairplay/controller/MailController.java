package com.fairplay.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fairplay.service.MailService;

@Controller
@RequestMapping("/mail")
public class MailController {
	
	@Autowired
	private MailService mailService;
	
	// 이메일 인증번호 전송
	@PostMapping("/sendCode")
	@ResponseBody
	public ResponseEntity<String> sendCode(@RequestParam("email") String email, HttpSession session) {
	    // 1. 인증번호 생성
	    String code = mailService.generateCode();
	    long timestamp = System.currentTimeMillis();

	    // 2. 세션에 저장 (이전 인증 상태 초기화)
	    session.setAttribute("emailCode", code);
	    session.setAttribute("emailCodeTime", timestamp);
	    session.setAttribute("emailVerified", false);	// 인증 전 상태로 리셋

	    // 3. 메일 전송
	    mailService.sendVerificationCode(email, code);

	    // 4. 한글 깨짐 방지
	    return ResponseEntity.ok()
	            .header("Content-Type", "text/plain; charset=UTF-8")
	            .body("인증번호가 이메일로 전송되었습니다.");
	}
	
	// 인증번호 확인
	@PostMapping("/verifyCode")
	@ResponseBody
	public ResponseEntity<String> verifyCode(@RequestParam("code") String inputCode, HttpSession session) {
	    String storedCode = (String) session.getAttribute("emailCode");
	    Long sentTime = (Long) session.getAttribute("emailCodeTime");
	    Boolean isVerified = (Boolean) session.getAttribute("emailVerified");

	    // 이미 인증된 경우
	    if (Boolean.TRUE.equals(isVerified)) {
	        return ResponseEntity.ok()
	                .header("Content-Type", "text/plain; charset=UTF-8")
	                .body("이미 인증이 완료되었습니다.");
	    }

	    // 인증번호 없는 경우
	    if (storedCode == null || sentTime == null) {
	        return ResponseEntity.ok()
	                .header("Content-Type", "text/plain; charset=UTF-8")
	                .body("인증번호가 존재하지 않습니다. 다시 요청해주세요.");
	    }

	    // 유효시간 초과 (3분)
	    long now = System.currentTimeMillis();
	    if (now - sentTime > 3 * 60 * 1000) {
	        return ResponseEntity.ok()
	                .header("Content-Type", "text/plain; charset=UTF-8")
	                .body("인증번호가 만료되었습니다.");
	    }

	    // 인증 성공
	    if (storedCode.equals(inputCode)) {
	        session.setAttribute("emailVerified", true);
	        // 인증 후 세션 정리 (선택)
	        session.removeAttribute("emailCode");
	        session.removeAttribute("emailCodeTime");

	        return ResponseEntity.ok()
	                .header("Content-Type", "text/plain; charset=UTF-8")
	                .body("인증 성공!");
	    }

	    // 인증 실패
	    return ResponseEntity.ok()
	            .header("Content-Type", "text/plain; charset=UTF-8")
	            .body("인증 실패: 코드가 일치하지 않습니다.");
	}





}
