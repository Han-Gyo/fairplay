package com.fairplay.service;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class MailService {

	@Autowired
	private JavaMailSender mailSender;
	
	// 인증번호 생성 (6자리)
	public String generateCode() {
		return String.valueOf((int)(Math.random() * 900000) + 100000);
	}
	
	// 인증번호 이메일 전송
	public void sendVerificationCode(String toEmail, String code) {
	    try {
	        MimeMessage message = mailSender.createMimeMessage();
	        MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");

	        helper.setTo(toEmail);
	        helper.setSubject("[FairPlay] 이메일 인증번호 안내");
	        helper.setText("인증번호는 다음과 같습니다: " + code);
	        helper.setFrom("tjgksry3940@gmail.com"); // 발신자 이메일

	        mailSender.send(message);
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
}
