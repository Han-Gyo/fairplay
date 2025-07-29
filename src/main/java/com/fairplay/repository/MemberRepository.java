package com.fairplay.repository;

import java.util.List;

import com.fairplay.domain.Member;

public interface MemberRepository {

	void save(Member member);

	List<Member> readAll();
	
	Member findById(int id);
	
	void update(Member member);
	
	void deactivate(int id);
	
	Member findByUserId(String user_id);
	
	// user_id가 DB에 존재하는지 여부를 boolean으로 반환
	boolean existsByUserId(String userId);
	
	// 닉네임 존재 여부 확인
	boolean existsByNickname(String nickname);
	
	// 아이디 + 이메일로 회원 정보 조회
	Member findByUserIdAndEmail(String userId, String email);
	
	// 이메일로 회원 조회
	Member findByEmail(String email);
	
	// 비밀번호만 수정
	int updatePassword(Member member);
}
