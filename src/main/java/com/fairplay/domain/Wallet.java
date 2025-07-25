package com.fairplay.domain;

import java.util.Date;
import org.springframework.format.annotation.DateTimeFormat;

public class Wallet {
	private int id;                // 고유 ID
	private int member_id;         // 작성한 사용자 ID
	private Integer group_id;          // 소속 그룹 ID
	private String item_name;      // 물품 이름
	private String category;       // 카테고리 (식비, 생필품 등)
	private Integer price;         // 총 가격
	private Integer quantity;      // 수량
	private String unit;           // 단위 (ex. 개, 묶음)
	private Integer unit_count;    // 단위당 개수 (예: 1묶음에 30개)
	private String store;          // 구매처 (마트, 편의점 등)
	private String type;           // 타입 (수입/지출)
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date purchase_date;    // 구매 날짜
	private String memo;           // 메모
	private Date created_at;       // 작성일시
	
	public Wallet() {}
	
	public Wallet(int id, int member_id, Integer group_id, String item_name, String category, Integer price, Integer quantity,
			String unit, Integer unit_count, String store, String type, Date purchase_date, String memo, Date created_at) {
		super();
		this.id = id;
		this.member_id = member_id;
		this.group_id = group_id;
		this.item_name = item_name;
		this.category = category;
		this.price = price;
		this.quantity = quantity;
		this.unit = unit;
		this.unit_count = unit_count;
		this.store = store;
		this.type = type;
		this.purchase_date = purchase_date;
		this.memo = memo;
		this.created_at = created_at;
	}
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getMember_id() {
		return member_id;
	}
	public void setMember_id(int member_id) {
		this.member_id = member_id;
	}
	public Integer getGroup_id() {
		return group_id;
	}
	public void setGroup_id(Integer group_id) {
		this.group_id = group_id;
	}
	public String getItem_name() {
		return item_name;
	}
	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public Integer getPrice() {
		return price;
	}
	public void setPrice(Integer price) {
		this.price = price;
	}
	public Integer getQuantity() {
		return quantity;
	}
	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
	}
	public Integer getUnit_count() {
		return unit_count;
	}
	public void setUnit_count(Integer unit_count) {
		this.unit_count = unit_count;
	}
	public String getStore() {
		return store;
	}
	public void setStore(String store) {
		this.store = store;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public Date getPurchase_date() {
		return purchase_date;
	}
	public void setPurchase_date(Date purchase_date) {
		this.purchase_date = purchase_date;
	}
	public String getMemo() {
		return memo;
	}
	public void setMemo(String memo) {
		this.memo = memo;
	}
	public Date getCreated_at() {
		return created_at;
	}
	public void setCreated_at(Date created_at) {
		this.created_at = created_at;
	}
}
