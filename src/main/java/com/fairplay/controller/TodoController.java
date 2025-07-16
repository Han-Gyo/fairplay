package com.fairplay.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
	    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	    dateFormat.setLenient(false);
	    binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
	}
	
	// ✅ 1. 전체 할 일 목록 조회
	@GetMapping
	public String listTodos(Model model) {
		// ✅ 전체 할 일 목록조회
		List<Todo> todoList = todoService.getTodoList();
		// ✅ 전체 멤버 목록조회
		List<Member> memberList = memberService.readAll();
		
		// ✅ ID → 닉네임 맵핑 (각 멤버 ID → 닉네임으로 변환해서 Map에 저장)
		Map<Integer, String> memberMap = new HashMap<>();
		for (Member m : memberList) {
			memberMap.put(m.getId(), m.getNickname());
		}
		// 뷰로 전달할 데이터 등록
		model.addAttribute("todoList", todoList);
		model.addAttribute("memberMap", memberMap);
		
		System.out.println("🧪 todoList: " + todoList);
		System.out.println("memberMap : " + memberMap);
		return "todos";
	}
	
	// ✅ 2. 할 일 추가
	@GetMapping("/create")
	public String addTodo(Model model) {
		List<Member> memberList = memberService.readAll(); // 담당자 선택을 위한 멤버 목록
		model.addAttribute("memberList", memberList); // 모델에 넣기
		return "todoCreateForm";  
	}
	// ✅ 2. 할 일 실제 등록 처리
	@PostMapping("/create")
	public String addTodo(
	    @RequestParam("title") String title,
	    @RequestParam("group_id") int group_id,
	    @RequestParam("assigned_to") int assigned_to,
	    @RequestParam("due_date") @DateTimeFormat(pattern = "yyyy-MM-dd") Date due_date,
	    @RequestParam("difficulty_point") int difficulty_point,
	    @RequestParam("completed") boolean completed
	) {
		// 받은 데이터로 Todo 객체 만들기
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
	
	
	
	// ✅ 3. 할 일 수정 폼 페이지 이동
	@GetMapping("/update")
	public String updateTodo(@RequestParam("id") int id, Model model) {
		Todo todo = todoService.findById(id);	// 수정할 할 일 조회
		List<Member> memberList = memberService.readAll();
		model.addAttribute("todo", todo);		// 모델에 담아서 뷰로 보냄
		model.addAttribute("memberList", memberList); 
		return "todoUpdateForm";
	}
	// ✅ 4. 수정 폼에서 수정 제출
	@PostMapping("/update")
	public String updateTodo(@ModelAttribute Todo todo) {
		todoService.updateTodo(todo);	// 수정된 내용 저장
		return "redirect:/todos";
	}
	
	// ✅ 5. 할 일 삭제
	@PostMapping("/delete")
	public String deleteTodo(@RequestParam("id") int id) {
		System.out.println("🗑️ 삭제 요청 ID: " + id);
		todoService.deleteTodo(id);
		return "redirect:/todos";
	}

	// ✅ 6. 할 일 완료 처리
	@PostMapping("/complete")
	public String completeTodo(@RequestParam("id") int id) {
		System.out.println("✅ 완료 요청 ID: " + id);
		todoService.completeTodo(id);
		return "redirect:/todos";
	}
	
}