package com.fairplay.service;

import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service
public class MailServiceImpl implements MailService {

    @Autowired
    private JavaMailSender mailSender;

    // 인증번호 생성 (6자리 숫자)
    @Override
    public String generateCode() {
        return String.valueOf((int)(Math.random() * 900000) + 100000);
    }

    // 인증번호 이메일 전송 (텍스트 메일, UTF-8 인코딩)
    @Override
    public void sendVerificationCode(String toEmail, String code) {
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");

            helper.setTo(toEmail);
            helper.setSubject("[FairPlay] 이메일 인증번호 안내");
            helper.setText("인증번호는 다음과 같습니다: " + code);
            helper.setFrom("fairplay_@nate.com"); // 발신자 이메일

            mailSender.send(message);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 임시 비밀번호 발송 메일 (제목 + 본문만 전달하는 간단한 텍스트 메일)
	@Override
    public void sendSimpleMessage(String to, String subject, String text) throws Exception {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(to);
        message.setFrom("fairplay_@nate.com");
        message.setSubject(subject);
        message.setText(text);
        mailSender.send(message);
    }
    
    
    
    
}
