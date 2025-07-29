package com.fairplay.service;

import java.util.List;

import com.fairplay.domain.Member;

// 회원 관련 서비스 인터페이스
public interface MemberService {
	
	void save(Member member);

	List<Member> readAll();
	
	Member findById(int id);
	
	void update(Member member);
	
	void deactivate(int id);
	
	Member findByUserId(String user_id);
	
	// 아이디 중복 여부를 확인하는 서비스 메서드
	boolean isDuplicatedId(String userId);
	
	// 닉네임 중복 여부 확인 메서드
	boolean isDuplicatedNickname(String nickname);
	
	// 아이디 + 이메일로 사용자 조회
	Member findByUserIdAndEmail(String userId, String email);
	
	// 이메일을 통해 임시 비밀번호 발송 + 저장
	void sendTempPassword(String userId, String email);
	
}
