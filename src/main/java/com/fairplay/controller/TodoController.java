package com.fairplay.controller;

import java.text.SimpleDateFormat;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fairplay.domain.Member;
import com.fairplay.domain.Todo;
import com.fairplay.service.MemberService;
import com.fairplay.service.TodoService;

@Controller
@RequestMapping("/todos")
public class TodoController {
	
	@Autowired
	private TodoService todoService;
	@Autowired
	private MemberService memberService;
	
	// ✅ 날짜 바인딩 설정 (yyyy-MM-dd 형식 사용)
	@InitBinder
	public void initBinder(WebDataBinder binder) {
	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	    dateFormat.setLenient(false);
	    binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
	}
	
	// ✅ 전체 할 일 목록 조회
	@GetMapping
	public String listTodos(HttpSession session,Model model) {
		// ✅ 전체 할 일 목록조회
	    List<Todo> todoList = todoService.getTodoList();
	    
	    System.out.println("🧾 전체 할일 리스트 상태 확인");
	    for (Todo t : todoList) {
	        System.out.println(" - " + t.getTitle() + " / 상태: " + t.getStatus() + " / 담당자: " + t.getAssigned_to());
	    }
	    
	    // ✅ 전체 멤버 목록조회
	    List<Member> memberList = memberService.readAll();
	    
	    // ✅ ID → 닉네임 맵핑
	    Map<Integer, String> memberMap = new HashMap<>();
	    for (Member m : memberList) {
	        memberMap.put(m.getId(), m.getNickname());
	    }

	    // ✅ 로그인 사용자 ID 넘기기
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember != null) {
	        System.out.println("👤 로그인 사용자 ID: " + loginMember.getId());
	    }

	    System.out.println("🧾 할 일 목록 확인:");
	    for (Todo t : todoList) {
	        System.out.println(" - " + t.getTitle() + " / assigned_to: " + t.getAssigned_to());
	    }

	    // 모델 전달
	    if (loginMember != null) {
	        model.addAttribute("loginMemberId", loginMember.getId());
	    }
	    model.addAttribute("todoList", todoList);
	    model.addAttribute("memberMap", memberMap);

	    return "todos";
	}
	
	// ✅ 할 일 등록 폼 페이지
	@GetMapping("/create")
	public String addTodo(Model model) {
		List<Member> memberList = memberService.readAll(); // 담당자 선택을 위한 멤버 목록
		model.addAttribute("memberList", memberList); // 모델에 넣기
		return "todoCreateForm";  
	}
	
	// ✅ 할 일 실제 등록 처리
	@PostMapping("/create")
	public String addTodo(
	    @RequestParam("title") String title,
	    @RequestParam("group_id") int group_id,
	    @RequestParam(value = "assigned_to", required = false) Integer assigned_to,
	    @RequestParam("due_date") @DateTimeFormat(pattern = "yyyy-MM-dd") Date due_date,
	    @RequestParam("difficulty_point") int difficulty_point,
	    @RequestParam("completed") boolean completed
	) {
	    Todo todo = new Todo();
	    todo.setTitle(title);
	    todo.setGroup_id(group_id);
	    todo.setAssigned_to(assigned_to); 
	    todo.setDue_date(due_date);
	    todo.setDifficulty_point(difficulty_point);
	    todo.setCompleted(completed);

	    System.out.println("🧾 받은 title: " + title);
	    System.out.println("📌 받은 group_id: " + group_id);
	    System.out.println("👤 받은 assigned_to: " + assigned_to);
	    System.out.println("🧾 completed 값: " + completed);

	    todoService.addTodo(todo);
	    return "redirect:/todos";
	}
	
	// ✅ 할 일 수정 폼 페이지 이동
	@GetMapping("/update")
	public String updateTodo(@RequestParam("id") int id, Model model) {
		Todo todo = todoService.findById(id);	// 수정할 할 일 조회
		List<Member> memberList = memberService.readAll();
		model.addAttribute("todo", todo);		// 모델에 담아서 뷰로 보냄
		model.addAttribute("memberList", memberList); 
		return "todoUpdateForm";
	}
	
	// ✅ 수정 폼에서 수정 제출
	@PostMapping("/update")
	public String updateTodo(@ModelAttribute Todo todo) {
		todoService.updateTodo(todo);	// 수정된 내용 저장
		return "redirect:/todos/myTodos";
	}
	
	// ✅ 할 일 삭제
	@PostMapping("/delete")
	public String deleteTodo(@RequestParam("id") int id) {
		System.out.println("🗑️ 삭제 요청 ID: " + id);
		todoService.deleteTodo(id);
		return "redirect:/todos/myTodos";
	}

	// ✅ 할 일 완료 처리
	@PostMapping("/complete")
	public String completeTodo(@RequestParam("id") int id) {
		System.out.println("✅ 완료 요청 ID: " + id);
		todoService.completeTodo(id);
		return "redirect:/todos";
	}
	
	// ✅ 선착순 신청 처리
	@PostMapping("/assign")
	public String assignTodo(@RequestParam("todo_id")int todo_id, HttpSession session, RedirectAttributes redirectAttributes, Model model) {
		System.out.println("🔔 신청 요청 - todo_id: " + todo_id);	
		
		// 세션에서 로그인 정보 가져오기
		Member loginMember = (Member) session.getAttribute("loginMember");
		System.out.println("📦 세션에서 loginMember: " + loginMember);
		
		if (loginMember == null) {
			System.out.println("❌ 로그인 안된 사용자 요청");
			redirectAttributes.addFlashAttribute("msg", "로그인 후 이용해주세요!");
			return "redirect:/todos";
		}
		
		int memberId = loginMember.getId();
		System.out.println("👤 로그인 사용자 ID: " + memberId);
		
		model.addAttribute("loginMemberId", loginMember.getId());
		model.addAttribute("todoList", todoService.getTodoList());
		
	    // 신청 처리
	    boolean success = todoService.assignTodo(todo_id, memberId);

	    if (!success) {
	    	System.out.println("🚫 신청 실패 - 이미 신청됨");
	        redirectAttributes.addFlashAttribute("msg", "이미 누군가 신청했어요!");
	    } else {
	    	System.out.println("✅ 신청 성공!");
	        redirectAttributes.addFlashAttribute("msg", "신청 성공!");
	    }

	    return "redirect:/todos";
	}
	
	// ✅ 내 할 일 목록 조회
	@GetMapping("/myTodos")
	public String myTodos(HttpSession session, Model model) {
	    Member loginMember = (Member) session.getAttribute("loginMember");

	    if (loginMember == null) {
			System.out.println("❌ 로그인 안된 사용자 요청");
			return "redirect:/todos";
		}

	    int memberId = loginMember.getId();
	    List<Todo> myTodoList = todoService.findNotDone(memberId);

	    model.addAttribute("myTodoList", myTodoList);
	    return "myTodos";  
	}
	
	// ✅ 완료된 할 일 목록 조회
	@GetMapping("/completed")
	public String completedTodos (Model model) {
		// 완료된 할 일만 필터링 (전체 그룹기준)
		List<Todo> completedList = todoService.getCompletedTodos();
		
		//담당자 닉네임 매핑
		List<Member> memberList = memberService.readAll();
		Map<Integer, String> memberMap = new HashMap<>();
		for (Member m : memberList) {
			memberMap.put(m.getId(), m.getNickname());
		}
		
		model.addAttribute("completedList", completedList);
		model.addAttribute("memberMap", memberMap);
		return "todoCompleted";
	}

	// ✅ 할 일 신청 취소
	@PostMapping("/unassign")
	public String unassignTodo(@RequestParam("id") int id) {
		Todo todo = todoService.findById(id);
		
		if (!todo.isCompleted()) {
			// 완료되지 않았으면 공용리스트로 복귀
			todoService.unassignTodo(id);
			return "redirect:/todos/myTodos";
		} else {
			// 완료된 건 유지 (삭제x)
			return "redirect:/todos/myTodos";
		}
	}

}