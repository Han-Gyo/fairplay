package com.fairplay.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
import org.springframework.web.multipart.MultipartFile;

import com.fairplay.domain.History;
import com.fairplay.domain.Todo;
import com.fairplay.service.HistoryService;
import com.fairplay.service.TodoService;

@Controller
@RequestMapping("/history")
public class HistoryController {
	
	@Autowired
	private HistoryService historyService;
	
	@Autowired
	private TodoService todoService;
	
	// ✅ 전체 히스토리 보기
	@GetMapping("/all")
	public String listAllHistories(Model model) {
	    List<History> allHistories = historyService.getAllHistories();
	    System.out.println("▶ 전체 히스토리 개수: " + allHistories.size());
	    model.addAttribute("historyList", allHistories);
	    return "histories";
	}
	
	// ✅ 1. 기록 목록 (히스토리 리스트)
    @GetMapping
    public String listHistories (@RequestParam("todo_id") int todo_id, Model model) {
    	List<History> historyList = historyService.getHistoriesByTodoId(todo_id);
    	model.addAttribute("historyList", historyList);
    	
    	// 할일 title 전달
    	Todo todo = todoService.findById(todo_id);
    	model.addAttribute("todo", todo);
    	
    	return "histories";
    }
    
    // ✅ 2. 기록 등록 폼
    @GetMapping("/create")
    public String addHistory(Model model) {
        model.addAttribute("history", new History());
        return "historyCreateForm"; 
    }
    
    // ✅ 3. 기록 등록 처리
    @PostMapping("/create")
    public String addHistory(
            HttpServletRequest request,  // ★ 추가: 저장 경로 구하기 위함
            @RequestParam("todo_id") int todoId,
            @RequestParam("member_id") int memberId,
            @RequestParam("completed_at") @DateTimeFormat(pattern = "yyyy-MM-dd") Date completedAt,
            @RequestParam("score") int score,
            @RequestParam("memo") String memo,
            @RequestParam(value = "photo", required = false) MultipartFile photo
    ) {
        System.out.println("📥 등록 요청 들어옴");

        History history = new History();
        history.setTodo_id(todoId);
        history.setMember_id(memberId);
        history.setCompleted_at(completedAt);
        history.setScore(score);
        history.setMemo(memo);

        if (photo != null && !photo.isEmpty()) {
            String fileName = photo.getOriginalFilename();
            System.out.println("✔ 업로드된 파일명: " + fileName);

            // ✅ 1. 실제 저장 경로
            String uploadDir = request.getServletContext().getRealPath("/upload/");
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

        return "redirect:/history?todo_id=" + todoId;
    }

    
    // ✅ 4. 기록 수정 폼
    @GetMapping("/update")
    public String updateHistory (@RequestParam("id") int id, Model model) {
    	History history = historyService.getHistoryById(id);
    	model.addAttribute("history", history);
    	return "historyUpdateForm";
    }
    
    // ✅ 5. 수정 처리
    @PostMapping("/update")
    public String updateHistory (@ModelAttribute History history) {
    	historyService.updateHistory(history);
    	return "redirect:/history?todo_id=" + history.getTodo_id();
    }
    
    // ✅ 6. 삭제
    @PostMapping("/delete")
    public String deleteHistory(@RequestParam("id") int id, @RequestParam("todo_id") int todo_id) {
        historyService.deleteHistory(id);
        return "redirect:/history?todo_id=" + todo_id;
    }
    
    // ✅ 히스토리 상세 보기
    @GetMapping("/detail")
    public String detailHistory(@RequestParam("id") int id, Model model) {
        History history = historyService.getHistoryById(id);
        model.addAttribute("history", history);
        return "historyDetail";
    }
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        binder.registerCustomEditor(java.util.Date.class, new CustomDateEditor(dateFormat, false));
    }
}
