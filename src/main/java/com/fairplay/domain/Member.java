package com.fairplay.domain;

import java.time.LocalDateTime;

import com.fairplay.enums.MemberStatus;

// 회원 엔티티 (DB 테이블과 매핑)
public class Member {

    private int id;                         // 고유 사용자 ID
    private String user_id;                 // 로그인용 아이디
    private String password;                // 로그인용 비밀번호 (암호화 저장)
    private String real_name;               // 실명
    private String nickname;                // 닉네임 (화면 표시용)
    private String email;                   // 이메일 (비밀번호 찾기 등)
    private String address;                 // 주소 (선택)
    private String phone;                   // 휴대폰 번호 (선택)
    private MemberStatus status;            // 계정 상태 (ACTIVE / INACTIVE)
    private String role;                    // 권한 (USER / ADMIN)
    private LocalDateTime created_at;       // 가입일시
    private LocalDateTime inactive_at;      // 탈퇴(비활성화) 시점 기록
    private String profileImage;            // 프로필 이미지 파일명 (선택)

    // Getter / Setter
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getUser_id() {
        return user_id;
    }
    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public String getReal_name() {
        return real_name;
    }
    public void setReal_name(String real_name) {
        this.real_name = real_name;
    }

    public String getNickname() {
        return nickname;
    }
    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }
    public void setPhone(String phone) {
        this.phone = phone;
    }

    public MemberStatus getStatus() {
        return status;
    }
    public void setStatus(MemberStatus status) {
        this.status = status;
    }

    public String getRole() {
        return role;
    }
    public void setRole(String role) {
        this.role = role;
    }

    public LocalDateTime getCreated_at() {
        return created_at;
    }
    public void setCreated_at(LocalDateTime created_at) {
        this.created_at = created_at;
    }

    public LocalDateTime getInactive_at() {
        return inactive_at;
    }
    public void setInactive_at(LocalDateTime inactive_at) {
        this.inactive_at = inactive_at;
    }

    public String getProfileImage() {
        return profileImage;
    }
    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }
}