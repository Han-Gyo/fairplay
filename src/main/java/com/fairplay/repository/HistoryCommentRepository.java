package com.fairplay.repository;

import java.util.List;
import com.fairplay.domain.HistoryComment;

public interface HistoryCommentRepository {
	
    void save(HistoryComment comment);					// 댓글 등록
    List<HistoryComment> findByHistoryId(int historyId);// 댓글 전체 조회 (특정 히스토리에 대한)
    void delete(int id);								// 댓글 삭제 (작성자 or 관리자만 가능하게 할 예정)
    HistoryComment findById(int id);					// 댓글 단 건 조회
}
