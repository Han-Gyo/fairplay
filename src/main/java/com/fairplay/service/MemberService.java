package com.fairplay.service;

import java.util.List;

import com.fairplay.domain.Member;

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
}
