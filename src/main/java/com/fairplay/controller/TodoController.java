package com.fairplay.controller;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fairplay.domain.Group;
import com.fairplay.domain.GroupMemberInfoDTO;
import com.fairplay.domain.Member;
import com.fairplay.domain.Todo;
import com.fairplay.domain.TodoSimple;
import com.fairplay.service.GroupMemberService;
import com.fairplay.service.GroupService;
import com.fairplay.service.TodoService;

@Controller
@RequestMapping("/todos")
public class TodoController {
	
	@Autowired
	private TodoService todoService;
	@Autowired
	private GroupService groupService;
	@Autowired
	private GroupMemberService groupMemberService;
	
	// 날짜 바인딩 설정 (yyyy-MM-dd 형식 사용)
	@InitBinder
	public void initBinder(WebDataBinder binder) {
	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	    dateFormat.setLenient(false);
	    binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
	}
	
	// 전체 할 일 목록 조회
	@GetMapping
	public String listTodos(@RequestParam(value = "groupId", required = false) Integer groupIdParam,HttpSession session, Model model, RedirectAttributes ra) {
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        ra.addFlashAttribute("error", "로그인이 필요합니다.");
	        return "redirect:/member/login";
	    }

	    Long memberId = Long.valueOf(loginMember.getId());

	    // 내가 가입한 그룹 리스트
	    List<Group> groupList = groupMemberService.findGroupsByMemberId(memberId);

	    if (groupList.isEmpty()) {
	        System.out.println("그룹 미가입자 접근 차단");
	        ra.addFlashAttribute("error", "소속된 그룹이 없습니다.");
	        return "redirect:/";
	    }
	    
	    if (groupIdParam != null) {
        session.setAttribute("currentGroupId", groupIdParam);
	    }

	    // 세션에 currentGroupId 없으면 첫 번째 그룹으로 설정
	    if (session.getAttribute("currentGroupId") == null) {
	        Group firstGroup = groupList.get(0);
	        int groupId = firstGroup.getId();
	        session.setAttribute("currentGroupId", groupId);

	        String role = groupMemberService.findRoleByMemberIdAndGroupId(loginMember.getId(), groupId);
	        session.setAttribute("role", role);

	        System.out.println("그룹 세션 설정 완료 → groupId: " + groupId + " / role: " + role);
	    }

	    // 세션에서 groupId 꺼냄
	    Integer groupId = (Integer) session.getAttribute("currentGroupId");

	    // 이 그룹에 소속되어 있는지 최종 확인
	    boolean isMember = groupMemberService.isGroupMember((long) groupId, memberId);
	    if (!isMember) {
	        System.out.println("접근 차단 - 그룹 소속 아님");
	        ra.addFlashAttribute("error", "이 그룹에 소속되어 있지 않습니다.");
	        return "redirect:/";
	    }

	    // 역할 재설정 (안전하게)
	    String role = groupMemberService.findRoleByMemberIdAndGroupId(loginMember.getId(), groupId);
	    session.setAttribute("role", role);

	    // groupId 기준으로 할 일만 불러와야 함
	    List<Todo> todoList = todoService.findByGroupId(groupId);

	    System.out.println("할 일 목록 출력 시작 (groupId: " + groupId + ")");
	    for (Todo t : todoList) {
	        System.out.println(" - " + t.getTitle() + " / 상태: " + t.getStatus() + " / 담당자: " + t.getAssigned_to());
	    }

	    // 멤버 매핑
	    List<GroupMemberInfoDTO> memberList = groupMemberService.findMemberInfoByGroupId(groupId); 
	    Map<Integer, String> memberMap = new HashMap<>();
	    
	    for (GroupMemberInfoDTO m : memberList) { 
	        memberMap.put(m.getMemberId(), m.getNickname()); 
	    }
	    Group group = groupService.findById(groupId); 
	    
	    model.addAttribute("group", group);
	    model.addAttribute("loginMemberId", loginMember.getId());
	    model.addAttribute("todoList", todoList);
	    model.addAttribute("memberMap", memberMap);
	    model.addAttribute("joinedGroups", groupList);
	    model.addAttribute("groupId", groupId);
	    
	    return "todos";
	}

	
	// 그룹장만 할 일 등록 폼 접근 가능
	@GetMapping("/create")
	public String addTodo(@RequestParam(value="groupId", required=false) int groupId,
	                      Model model,
	                      HttpSession session,
	                      RedirectAttributes ra) {

	    // 로그인 사용자 정보 꺼내기
	    Member loginUser = (Member) session.getAttribute("loginMember");
	    if (loginUser == null) {
	        ra.addFlashAttribute("error", "로그인 후 이용해주세요.");
	        return "redirect:/";
	    }

	    int memberId = loginUser.getId();

	    List<Group> groupList = groupMemberService.findGroupsByMemberId((long) loginUser.getId()); 
	    if (groupList.isEmpty()) { 
	    	ra.addFlashAttribute("error", "소속된 그룹이 없습니다."); 
	    	return "redirect:/"; 
	    }
	    
	    // 그룹 정보 가져오기
	    Group group = groupService.findById(groupId);
	    if (group == null) {
	        ra.addFlashAttribute("error", "존재하지 않는 그룹입니다.");
	        return "redirect:/";
	    }
	    
	    // 그룹장 권한 체크
	    if (group.getLeaderId() != memberId) {
	        ra.addFlashAttribute("error", "그룹장만 할 일을 등록할 수 있습니다.");
	        return "redirect:/todos?groupId=" + groupId;
	    }
	    // 등록폼 세팅
	    List<GroupMemberInfoDTO> memberList = groupMemberService.findMemberInfoByGroupId(groupId);
	    model.addAttribute("joinedGroups", groupList);
	    model.addAttribute("memberList", memberList);
	    model.addAttribute("groupId", groupId);
	    
	    System.out.println("[등록폼 진입] 로그인 멤버 ID: " + memberId);
	    System.out.println("[등록폼 진입] 그룹장 ID: " + group.getLeaderId());

	    return "todoCreateForm";
	}
	
	// 할 일 실제 등록 처리
	@PostMapping("/create")
	public String addTodo(
	    @RequestParam("title") String title,
	    @RequestParam("group_id") int group_id,
	    @RequestParam(value = "assigned_to", required = false) Integer assigned_to,
	    @RequestParam("due_date") @DateTimeFormat(pattern = "yyyy-MM-dd") Date due_date,
	    @RequestParam("difficulty_point") int difficulty_point,
	    @RequestParam("completed") boolean completed,
	    HttpSession session,
	    RedirectAttributes ra
	) {
		
		Member loginUser = (Member) session.getAttribute("loginMember"); 
		if (loginUser == null) { 
			ra.addFlashAttribute("error", "로그인 후 이용해주세요."); 
			return "redirect:/"; 
		}
		
		Group group = groupService.findById(group_id); 
		if (group.getLeaderId() != loginUser.getId()) { 
			ra.addFlashAttribute("error", "그룹장만 할 일을 등록할 수 있습니다."); 
			return "redirect:/todos?groupId=" + group_id; 
		}
		
	    Todo todo = new Todo();
	    todo.setTitle(title);
	    todo.setGroup_id(group_id);
	    todo.setAssigned_to(assigned_to); 
	    todo.setDue_date(due_date);
	    todo.setDifficulty_point(difficulty_point);
	    todo.setCompleted(completed);

	    System.out.println("받은 title: " + title);
	    System.out.println("받은 group_id: " + group_id);
	    System.out.println("받은 assigned_to: " + assigned_to);
	    System.out.println("completed 값: " + completed);

	    todoService.addTodo(todo);
	    return "redirect:/todos";
	}
	
	// 수정 폼 이동
	@GetMapping("/update")
	public String updateTodo(@RequestParam("id") int id, Model model, HttpSession session) {
	   Todo todo = todoService.findById(id);
	   Integer groupId = (Integer) session.getAttribute("currentGroupId");
	   
	   // 이 그룹의 멤버 목록을 가져와서 셀렉트 박스에 뿌려주기 위해 추가
	   List<GroupMemberInfoDTO> memberList = groupMemberService.findMemberInfoByGroupId(groupId);
	   
	   model.addAttribute("todo", todo);
	   model.addAttribute("memberList", memberList); 
	   return "todoUpdateForm"; 
	}
	
	// 수정 처리
	@PostMapping("/update")
	public String updateTodo(@ModelAttribute Todo todo, HttpSession session) {
	   todoService.updateTodo(todo);
	   // 수정 후 내가 보던 그룹 페이지로 리다이렉트
	   Integer groupId = (Integer) session.getAttribute("currentGroupId");
	   return "redirect:/todos?groupId=" + groupId;
	}
	
	// 삭제 처리
	@PostMapping("/delete")
	public String deleteTodo(@RequestParam("id") int id, HttpSession session) {
	   todoService.deleteTodo(id);
	   Integer groupId = (Integer) session.getAttribute("currentGroupId");
	   return "redirect:/todos?groupId=" + groupId;
	}

	// 할 일 완료 처리
	@PostMapping("/complete")
	public String completeTodo(@RequestParam("id") int id) {
		System.out.println("완료 요청 ID: " + id);
		todoService.completeTodo(id);
		return "redirect:/todos";
	}
	
	// 선착순 신청 처리
	@PostMapping("/assign")
	public String assignTodo(@RequestParam("todo_id")int todo_id, HttpSession session, RedirectAttributes redirectAttributes, Model model) {
		System.out.println("신청 요청 - todo_id: " + todo_id);	
		
		// 세션에서 로그인 정보 가져오기
		Member loginMember = (Member) session.getAttribute("loginMember");
		System.out.println("세션에서 loginMember: " + loginMember);
		
		if (loginMember == null) {
			System.out.println("로그인 안된 사용자 요청");
			redirectAttributes.addFlashAttribute("msg", "로그인 후 이용해주세요!");
			return "redirect:/todos";
		}
		
		int memberId = loginMember.getId();
		System.out.println("로그인 사용자 ID: " + memberId);
		
		model.addAttribute("loginMemberId", loginMember.getId());
		model.addAttribute("todoList", todoService.getTodoList());
		
	    // 신청 처리
	    boolean success = todoService.assignTodo(todo_id, memberId);

	    if (!success) {
	    	System.out.println("신청 실패 - 이미 신청됨");
	        redirectAttributes.addFlashAttribute("msg", "이미 누군가 신청했어요!");
	    } else {
	    	System.out.println("신청 성공!");
	        redirectAttributes.addFlashAttribute("msg", "신청 성공!");
	    }

	    return "redirect:/todos";
	}
	
	// 내 할 일 목록 조회
	@GetMapping("/myTodos")
	public String myTodos(HttpSession session, Model model) {
	    Member loginMember = (Member) session.getAttribute("loginMember");

	    if (loginMember == null) {
			System.out.println("로그인 안된 사용자 요청");
			return "redirect:/todos";
		}

	    int memberId = loginMember.getId();
	    List<Todo> myTodoList = todoService.findNotDone(memberId);

	    model.addAttribute("myTodoList", myTodoList);
	    return "myTodos";  
	}
	
	// 완료된 할 일 목록 조회
	@GetMapping("/completed")
	public String completedTodos (HttpSession session,Model model) {
		Integer groupId = (Integer) session.getAttribute("currentGroupId");
		// 완료된 할 일만 필터링 (전체 그룹기준)
		List<Todo> completedList = todoService.getCompletedTodos();
		
		//담당자 닉네임 매핑
		List<GroupMemberInfoDTO> memberList = groupMemberService.findMemberInfoByGroupId(groupId);
		Map<Integer, String> memberMap = new HashMap<>();

		for (GroupMemberInfoDTO m : memberList) {
		    memberMap.put(m.getMemberId(), m.getNickname());
		}
		
		model.addAttribute("completedList", completedList);
		model.addAttribute("memberMap", memberMap);
		return "todoCompleted";
	}

	// 할 일 신청 취소
	@PostMapping("/unassign")
	public String unassignTodo(@RequestParam("id") int id) {
		Todo todo = todoService.findById(id);
		
		if (!todo.isCompleted()) {
			// 완료되지 않았으면 공용리스트로 복귀
			todoService.unassignTodo(id);
			return "redirect:/todos";
		} else {
			// 완료된 건 유지
			return "redirect:/todos";
		}
	}
	
	// 달력 날짜 클릭 시 해당 날짜의 할 일 목록 조회 (AJAX)
	@GetMapping("/calendar/todo-list")
	@ResponseBody
	public List<TodoSimple> getTodosByDate(
	        @RequestParam("date") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate date,
	        HttpSession session) {

	    Member loginMember = (Member) session.getAttribute("loginMember");

	    if (loginMember == null) {
	        System.out.println("비로그인 사용자 요청 차단");
	        return Collections.emptyList(); // 빈 배열 반환 (JS에서 안전하게 처리됨)
	    }

	    int memberId = loginMember.getId();
	    System.out.println("날짜별 할 일 요청: " + date + " / 사용자 ID: " + memberId);

	    List<TodoSimple> result = todoService.getTodosByDate(date, memberId);

	    System.out.println("응답할 할 일 수: " + result.size());
	    return result;
	}
	
	@GetMapping("/by-date")
	@ResponseBody
	public List<TodoSimple> getTodosByDate(
	        @RequestParam("date") String date, 
	        HttpSession session) {
	    
	    // 1. 세션에서 현재 로그인한 유저 정보 가져오기
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        return Collections.emptyList();
	    }

	    // 2. 문자열 날짜(YYYY-MM-DD)를 LocalDate로 변환
	    LocalDate localDate = LocalDate.parse(date);

	    // 3. Service 호출
	    return todoService.getTodosByDate(localDate, loginMember.getId());
	}
	
	//그룹ID로 멤버 리스트 조회 (AJAX) 
	@GetMapping("/members") 
	@ResponseBody 
	public List<GroupMemberInfoDTO> getMembersByGroup(
					@RequestParam("groupId") int groupId) { 
					return groupMemberService.findMemberInfoByGroupId(groupId); }

}