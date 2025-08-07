package com.fairplay.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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

import com.fairplay.domain.Group;
import com.fairplay.domain.GroupMemberInfoDTO;
import com.fairplay.domain.GroupMonthlyScore;
import com.fairplay.domain.History;
import com.fairplay.domain.HistoryComment;
import com.fairplay.domain.Member;
import com.fairplay.domain.MemberMonthlyScore;
import com.fairplay.domain.Todo;
import com.fairplay.service.GroupMemberService;
import com.fairplay.service.GroupService;
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
	private GroupService groupService;
	
	@Autowired
	private GroupMemberService groupMemberService;

	
	// 전체 히스토리 보기
	@GetMapping("/all")
	public String listAllHistories(
	        @RequestParam(value = "todo_id", required = false) Integer todoId,
	        HttpSession session,
	        Model model) {

	    // 로그인 사용자 확인
	    Member loginUser = (Member) session.getAttribute("loginUser");
	    if (loginUser == null) {
	        return "redirect:/access-denied";
	    }

	    Long loginUserId = Long.valueOf(loginUser.getId());

	    List<History> historyList;

	    if (todoId != null) {
	        Todo todo = todoService.findById(todoId);
	        Long groupId = Long.valueOf(todo.getGroup_id());

	        // ✅ 그룹원 여부 확인
	        if (!groupMemberService.isGroupMember(groupId, loginUserId)) {
	            return "redirect:/access-denied";
	        }

	        historyList = historyService.getHistoriesByTodoIdWithDetails(todoId);
	        model.addAttribute("selectedTodo", todo);
	    } else {
	        // 전체 보기 막고 싶으면 여기서 차단해도 됨
	        return "redirect:/access-denied";
	        
	        // or 그룹별 전체 보기 허용할 거면 아래와 같이 해도 됨:
	        // historyList = historyService.getAllHistoriesWithDetails(); 
	        // 단, 이 경우 로그인 사용자가 소속된 그룹만 필터링하는 방법도 가능
	    }

	    List<Todo> todoList = todoService.getTodoList();
	    model.addAttribute("historyList", historyList);
	    model.addAttribute("todoList", todoList);
	    model.addAttribute("selectedTodoId", todoId);

	    return "histories";
	}
	
	// 1. 기록 목록 (히스토리 리스트)
	@GetMapping
	public String listHistories(@RequestParam("todo_id") int todo_id, HttpSession session, Model model) {
	    
	    // 세션에서 로그인 사용자 꺼냄
	    Member loginUser = (Member) session.getAttribute("loginUser");
	    if (loginUser == null) {
	    	return "redirect:/access-denied";
	    }
	    
	    // todo 및 그룹 ID 추출
	    Todo todo = todoService.findById(todo_id);
	    int groupId = todo.getGroup_id();
	    
	    // Long 타입으로 변환
	    Long memberId = Long.valueOf(loginUser.getId());
	    Long groupIdLong = Long.valueOf(groupId);
	    
	    // 그룹원이 아니면 접근 차단 (여기가 먼저!)
	    if (!groupMemberService.isGroupMember(groupIdLong, memberId)) {
	        return "redirect:/access-denied";
	    }

	    // 검증 통과 후 데이터 조회
	    List<History> historyList = historyService.getHistoriesByTodoIdWithDetails(todo_id);
	    model.addAttribute("historyList", historyList);
	    model.addAttribute("todo", todo);
	    
	    System.out.println("그룹원 검증: memberId = " + memberId + ", groupId = " + groupIdLong);
	    
	    return "histories";
	}
    
    // 2. 기록 등록 폼
	@GetMapping("/create")
	public String addHistory(@RequestParam(required = false) Integer todo_id, HttpSession session, Model model) {
	    Member loginUser = (Member) session.getAttribute("loginUser");
	    if (loginUser == null) {
	    	return "redirect:/access-denied";
	    }

	    if (todo_id != null) {
	        Todo todo = todoService.findById(todo_id);
	        Long groupId = Long.valueOf(todo.getGroup_id());
	        Long memberId = Long.valueOf(loginUser.getId());

	        if (!groupMemberService.isGroupMember(groupId, memberId)) {
	            return "redirect:/access-denied";
	        }

	        model.addAttribute("selectedTodoId", todo_id);
	        List<GroupMemberInfoDTO> memberList = groupMemberService.findMemberInfoByGroupId(todo.getGroup_id());
	        model.addAttribute("memberList", memberList);
	    } else {
	        model.addAttribute("memberList", List.of());
	    }

	    model.addAttribute("history", new History());
	    model.addAttribute("todoList", todoService.getTodoList());

	    return "historyCreateForm";
	}

    // 3. 기록 등록 처리
	public String addHistory(
		    HttpServletRequest request,
		    @RequestParam("todo_id") int todoId,
		    @RequestParam("member_id") int memberId,
		    @RequestParam("score") int score,
		    @RequestParam("memo") String memo,
		    @RequestParam(value = "photo", required = false) MultipartFile photo,
		    HttpSession session
		) {
		    Member loginUser = (Member) session.getAttribute("loginUser");
		    if (loginUser == null) {
		    	return "redirect:/access-denied";
		    }

		    Todo todo = todoService.findById(todoId);
		    Long groupId = Long.valueOf(todo.getGroup_id());
		    Long loginUserId = Long.valueOf(loginUser.getId());

		    if (!groupMemberService.isGroupMember(groupId, loginUserId)) {
		        return "redirect:/access-denied";
		    }

		    History history = new History();
		    history.setTodo_id(todoId);
		    history.setMember_id(memberId);
		    history.setCompleted_at(new Date());
		    history.setScore(score);
		    history.setMemo(memo);

		    if (photo != null && !photo.isEmpty()) {
		        try {
		            String fileName = photo.getOriginalFilename();
		            File savedFile = new File("C:/upload/", fileName);
		            photo.transferTo(savedFile);
		            history.setPhoto(fileName);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }

		    historyService.addHistory(history);
		    todoService.completeTodo(todoId);

		    return "redirect:/history?todo_id=" + todoId;
		}

    // 4. 기록 수정 폼
	@GetMapping("/update")
	public String updateHistory(@RequestParam("id") int id, HttpSession session, Model model) {
	    Member loginUser = (Member) session.getAttribute("loginUser");
	    if (loginUser == null) {
	    	return "redirect:/access-denied";
	    }

	    History history = historyService.getHistoryByIdWithDetails(id);
	    Todo todo = todoService.findById(history.getTodo_id());
	    Long groupId = Long.valueOf(todo.getGroup_id());
	    Long memberId = Long.valueOf(loginUser.getId());

	    if (!groupMemberService.isGroupMember(groupId, memberId)) {
	        return "redirect:/access-denied";
	    }

	    model.addAttribute("history", history);
	    model.addAttribute("todoList", todoService.getTodoList());
	    model.addAttribute("memberList", memberService.readAll());

	    return "historyUpdateForm";
	}
    
    // 5. 수정 처리
	public String updateHistory(
		    HttpServletRequest request,
		    @RequestParam("id") int id,
		    @RequestParam("todo_id") int todoId,
		    @RequestParam("member_id") int memberId,
		    @RequestParam("score") int score,
		    @RequestParam("memo") String memo,
		    @RequestParam(value = "photo", required = false) MultipartFile photo,
		    HttpSession session
		) {
		    Member loginUser = (Member) session.getAttribute("loginUser");
		    if (loginUser == null) {
		    	return "redirect:/access-denied";
		    }

		    Todo todo = todoService.findById(todoId);
		    Long groupId = Long.valueOf(todo.getGroup_id());
		    Long loginUserId = Long.valueOf(loginUser.getId());

		    if (!groupMemberService.isGroupMember(groupId, loginUserId)) {
		        return "redirect:/access-denied";
		    }

		    History history = new History();
		    history.setId(id);
		    history.setTodo_id(todoId);
		    history.setMember_id(memberId);
		    history.setCompleted_at(new Date());
		    history.setScore(score);
		    history.setMemo(memo);

		    if (photo != null && !photo.isEmpty()) {
		        try {
		            String fileName = photo.getOriginalFilename();
		            File savedFile = new File("C:/upload/", fileName);
		            photo.transferTo(savedFile);
		            history.setPhoto(fileName);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }

		    historyService.updateHistory(history);
		    return "redirect:/history?todo_id=" + todoId;
		}

    // 6. 삭제
	@PostMapping("/delete")
	public String deleteHistory(@RequestParam("id") int id, @RequestParam("todo_id") int todo_id, HttpSession session) {
	    Member loginUser = (Member) session.getAttribute("loginUser");
	    if (loginUser == null) {
	    	return "redirect:/access-denied";
	    }

	    Todo todo = todoService.findById(todo_id);
	    Long groupId = Long.valueOf(todo.getGroup_id());
	    Long memberId = Long.valueOf(loginUser.getId());

	    if (!groupMemberService.isGroupMember(groupId, memberId)) {
	        return "redirect:/access-denied";
	    }

	    historyService.deleteHistory(id);
	    return "redirect:/history?todo_id=" + todo_id;
	}
    
    // 7. 히스토리 상세 보기
	public String detailHistory(@RequestParam("history_id") int historyId, HttpSession session, Model model) {
	    Member loginUser = (Member) session.getAttribute("loginUser");
	    if (loginUser == null) {
	    	return "redirect:/access-denied";
	    }

	    History history = historyService.getHistoryByIdWithDetails(historyId);
	    Todo todo = todoService.findById(history.getTodo_id());
	    Long groupId = Long.valueOf(todo.getGroup_id());
	    Long memberId = Long.valueOf(loginUser.getId());

	    if (!groupMemberService.isGroupMember(groupId, memberId)) {
	        return "redirect:/access-denied";
	    }

	    List<HistoryComment> commentList = commentService.getCommentsByHistoryId(historyId);
	    model.addAttribute("commentList", commentList);
	    model.addAttribute("history", history);
	    return "historyDetail";
	}

    // 8. 점수 계산
	public String showMonthlyScore(
		    @RequestParam("group_id") Integer groupId,
		    @RequestParam(value = "yearMonth", required = false) String yearMonth,
		    HttpSession session,
		    Model model
		) {
		    Member loginUser = (Member) session.getAttribute("loginUser");
		    if (loginUser == null) return "redirect:/";

		    Long groupIdLong = Long.valueOf(groupId);
		    Long memberId = Long.valueOf(loginUser.getId());

		    if (!groupMemberService.isGroupMember(groupIdLong, memberId)) {
		        return "redirect:/access-denied";
		    }

		    if (yearMonth == null || yearMonth.isEmpty()) {
		        java.time.LocalDate now = java.time.LocalDate.now();
		        yearMonth = now.getYear() + "-" + String.format("%02d", now.getMonthValue());
		    }

		    Group group = groupService.findById(groupId);
		    List<GroupMonthlyScore> groupScores = historyService.getGroupMonthlyScore(groupId, yearMonth);
		    List<MemberMonthlyScore> memberScores = historyService.getMemberMonthlyScore(groupId, yearMonth);

		    model.addAttribute("groupScores", groupScores);
		    model.addAttribute("memberScores", memberScores);
		    model.addAttribute("yearMonth", yearMonth);
		    model.addAttribute("group", group);

		    return "monthlyScore";
		}
    
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        binder.registerCustomEditor(java.util.Date.class, new CustomDateEditor(dateFormat, false));
    }
}
