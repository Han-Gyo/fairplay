package com.fairplay.service;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.fairplay.domain.Member;
import com.fairplay.enums.MemberStatus;
import com.fairplay.repository.MemberRepository;

@Service
public class MemberServiceImpl implements MemberService {
    
    @Autowired
    private MemberRepository memberRepository;
    
    @Autowired
    private MailService mailService;
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    // 회원가입 요청으로 전달된 member 데이터를 저장 (Create)
    @Override
    public void save(Member member) {
        // 회원 가입 시 기본 상태는 ACTIVE로 설정
        member.setStatus(MemberStatus.ACTIVE);
        memberRepository.save(member);
    }

    // 전체 회원 목록 조회 (Read_all)
    @Override
    public List<Member> readAll() {
        return memberRepository.readAll();
    }

    // 회원 한 명 조회 (Read_one)
    @Override
    public Member findById(int id) {
        return memberRepository.findById(id);
    }

    // 전달받은 Member 객체를 Repository로 전달하여 DB 업데이트 수행 (Update)
    @Override
    public void update(Member member) {
        // 기존 회원 정보 조회
        Member existing = memberRepository.findById(member.getId());
        if (existing == null) {
            throw new RuntimeException("회원 정보를 찾을 수 없습니다.");
        }

        // user_id: 비어 있으면 기존 값 유지
        if (member.getUser_id() == null || member.getUser_id().isEmpty()) {
            member.setUser_id(existing.getUser_id());
        }

        // real_name: 비어 있으면 기존 값 유지
        if (member.getReal_name() == null || member.getReal_name().isEmpty()) {
            member.setReal_name(existing.getReal_name());
        }

        // nickname: 비어 있으면 기존 값 유지
        if (member.getNickname() == null || member.getNickname().isEmpty()) {
            member.setNickname(existing.getNickname());
        }

        // email: Controller에서 인증 여부 체크 후 넘어오기 때문에 여기서는 단순히 null 방지만
        if (member.getEmail() == null || member.getEmail().isEmpty()) {
            member.setEmail(existing.getEmail());
        }

        // address: 비어 있으면 기존 값 유지
        if (member.getAddress() == null || member.getAddress().isEmpty()) {
            member.setAddress(existing.getAddress());
        }

        // phone: 비어 있으면 기존 값 유지
        if (member.getPhone() == null || member.getPhone().isEmpty()) {
            member.setPhone(existing.getPhone());
        }

        // profileImage: 비어 있으면 기존 값 유지
        if (member.getProfileImage() == null || member.getProfileImage().isEmpty()) {
            member.setProfileImage(existing.getProfileImage());
        }

        // password: 여기서는 변경하지 않음 (별도 changePassword 로직 사용)
        member.setPassword(existing.getPassword());

        // status: null 방지
        if (member.getStatus() == null) {
            member.setStatus(existing.getStatus());
        }

        // role: null 방지
        if (member.getRole() == null || member.getRole().isEmpty()) {
            member.setRole(existing.getRole());
        }

        // inactive_at: null 방지
        if (member.getInactive_at() == null) {
            member.setInactive_at(existing.getInactive_at());
        }

        // 최종 업데이트 실행
        memberRepository.update(member);
    }

    // 회원 탈퇴 처리 (마스킹 + 상태 변경)
    @Override
    public void deactivate(int id) {
        Member member = memberRepository.findById(id);
        if (member == null || member.getStatus() == MemberStatus.INACTIVE) {
            return;
        }

        // 랜덤 UUID 및 타임스탬프 생성
        String uuid = UUID.randomUUID().toString();
        long ts = System.currentTimeMillis();

        // 아이디, 이메일, 닉네임 마스킹 처리
        member.setUser_id("deleted_" + uuid);
        member.setEmail("deleted_" + ts + "@masked.local");
        member.setNickname("deleted_" + member.getNickname() + "_" + uuid);

        // 비밀번호 랜덤화 (로그인 불가 처리)
        member.setPassword(passwordEncoder.encode(uuid));

        // 상태 변경 및 탈퇴 시점 기록
        member.setStatus(MemberStatus.INACTIVE);
        member.setInactive_at(java.time.LocalDateTime.now());

        // Repository에 업데이트 반영
        memberRepository.update(member);
    }

    @Override
    public Member findByUserId(String user_id) {
        return memberRepository.findByUserId(user_id);
    }

    // 아이디 중복 검사
    @Override
    public boolean isDuplicatedId(String userId) {
        return memberRepository.existsByUserId(userId);
    }

    // 닉네임 중복 검사
    @Override
    public boolean isDuplicatedNickname(String nickname) {
        return memberRepository.existsByNickname(nickname);
    }

    // 이메일 중복 검사
    @Override
    public boolean isDuplicatedEmail(String email) {
        return memberRepository.existsByEmail(email);
    }

    // 아이디 + 이메일로 회원 정보 조회
    @Override
    public Member findByUserIdAndEmail(String userId, String email) {
        return memberRepository.findByUserIdAndEmail(userId, email);
    }

    // 이메일을 기반으로 임시 비밀번호 생성, 암호화 후 저장 + 메일 전송
    @Override
    public void sendTempPassword(String userId, String email) {
        Member member = memberRepository.findByUserIdAndEmail(userId, email);
        if (member == null) {
            throw new RuntimeException("입력하신 정보가 정확하지 않습니다.");
        }

        String tempPw = generateTempPassword();
        String encodedPw = passwordEncoder.encode(tempPw);

        member.setPassword(encodedPw);
        int result = memberRepository.updatePassword(member);
        if (result == 0) {
            throw new RuntimeException("비밀번호 업데이트 실패");
        }

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