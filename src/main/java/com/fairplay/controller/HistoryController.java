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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
	        Model model,
	        RedirectAttributes ra) {

	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        ra.addFlashAttribute("msg", "로그인 후 이용해주세요.");
	        return "redirect:/member/login";
	    }
	    // 세션에 currentGroupId 없으면 설정
	    if (session.getAttribute("currentGroupId") == null) {
	        List<Group> myGroups = groupMemberService.findGroupsByMemberId(Long.valueOf(loginMember.getId()));

	        if (!myGroups.isEmpty()) {
	            int firstGroupId = myGroups.get(0).getId();
	            session.setAttribute("currentGroupId", firstGroupId);

	            String role = groupMemberService.findRoleByMemberIdAndGroupId(loginMember.getId(), firstGroupId);
	            session.setAttribute("role", role);
	        } else {
	            ra.addFlashAttribute("msg", "가입된 그룹이 없습니다.");
	            return "redirect:/";
	        }
	    }

	    Integer groupId = (Integer) session.getAttribute("currentGroupId");
	    if (!groupMemberService.isGroupMember(Long.valueOf(groupId), Long.valueOf(loginMember.getId()))) {
	        ra.addFlashAttribute("msg", "접근 권한이 없습니다.");
	        return "redirect:/";
	    }

	    // 이후 기존 로직
	    List<History> historyList;
	    if (todoId != null) {
	        Todo todo = todoService.findById(todoId);
	        historyList = historyService.getHistoriesByTodoIdWithDetails(todoId);
	        model.addAttribute("selectedTodo", todo);
	    } else {
	        historyList = historyService.getAllHistoriesWithDetails();
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
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	    	return "redirect:/";
	    }
	    
	    // todo 및 그룹 ID 추출
	    Todo todo = todoService.findById(todo_id);
	    int groupId = todo.getGroup_id();
	    
	    // Long 타입으로 변환
	    Long memberId = Long.valueOf(loginMember.getId());
	    Long groupIdLong = Long.valueOf(groupId);
	    
	    // 그룹원이 아니면 접근 차단 (여기가 먼저!)
	    if (!groupMemberService.isGroupMember(groupIdLong, memberId)) {
	        return "redirect:/";
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
	public String addHistory(@RequestParam(required = false) Integer todo_id,
	                         HttpSession session,
	                         Model model,
	                         RedirectAttributes ra) {

	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        ra.addFlashAttribute("msg", "로그인 후 이용해주세요.");
	        return "redirect:/member/login";
	    }

	    Integer groupId = (Integer) session.getAttribute("currentGroupId");
	    if (groupId == null || !groupMemberService.isGroupMember(Long.valueOf(groupId), Long.valueOf(loginMember.getId()))) {
	        ra.addFlashAttribute("msg", "그룹에 속해있지 않습니다.");
	        return "redirect:/";
	    }

	    if (todo_id != null) {
	        Todo todo = todoService.findById(todo_id);
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


	// 3. 기록 등록 처리 (수정본: 그대로 교체)
	@PostMapping("/create")
	public String addHistory(
	        HttpServletRequest request,
	        @RequestParam("todo_id") int todoId,
	        @RequestParam("score") int score,
	        @RequestParam("memo") String memo,
	        @RequestParam(value = "photo", required = false) MultipartFile photo,
	        HttpSession session,
	        RedirectAttributes ra
	) {
	    // 1) 로그인 확인
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        ra.addFlashAttribute("error", "로그인이 필요합니다.");
	        return "redirect:/member/login";
	    }

	    // 2) Todo 존재/권한 확인
	    Todo todo = todoService.findById(todoId);
	    if (todo == null) {
	        ra.addFlashAttribute("error", "존재하지 않는 할 일입니다.");
	        return "redirect:/todos";
	    }
	    Long groupId = (long) todo.getGroup_id();
	    Long loginUserId = (long) loginMember.getId();
	    if (!groupMemberService.isGroupMember(groupId, loginUserId)) {
	        ra.addFlashAttribute("error", "이 그룹에 소속되어 있지 않습니다.");
	        return "redirect:/todos";
	    }

	    // 3) History 생성 (member_id는 세션 사용자로 고정)
	    History history = new History();
	    history.setTodo_id(todoId);
	    history.setMember_id(loginMember.getId()); // ★ 핵심: 파라미터 대신 세션 사용자
	    history.setCompleted_at(new Date());
	    history.setScore(score);                   // 폼에서 받은 점수 그대로
	    history.setMemo(memo);

	    // 4) 사진 저장 (있을 때만)
	    if (photo != null && !photo.isEmpty()) {
	        try {
	            String fileName = System.currentTimeMillis() + "_" + photo.getOriginalFilename();
	            File dir = new File("C:/upload/");
	            if (!dir.exists()) dir.mkdirs();
	            File savedFile = new File(dir, fileName);
	            photo.transferTo(savedFile);
	            history.setPhoto(fileName);
	        } catch (Exception e) {
	            e.printStackTrace();
	            ra.addFlashAttribute("error", "사진 업로드에 실패했습니다.");
	        }
	    }

	    // 5) 저장 (세션-DB 불일치 시 500 방지용 안내)
	    try {
	        historyService.addHistory(history);
	    } catch (org.springframework.dao.DataIntegrityViolationException ex) {
	        ra.addFlashAttribute("error", "세션 사용자 정보가 유효하지 않습니다. 다시 로그인해주세요.");
	        return "redirect:/member/login";
	    }

	    // 6) 완료 플래그만 업데이트 (히스토리 INSERT는 여기서만!)
	    //  - 네 서비스가 구시그니처면 아래 줄 유지
	    //  - 서비스가 (id, completedBy)로 바뀌었으면 두 번째 인자로 loginMember.getId() 넘겨
	    todoService.completeTodo(todoId);
	    // todoService.completeTodo(todoId, loginMember.getId()); // ← 신시그니처라면 이걸 사용

	    // 7) 이동
	    return "redirect:/history?todo_id=" + todoId;
	}


    // 4. 기록 수정 폼
	@GetMapping("/update")
	public String updateHistory(@RequestParam("id") int id, HttpSession session, Model model) {
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	    	return "redirect:/";
	    }

	    History history = historyService.getHistoryByIdWithDetails(id);
	    Todo todo = todoService.findById(history.getTodo_id());
	    Long groupId = Long.valueOf(todo.getGroup_id());
	    Long memberId = Long.valueOf(loginMember.getId());

	    if (!groupMemberService.isGroupMember(groupId, memberId)) {
	        return "redirect:/";
	    }

	    model.addAttribute("history", history);
	    model.addAttribute("todoList", todoService.getTodoList());
	    model.addAttribute("memberList", memberService.readAll());

	    return "historyUpdateForm";
	}
    
    // 5. 수정 처리
	@PostMapping("/update")
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
		    Member loginMember = (Member) session.getAttribute("loginMember");
		    if (loginMember == null) {
		    	return "redirect:/";
		    }

		    Todo todo = todoService.findById(todoId);
		    Long groupId = Long.valueOf(todo.getGroup_id());
		    Long loginUserId = Long.valueOf(loginMember.getId());

		    if (!groupMemberService.isGroupMember(groupId, loginUserId)) {
		        return "redirect:/";
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
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	    	return "redirect:/";
	    }

	    Todo todo = todoService.findById(todo_id);
	    Long groupId = Long.valueOf(todo.getGroup_id());
	    Long memberId = Long.valueOf(loginMember.getId());

	    if (!groupMemberService.isGroupMember(groupId, memberId)) {
	        return "redirect:/";
	    }

	    historyService.deleteHistory(id);
	    return "redirect:/history?todo_id=" + todo_id;
	}
    
    // 7. 히스토리 상세 보기
	@GetMapping("/detail")
	public String detailHistory(@RequestParam("history_id") int historyId, HttpSession session, Model model) {
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	    	return "redirect:/";
	    }

	    History history = historyService.getHistoryByIdWithDetails(historyId);
	    Todo todo = todoService.findById(history.getTodo_id());
	    Long groupId = Long.valueOf(todo.getGroup_id());
	    Long memberId = Long.valueOf(loginMember.getId());

	    if (!groupMemberService.isGroupMember(groupId, memberId)) {
	        return "redirect:/";
	    }

	    List<HistoryComment> commentList = commentService.getCommentsByHistoryId(historyId);
	    model.addAttribute("commentList", commentList);
	    model.addAttribute("history", history);
	    return "historyDetail";
	}

    // 8. 점수 계산
	@GetMapping("/monthly-score")
	public String showMonthlyScore(
	        @RequestParam(value = "group_id", required = false) Integer groupId,
	        @RequestParam(value = "yearMonth", required = false) String yearMonth,
	        HttpSession session,
	        Model model
	) {
	    // 세션 키 통일: loginMember
	    Member login = (Member) session.getAttribute("loginMember");
	    if (login == null) return "redirect:/member/login";

	    // group_id 없으면 기본 그룹으로 1회 리다이렉트
	    if (groupId == null) {
	        Integer def = groupMemberService.findDefaultGroupId(login.getId());
	        System.out.println("[MS] login=" + login.getId() + ", defaultGroup=" + def);
	        if (def == null) {
	            // 가입 그룹 없음 → 그룹 목록으로 (절대 다시 monthly-score로 보내지 말 것)
	            return "redirect:/group/list";
	        }
	        String ym = (yearMonth != null && !yearMonth.isEmpty()) ? "&yearMonth=" + yearMonth : "";
	        return "redirect:/history/monthly-score?group_id=" + def + ym;
	    }

	    // 권한검사
	    Long gid = groupId.longValue();
	    Long mid = Long.valueOf(login.getId());
	    if (!groupMemberService.isGroupMember(gid, mid)) {
	        return "redirect:/";
	    }

	    // yearMonth 기본값
	    if (yearMonth == null || yearMonth.isEmpty()) {
	        java.time.LocalDate now = java.time.LocalDate.now();
	        yearMonth = now.getYear() + "-" + String.format("%02d", now.getMonthValue());
	    }

	    // 데이터 조회
	    Group group = groupService.findById(groupId);
	    List<GroupMonthlyScore> groupScores = historyService.getGroupMonthlyScore(groupId, yearMonth);
	    List<MemberMonthlyScore> memberScores = historyService.getMemberMonthlyScore(groupId, yearMonth);

	    // 모델
	    model.addAttribute("groupScores", groupScores);
	    model.addAttribute("memberScores", memberScores);
	    model.addAttribute("yearMonth", yearMonth);
	    model.addAttribute("group", group);
	    model.addAttribute("groupId", groupId);

	    return "monthlyScore";
	}
    
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        binder.registerCustomEditor(java.util.Date.class, new CustomDateEditor(dateFormat, false));
    }
}
