package com.fairplay.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.fairplay.domain.GroupMonthlyScore;
import com.fairplay.domain.History;
import com.fairplay.domain.HistoryComment;
import com.fairplay.domain.Member;
import com.fairplay.domain.MemberMonthlyScore;
import com.fairplay.domain.Todo;
import com.fairplay.service.GroupMemberService;
import com.fairplay.service.HistoryCommentService;
import com.fairplay.service.HistoryService;
import com.fairplay.service.MemberService;
import com.fairplay.service.TodoService;

@Controller
@RequestMapping("/history")
public class HistoryController {
	
	@Autowired
	private HistoryService historyService;
	
	@Autowired
	private TodoService todoService;
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private HistoryCommentService commentService;
	
	@Autowired
	private GroupMemberService groupMemberService;
	
	// ✅ 전체 히스토리 보기
	@GetMapping("/all")
	public String listAllHistories(@RequestParam(value = "todo_id", required = false) Integer todoId, Model model) {
	    
	    List<History> historyList;

	    // 👉 필터링이 들어온 경우: 해당 todoId에 해당하는 히스토리만 조회
	    if (todoId != null) {
	        historyList = historyService.getHistoriesByTodoIdWithDetails(todoId);

	        // 선택된 항목 표시용 (선택된 제목 띄우고 싶으면 아래 주석 해제해도 돼!)
	        Todo selectedTodo = todoService.findById(todoId);
	        model.addAttribute("selectedTodo", selectedTodo);
	    } else {
	        // 👉 필터 없으면 전체 조회
	        historyList = historyService.getAllHistoriesWithDetails();
	    }

	    // ✅ 네비게이션에 보여줄 전체 todo 목록 조회
	    List<Todo> todoList = todoService.getTodoList();

	    // ✅ JSP에 전달
	    model.addAttribute("historyList", historyList);
	    model.addAttribute("todoList", todoList);
	    model.addAttribute("selectedTodoId", todoId); // 선택 강조용

	    return "histories"; // -> histories.jsp
	}
	
	// ✅ 1. 기록 목록 (히스토리 리스트)
    @GetMapping
    public String listHistories (@RequestParam("todo_id") int todo_id, Model model) {
    	List<History> historyList = historyService.getHistoriesByTodoIdWithDetails(todo_id);
    	model.addAttribute("historyList", historyList);
    	
    	// 할일 title 전달
    	Todo todo = todoService.findById(todo_id);
    	model.addAttribute("todo", todo);
    	
    	return "histories";
    }
    
    // ✅ 2. 기록 등록 폼
    @GetMapping("/create")
    public String addHistory(@RequestParam(required = false) Integer todo_id, Model model) {
    	System.out.println("✅ 전달받은 todo_id: " + todo_id);
    	List<Todo> todoList = todoService.getTodoList();
    	List<Member> memberList = memberService.readAll();
    	
        model.addAttribute("history", new History());
        model.addAttribute("todoList", todoList);
        model.addAttribute("memberList", memberList);
        model.addAttribute("selectedTodoId", todo_id);
        return "historyCreateForm"; 
    }
    
    // ✅ 3. 기록 등록 처리
    @PostMapping("/create")
    public String addHistory(
	    HttpServletRequest request,  // ★ 추가: 저장 경로 구하기 위함
	    @RequestParam("todo_id") int todoId,
	    @RequestParam("member_id") int memberId,
	    @RequestParam("score") int score,
	    @RequestParam("memo") String memo,
	    @RequestParam(value = "photo", required = false) MultipartFile photo
    ) {
        System.out.println("📥 등록 요청 들어옴");

        History history = new History();
        history.setTodo_id(todoId);
        history.setMember_id(memberId);
        history.setCompleted_at(new Date()); 
        history.setScore(score);
        history.setMemo(memo);

        if (photo != null && !photo.isEmpty()) {
            String fileName = photo.getOriginalFilename();
            System.out.println("✔ 업로드된 파일명: " + fileName);

            // ✅ 1. 실제 저장 경로
            String uploadDir = "C:/upload/";
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs(); // 폴더 없으면 자동 생성

            try {
                File savedFile = new File(uploadDir, fileName);
                photo.transferTo(savedFile);  // ⭐ 실제 저장
                history.setPhoto(fileName);   // DB에는 파일명만 저장
            } catch (Exception e) {
                e.printStackTrace(); // 업로드 실패 시 에러 확인
            }
        } else {
            System.out.println("⚠ 사진 업로드 없음");
        }

        historyService.addHistory(history);
        todoService.completeTodo(todoId);
        return "redirect:/history?todo_id=" + todoId;
    }

    
    // ✅ 4. 기록 수정 폼
    @GetMapping("/update")
    public String updateHistory (@RequestParam("id") int id, Model model) {
    	History history = historyService.getHistoryByIdWithDetails(id);
    	
    	List<Todo> todoList = todoService.getTodoList();
        List<Member> memberList = memberService.readAll();
    	
    	model.addAttribute("todoList", todoList);
        model.addAttribute("memberList", memberList);
        model.addAttribute("history", history);
        return "historyUpdateForm";
    }
    
    // ✅ 5. 수정 처리
    @PostMapping("/update")
    public String updateHistory(
            HttpServletRequest request,
            @RequestParam("id") int id,
            @RequestParam("todo_id") int todoId,
            @RequestParam("member_id") int memberId,
            @RequestParam("score") int score,
            @RequestParam("memo") String memo,
            @RequestParam(value = "photo", required = false) MultipartFile photo
    ) {
        History history = new History();
        history.setId(id);
        history.setTodo_id(todoId);
        history.setMember_id(memberId);
        history.setCompleted_at(new Date()); 
        history.setScore(score);
        history.setMemo(memo);

        if (photo != null && !photo.isEmpty()) {
            String fileName = photo.getOriginalFilename();
            String uploadDir = "C:/upload/";
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            try {
                File savedFile = new File(uploadDir, fileName);
                photo.transferTo(savedFile);
                history.setPhoto(fileName);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        historyService.updateHistory(history);

        return "redirect:/history?todo_id=" + todoId;
    }

    
    // ✅ 6. 삭제
    @PostMapping("/delete")
    public String deleteHistory(@RequestParam("id") int id, @RequestParam("todo_id") int todo_id) {
        historyService.deleteHistory(id);
        return "redirect:/history?todo_id=" + todo_id;
    }
    
    // ✅ 7. 히스토리 상세 보기
    @GetMapping("/detail")
    public String detailHistory(@RequestParam("history_id") int historyId, Model model) {
    	History history = historyService.getHistoryByIdWithDetails(historyId);
    	List<HistoryComment> commentList = commentService.getCommentsByHistoryId(historyId);
    	model.addAttribute("commentList", commentList);

        model.addAttribute("history", history);
        return "historyDetail";
    }
    
    // ✅ 8. 점수 계산
    @GetMapping("/monthly-score")
    public String showMonthlyScore(
    	@RequestParam("group_id") Integer groupId, 
    	@RequestParam(value = "yearMonth", required = false) String yearMonth, 
    	Model model) {
    	
    	// ✅ yearMonth 기본값 처리 
    	if (yearMonth == null || yearMonth.isEmpty()) {
    		java.time.LocalDate now = java.time.LocalDate.now();
    		yearMonth = now.getYear() + "-" + String.format("%02d", now.getMonthValue());	// 예: 2025-07
    	}
    	
    	System.out.println("📌 [Controller] groupId = " + groupId);
        System.out.println("📌 [Controller] yearMonth = " + yearMonth);
        
    	// ✅ 서비스 호출 
    	List<GroupMonthlyScore> groupScores = historyService.getGroupMonthlyScore(groupId, yearMonth);
    	List<MemberMonthlyScore> memberScores = historyService.getMemberMonthlyScore(groupId, yearMonth);
    	
    	// ✅ 모델에 담기
    	model.addAttribute("groupScores", groupScores);		// 단일 객체지만 리스트로 받아올 수도 있음
    	model.addAttribute("memberScores", memberScores);
    	model.addAttribute("yearMonth", yearMonth);			// 뷰에서 < 6월 7월 8월 > 표시용
    	return "monthlyScore";
    }
    
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        binder.registerCustomEditor(java.util.Date.class, new CustomDateEditor(dateFormat, false));
    }
}
