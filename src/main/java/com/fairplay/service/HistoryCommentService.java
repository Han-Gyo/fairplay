package com.fairplay.service;

import java.util.List;
import com.fairplay.domain.HistoryComment;

public interface HistoryCommentService {
	
    void addComment(HistoryComment comment);
    List<HistoryComment> getCommentsByHistoryId(int historyId);
    void deleteComment(int id, int requesterId, String role);  // 작성자인지 관리자 확인해서 삭제 제한할 예정
    HistoryComment getCommentById(int id);
}
