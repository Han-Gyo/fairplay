package com.fairplay.service;

import java.util.List;
import com.fairplay.domain.HistoryComment;

public interface HistoryCommentService {
	
    void addComment(HistoryComment comment);
    List<HistoryComment> getCommentsByHistoryId(int historyId);
    void updateComment (HistoryComment comment);
    void deleteComment(int id, int requesterId, String role); 
    HistoryComment getCommentById(int id);
    HistoryComment getLatestCommentByHistoryId(int historyId);
}
