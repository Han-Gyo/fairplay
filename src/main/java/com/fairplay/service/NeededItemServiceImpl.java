package com.fairplay.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fairplay.domain.NeededItemDTO;
import com.fairplay.repository.NeededItemRepository;

@Service
public class NeededItemServiceImpl implements NeededItemService {

    @Autowired
    private NeededItemRepository neededItemRepository;

    // 그룹의 전체 물품 리스트 조회
    @Override
    public List<NeededItemDTO> getItemsByGroupId(Long groupId) {
        return neededItemRepository.findAllByGroupId(groupId);
    }

    // 단일 항목 조회 (수정 or 상세용)
    @Override
    public NeededItemDTO getItemById(Long id) {
        return neededItemRepository.findById(id);
    }

    // 새 물품 등록
    @Override
    public void addItem(NeededItemDTO item) {
        neededItemRepository.save(item);
    }

    // 물품 정보 수정
    @Override
    public void updateItem(NeededItemDTO item) {
        neededItemRepository.update(item);
    }

    // 물품 삭제
    @Override
    public void deleteItem(Long id) {
        neededItemRepository.delete(id);
    }

    // 구매 여부 변경 (is_purchased 토글)
    @Override
    public void togglePurchased(Long id, boolean isPurchased) {
        neededItemRepository.updatePurchasedStatus(id, isPurchased);
    }
}
