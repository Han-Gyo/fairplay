package com.fairplay.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
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
	
	// ✅ 1. 전체 할 일 목록 조회
	@GetMapping
	public String listTodos(Model model) {
		List<Todo> todoList = todoService.getTodoList();
		
		// ✅ 전체 멤버 조회
		List<Member> memberList = memberService.readAll();
		
		// ✅ ID → 닉네임 맵핑
		Map<Integer, String> memberMap = new HashMap<>();
		for (Member m : memberList) {
			memberMap.put(m.getId(), m.getNickname());
		}
		model.addAttribute("todoList", todoList);
		model.addAttribute("memberMap", memberMap);
		System.out.println("🧪 todoList: " + todoList);
		System.out.println("memberMap : " + memberMap);
		return "todos";
	}
	
	// ✅ 2. 할 일 추가
	@GetMapping("/create")
	public String addTodo(Model model) {
		List<Member> memberList = memberService.readAll();
		model.addAttribute("memberList", memberList);
		return "todoCreateForm";
	}
	@PostMapping("/create")
	public String addTodo(
	    @RequestParam("title") String title,
	    @RequestParam("group_id") int group_id,
	    @RequestParam("assigned_to") int assigned_to,
	    @RequestParam("due_date") @DateTimeFormat(pattern = "yyyy-MM-dd") Date due_date,
	    @RequestParam("difficulty_point") int difficulty_point
	) {
	    Todo todo = new Todo();
	    todo.setTitle(title);
	    todo.setGroup_id(group_id);
	    todo.setAssigned_to(assigned_to);
	    todo.setDue_date(due_date); // ✅ 이제 에러 안 남
	    todo.setDifficulty_point(difficulty_point);
	    
	    System.out.println("🧾 받은 title: " + title);
	    System.out.println("📌 받은 group_id: " + group_id);
	    System.out.println("👤 받은 assigned_to: " + assigned_to);
	    
	    todoService.addTodo(todo);
	    return "redirect:/todos";
	}
	
	
	
	// ✅ 3. 할 일 수정 폼 페이지 이동
	@GetMapping("/update")
	public String updateTodo(@RequestParam("id") int id, Model model) {
		Todo todo = todoService.findById(id);
		model.addAttribute("todo", todo);
		return "todoUpdateForm";
	}
	// ✅ 4. 수정 폼에서 수정 제출
	@PostMapping("/update")
	public String updateTodo(@ModelAttribute Todo todo) {
		todoService.updateTodo(todo);
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