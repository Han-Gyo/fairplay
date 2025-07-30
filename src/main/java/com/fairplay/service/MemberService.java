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
	
	// 회원 ID로 비밀번호 확인 (현재 비밀번호 체크)
	boolean checkPassword(int memberId, String inputPassword);
	
	// 회원 ID 기준으로 새 비밀번호 변경
	void changePassword(int memberId, String newPassword);
	
	// 이메일을 기반으로 회원 정보 조회 (비밀번호 찾기)
	Member findByEmail(String email);
	
	// 실명 + 이메일로 회원 조회 (아이디 찾기)
	Member findByRealNameAndEmail(String realName, String email);
}
