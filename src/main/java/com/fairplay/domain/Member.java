package com.fairplay.domain;

import java.time.LocalDateTime;

import com.fairplay.enums.MemberStatus;

// 사용자 정보를 담는 DTO 클래스
public class Member {

	// 회원 고유 ID (PK)
	private int id;
	
	// 사용자 로그인용 아이디
	private String user_id;
	
	// 로그인 비밀번호
	private String password;
	
	// 사용자 실명
	private String real_name;
	
	// 화면에 표시할 닉네임
	private String nickname;
	
	// 사용자 이메일
	private String email;
	
	// 주소 정보
	private String address;
	
	// 연락처 (전화번호)
	private String phone;
	
	// 계정 상태 (ex: ACTIVE, BANNED)
	private MemberStatus status;
	
	// 가입일자
	private LocalDateTime created_at;
	
	// 권한 : USER 또는 ADMIN
	private String role;
	
	// 프로필 사진
	private String profileImage;

	
	
	// 기본 생성자
	public Member() {

	}

	
	
	// getter & setter
	
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

	public LocalDateTime getCreated_at() {
		return created_at;
	}

	public void setCreated_at(LocalDateTime created_at) {
		this.created_at = created_at;
	}

	public String getReal_name() {
		return real_name;
	}

	public void setReal_name(String real_name) {
		this.real_name = real_name;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getProfileImage() {
		return profileImage;
	}

	public void setProfileImage(String profileImage) {
		this.profileImage = profileImage;
	}
	
	
}
