package com.fairplay.service;

import java.util.List;

import com.fairplay.domain.Member;

public interface MemberService {
	
	void save(Member member);

	List<Member> readAll();
	
	Member findById(int id);
	
	void update(Member member);
	
	void delete(int id);
}
