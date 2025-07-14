package com.fairplay.domain;
import java.sql.Timestamp;

public class Group {
    
    private int id;                     // 고유 그룹 ID
    private String name;                // 그룹 이름
    private String description;         // 그룹 설명
    private String code;                // 초대 코드
    private int max_member;             // 최대 인원
    private boolean is_public;          // 공개 여부
    private String profile_img;         // 그룹 대표 이미지 파일명
    private Timestamp created_at;       // 생성일시 (DB의 DATETIME과 연결됨)
    private String admin_comment;       // 그룹장이 쓴 한 줄 메시지
    
    
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
	public int getMax_member() {
		return max_member;
	}
	public void setMax_member(int max_member) {
		this.max_member = max_member;
	}
	public boolean isIs_public() {
		return is_public;
	}
	public void setIs_public(boolean is_public) {
		this.is_public = is_public;
	}
	public String getProfile_img() {
		return profile_img;
	}
	public void setProfile_img(String profile_img) {
		this.profile_img = profile_img;
	}
	public Timestamp getCreated_at() {
		return created_at;
	}
	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}
	public String getAdmin_comment() {
		return admin_comment;
	}
	public void setAdmin_comment(String admin_comment) {
		this.admin_comment = admin_comment;
	}

    
}
