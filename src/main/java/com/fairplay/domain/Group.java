 package com.fairplay.domain;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.web.multipart.MultipartFile;



public class Group {
    
    private int id;                     	// 고유 그룹 ID
    private String name;                	// 그룹 이름
    private String description;         	// 그룹 설명
    private String code;                	// 초대 코드
    private Integer maxMember;          	// 최대 인원
    private boolean publicStatus;       	// 공개 여부
    private MultipartFile file;				// 업로드 받는 파일 (폼에서 전달)
    private String profile_img;         	// DB에 저장할 파일명
    private LocalDateTime created_at;       // 생성일시 (DB의 DATETIME과 연결됨)
    private String admin_comment;       	// 그룹장이 쓴 한 줄 메시지
    private int leaderId;					// 그룹 생성자 ID
    private String formattedAdminComment;	// JSP 출력용: admin_comment에 줄바꿈 <br/> 처리된 값 (DB에는 저장되지 않음)
    
    
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public Integer getMaxMember() {
		return maxMember;
	}
	public void setMaxMember(Integer maxMember) {
		this.maxMember = maxMember;
	}
	public boolean isPublicStatus() {
		return publicStatus;
	}
	public void setPublicStatus(boolean publicStatus) {
		this.publicStatus = publicStatus;
	}
	public String getProfile_img() {
		return profile_img;
	}
	public void setProfile_img(String profile_img) {
		this.profile_img = profile_img;
	}
	
	public LocalDateTime getCreated_at() {
		return created_at;
	}
	public void setCreated_at(LocalDateTime created_at) {
		this.created_at = created_at;
	}
	public String getAdmin_comment() {
		return admin_comment;
	}
	public void setAdmin_comment(String admin_comment) {
		this.admin_comment = admin_comment;
	}
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public int getLeaderId() {
		return leaderId;
	}
	public void setLeaderId(int leaderId) {
		this.leaderId = leaderId;
	}
	public String getFormattedAdminComment() {
		if (admin_comment == null) return "";
		return admin_comment.replaceAll("\r\n", "<br/>").replaceAll("\n", "<br/>");
	}
	public void setFormattedAdminComment(String formattedAdminComment) {
		this.formattedAdminComment = formattedAdminComment;
	}
	

	// 생성일을 문자열로 반환 JSP 출력용 헬퍼 메서드
	public String getFormattedCreatedAt() {
	    if (created_at == null) return "";
	    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	    return created_at.format(formatter);
	}
}
