package com.fairplay.repository;

import java.util.List;
import com.fairplay.domain.NeededItemDTO;

public interface NeededItemRepository {

    // 모든 필요 물품 조회 (특정 그룹 기준)
    List<NeededItemDTO> findAllByGroupId(Long groupId);

    // 단일 항목 조회 (수정/상세용)
    NeededItemDTO findById(Long id);

    // 필요 물품 등록
    int save(NeededItemDTO item);

    // 필요 물품 수정
    int update(NeededItemDTO item);

    // 필요 물품 삭제
    int delete(Long id);

    // 구매 여부 업데이트 (isPurchased만 바꿀 때 사용)
    int updatePurchasedStatus(Long id, boolean isPurchased);
}
