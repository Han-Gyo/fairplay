package com.fairplay.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.fairplay.domain.Member;
import com.fairplay.enums.MemberStatus;
import com.fairplay.repository.MemberRepository;

@Service
public class MemberServiceImpl implements MemberService{
	
	private final MemberRepository memberRepository;
	
	// 생성자 주입 방식으로 Repository 의존성 주입 (final 선언해서 생성자 만들어서 초기화)
	public MemberServiceImpl(MemberRepository memberRepository) {
		this.memberRepository=memberRepository;
	}


	// 회원가입 요청으로 전달된 member 데이터를 저장 (Create)
	@Override
	public void save(Member member) {
		
		// 🔄 회원 가입 시 기본 상태는 ACTIVE로 설정 (탈퇴 회원 방지용)
		member.setStatus(MemberStatus.ACTIVE);
		
		// Repository에 위임
		memberRepository.save(member);
	}


	// 전체 회원 목록 조회 (Read_all)
	@Override
	public List<Member> readAll() {
		
		// DB 조회 로직은 Repository에 위임하고 결과 반환
		return memberRepository.readAll();
	}

	// 회원 한 명 조회 (Read_one)
	@Override
	public Member findById(int id) {
		
		// Repository에 위임
		return memberRepository.findById(id);
	}

	// 전달받은 Member 객체를 Repository로 전달하여 DB 업데이트 수행 (Update)
	@Override
	public void update(Member member) {
		
		// Repository에 위임
		memberRepository.update(member);
		
	}


	@Override
	public void deactivate(int id) {
		
		// Repository에 위임
		memberRepository.deactivate(id);
		
	}


	@Override
	public Member findByUserId(String user_id) {
		
		return memberRepository.findByUserId(user_id);
	}


	// 아이디 중복 검사
	@Override
	public boolean isDuplicatedId(String userId) {
		
		System.out.println("🛠 Service: 중복 확인 userId = " + userId);
		
		// Repository에서 DB 조회하여 true/false 리턴
		return memberRepository.existsByUserId(userId);
	}


	// 닉네임 중복 검사
	@Override
	public boolean isDuplicatedNickname(String nickname) {
		// 레파지토리 계층에서 닉네임 존재 여부 조회
		return memberRepository.existsByNickname(nickname);
	}
	
	
	
	

}
