package com.fairplay.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.fairplay.domain.Member;
import com.fairplay.enums.MemberStatus;
import com.fairplay.repository.MemberRepository;

@Service
public class MemberServiceImpl implements MemberService{
	
	@Autowired
	private MemberRepository memberRepository;
	
	@Autowired
	private MailService mailService;
	
	@Autowired
	private PasswordEncoder passwordEncoder;
	
	


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

	
	// 이메일 중복 검사
	@Override
	public boolean isDuplicatedEmail(String email) {
	    System.out.println("🛠 Service: 중복 확인 email = " + email);
	    // Repository에서 DB 조회하여 true/false 리턴
	    return memberRepository.existsByEmail(email);
	}



	// 아이디 + 이메일로 회원 정보 조회
	@Override
	public Member findByUserIdAndEmail(String userId, String email) {
		
		return memberRepository.findByUserIdAndEmail(userId, email) ;
	}


	// 이메일을 기반으로 임시 비밀번호 생성, 암호화 후 저장 + 메일 전송
	@Override
	public void sendTempPassword(String userId, String email) {
	    // 아이디 + 이메일로 사용자 조회
	    Member member = memberRepository.findByUserIdAndEmail(userId, email);
	    if (member == null) {
	        throw new RuntimeException("입력하신 정보가 정확하지 않습니다.");
	    }

	    // 임시 비밀번호 생성
	    String tempPw = generateTempPassword();
	    String encodedPw = passwordEncoder.encode(tempPw);
	    

	    // 암호화 후 DB 저장
	    member.setPassword(encodedPw);
	    
	    // 수정된 행 수 확인
	    int result = memberRepository.updatePassword(member);
	    if (result == 0) {
	    	throw new RuntimeException("비밀번호 업데이트 실패");
	    }

	    // 메일 발송
	    String subject = "[FairPlay] 임시 비밀번호 안내";
	    String text = "임시 비밀번호는 다음과 같습니다: " + tempPw + "\n로그인 후 반드시 비밀번호를 변경해주세요.";
	    try {
	        mailService.sendSimpleMessage(email, subject, text);
	    } catch (Exception e) {
	        throw new RuntimeException("메일 발송 실패");
	    }
	}


	// 현재 비밀번호 일치 여부 확인
	@Override
	public boolean checkPassword(int memberId, String inputPassword) {
		Member member = memberRepository.findById(memberId);
		if (member == null) {
		return false;
		}
		
		// 암호화된 비밀번호와 일치하는지 검사
		return passwordEncoder.matches(inputPassword, member.getPassword());
	}


	// 새 비밀번호 암호화 후 저장
	@Override
	public void changePassword(int memberId, String newPassword) {
		String encodedPw = passwordEncoder.encode(newPassword);
		memberRepository.updatePassword(memberId, encodedPw);
	}
	
	
	
	private String generateTempPassword() {
	    String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	    StringBuilder sb = new StringBuilder();
	    for (int i = 0; i < 8; i++) {
	        int idx = (int) (Math.random() * chars.length());
	        sb.append(chars.charAt(idx));
	    }
	    return sb.toString();
	}


	// 이메일을 기반으로 회원 정보 조회 (비밀번호 찾기용)
	@Override
	public Member findByEmail(String email) {
		
		return memberRepository.findByEmail(email);
	}


	// 실명 + 이메일로 회원 조회 (아이디 찾기용)
	@Override
	public Member findByRealNameAndEmail(String realName, String email) {
		
		return memberRepository.findByRealNameAndEmail(realName, email);
	}
	
	
	

}
