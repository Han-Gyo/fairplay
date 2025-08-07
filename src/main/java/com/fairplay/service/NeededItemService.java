package com.fairplay.service;

import java.util.List;

import com.fairplay.domain.NeededItemDTO;

public interface NeededItemService {

    // 특정 그룹의 모든 필요 물품 조회
    List<NeededItemDTO> getItemsByGroupId(Long groupId);

    // 단일 물품 조회 (수정 or 상세)
    NeededItemDTO getItemById(Long id);

    // 필요 물품 등록
    void addItem(NeededItemDTO item);

    // 필요 물품 수정
    void updateItem(NeededItemDTO item);

    // 필요 물품 삭제
    void deleteItem(Long id);

    // 구매 여부 토글
    void togglePurchased(Long id, boolean isPurchased);
}
