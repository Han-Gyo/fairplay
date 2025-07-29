package com.fairplay.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fairplay.domain.HistoryComment;
import com.fairplay.repository.HistoryCommentRepository;
@Service
public class HistoryCommentServiceImpl implements HistoryCommentService{

	@Autowired
	private HistoryCommentRepository commentRepository;
	
	@Override
	public void addComment(HistoryComment comment) {
		commentRepository.save(comment);
	}

	@Override
	public List<HistoryComment> getCommentsByHistoryId(int historyId) {
		return commentRepository.findByHistoryId(historyId);
	}
	
	@Override
	public void updateComment(HistoryComment comment) {
		commentRepository.update(comment);
	}

	@Override
	public void deleteComment(int id, int requesterId, String role) {
		HistoryComment target = commentRepository.findById(id);
		System.out.println("🧾 댓글 삭제 요청 - id: " + id + ", 요청자: " + requesterId + ", 역할: " + role);
        if (target == null) {
            throw new RuntimeException("댓글이 존재하지 않음");
        }

        boolean isAuthor = (target.getMemberId() == requesterId);
        boolean isAdmin = ("ADMIN".equalsIgnoreCase(role));
        if (isAuthor || isAdmin) {
        	System.out.println("✅ 삭제 허용: " + (isAuthor || isAdmin));
            commentRepository.delete(id);
        } else {
            throw new RuntimeException("삭제 권한 없음");
        }
	}

	@Override
	public HistoryComment getCommentById(int id) {
		return commentRepository.findById(id);
	}

	@Override
	public HistoryComment getLatestCommentByHistoryId(int historyId) {
		return commentRepository.getLatestCommentByHistoryId(historyId);
	}
	
}
