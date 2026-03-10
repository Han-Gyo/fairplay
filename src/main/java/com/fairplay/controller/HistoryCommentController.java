package com.fairplay.controller;


import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fairplay.domain.HistoryComment;
import com.fairplay.domain.Member;
import com.fairplay.service.HistoryCommentService;

@Controller
@RequestMapping("/history/comments")
public class HistoryCommentController {

    @Autowired
    private HistoryCommentService commentService;

    // 댓글 등록
    @PostMapping("/add")
    public String addComment(
        @RequestParam("history_id") int historyId,
        @RequestParam("content") String content,
        HttpSession session
    ) {
        Member loginMember = (Member) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/login";  // 로그인 안된 경우 로그인 페이지로
        }

        HistoryComment comment = new HistoryComment();
        comment.setHistoryId(historyId);
        comment.setMemberId(loginMember.getId());
        comment.setContent(content);

        commentService.addComment(comment);
        
        // DB에서 실제 등록된 댓글 조회해서 시간 확인
        HistoryComment saved = commentService.getLatestCommentByHistoryId(historyId);

        return "redirect:/history/detail?history_id=" + historyId;
    }
    // 댓글 수정
    @PostMapping("/update")
    @ResponseBody
    public String updateComment(@RequestParam int id, @RequestParam String content) {

        HistoryComment comment = new HistoryComment();
        comment.setId(id);
        comment.setContent(content);

        commentService.updateComment(comment);

        return "success";
    }
    
    // 댓글 삭제
    @PostMapping("/delete")
    public String deleteComment(
        @RequestParam("id") int commentId,
        @RequestParam("history_id") int historyId,
        HttpSession session
    ) {
        Member loginMember = (Member) session.getAttribute("loginMember");

        if (loginMember == null) {
            return "redirect:/login";
        }

        commentService.deleteComment(commentId, loginMember.getId(), loginMember.getRole());

        return "redirect:/history/detail?history_id=" + historyId;
    }

    // 댓글 목록 별도 뷰에 출력할 때 필요
    @GetMapping("/list")
    public String commentList(@RequestParam("history_id") int historyId, Model model) {
        List<HistoryComment> commentList = commentService.getCommentsByHistoryId(historyId);
        model.addAttribute("commentList", commentList);
        return "commentList"; // → 별도 jsp로 분리하고 싶을 경우
    }
}
