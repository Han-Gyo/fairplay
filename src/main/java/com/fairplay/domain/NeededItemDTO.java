package com.fairplay.domain;

import java.time.LocalDateTime;

public class NeededItemDTO {

    private Long id;              // 물품 ID
    private Long groupId;         // 그룹 ID
    private String itemName;      // 물품 이름
    private int quantity;         // 수량
    private Long addedBy;         // 작성자 ID
    private boolean isPurchased;  // 구매 여부
    private LocalDateTime createdAt;  // 생성일
    private LocalDateTime updatedAt;  // 수정일
    private String writerNickname;	// 작성자 별명
    private String memo;		  // 메모

    //  기본 생성자
    public NeededItemDTO() {}

    //  전체 필드 생성자 
    public NeededItemDTO(Long id, Long groupId, String itemName, int quantity,
                         Long addedBy, boolean isPurchased,
                         LocalDateTime createdAt, LocalDateTime updatedAt, String writerNickname,
                         String memo) {
        this.id = id;
        this.groupId = groupId;
        this.itemName = itemName;
        this.quantity = quantity;
        this.addedBy = addedBy;
        this.isPurchased = isPurchased;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    
    //  Getter/Setter
    
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getGroupId() {
		return groupId;
	}

	public void setGroupId(Long groupId) {
		this.groupId = groupId;
	}

	public String getItemName() {
		return itemName;
	}

	public void setItemName(String itemName) {
		this.itemName = itemName;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public Long getAddedBy() {
		return addedBy;
	}

	public void setAddedBy(Long addedBy) {
		this.addedBy = addedBy;
	}

	public boolean isPurchased() {
		return isPurchased;
	}

	public void setPurchased(boolean isPurchased) {
		this.isPurchased = isPurchased;
	}

	public LocalDateTime getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}

	public LocalDateTime getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(LocalDateTime updatedAt) {
		this.updatedAt = updatedAt;
	}

	public String getWriterNickname() {
		return writerNickname;
	}

	public void setWriterNickname(String writerNickname) {
		this.writerNickname = writerNickname;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

    
}
