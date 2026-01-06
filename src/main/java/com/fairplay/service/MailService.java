package com.fairplay.service;

public interface MailService {

    // 인증번호 생성 (6자리)
    String generateCode();

    // 인증번호 전송 (수신자 이메일, 인증코드)
    void sendVerificationCode(String toEmail, String code);
    
    // 임시 비밀번호 전송 (SimpleMailMessage 사용, 텍스트 메일)
    void sendSimpleMessage(String to, String subject, String text) throws Exception;
}
