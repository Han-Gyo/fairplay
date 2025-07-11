package com.fairplay.repository;

import java.util.List;

import com.fairplay.domain.Member;

public interface MemberRepository {

	void save(Member member);

	List<Member> readAll();
	
}
