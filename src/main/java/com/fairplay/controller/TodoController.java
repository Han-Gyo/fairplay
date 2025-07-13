package com.fairplay.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fairplay.domain.Todo;
import com.fairplay.service.TodoService;

@Controller
@RequestMapping("/todos")
public class TodoController {
	
	@Autowired
	private TodoService todoService;
	
	// ✅ 1. 전체 할 일 목록 조회
	@GetMapping
	public String listTodos(Model model) {
		List<Todo> todoList = todoService.getTodoList();
		System.out.println("📝 todoList 조회됨: " + todoList); 
		model.addAttribute("todoList", todoList);
		return "todos";
	}
	
	// ✅ 2. 할 일 추가
	@GetMapping("/add")
	public String showAddForm() {
	    return "redirect:/todos";
	}
	@PostMapping("/add")
	public String addTodo(@RequestParam("title") String title, @RequestParam("group_id") int group_id) {
		System.out.println("➕ 할 일 추가 요청: " + title);
	    System.out.println("🔥 title: " + title);
	    System.out.println("🔥 group_id: " + group_id);
		todoService.addTodo(title, group_id);
		return "redirect:/todos";
	}
	

	// ✅ 3. 할 일 삭제
	@PostMapping("/delete")
	public String deleteTodo(@RequestParam("id") int id) {
		System.out.println("🗑️ 삭제 요청 ID: " + id);
		todoService.deleteTodo(id);
		return "redirect:/todos";
	}

	// ✅ 4. 할 일 완료 처리
	@PostMapping("/complete")
	public String completeTodo(@RequestParam("id") int id) {
		System.out.println("✅ 완료 요청 ID: " + id);
		todoService.completeTodo(id);
		return "redirect:/todos";
	}

}