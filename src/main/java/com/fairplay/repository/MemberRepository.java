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
}
