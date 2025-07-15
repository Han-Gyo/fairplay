package com.fairplay.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.fairplay.domain.Member;
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
	public void delete(int id) {
		
		// Repository에 위임
		memberRepository.delete(id);
		
	}
	
	
	
	

}
