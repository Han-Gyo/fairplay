package com.fairplay.service;

import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.fairplay.domain.History;
import com.fairplay.domain.Todo;
import com.fairplay.domain.TodoSimple;
import com.fairplay.repository.HistoryRepository;
import com.fairplay.repository.TodoRepository;

@Service
public class TodoServiceImpl implements TodoService{

	@Autowired
	private TodoRepository todoRepository;
	
	@Autowired
	private HistoryRepository historyRepository;

	// 전체 할 일 목록 조회
	@Override
	public List<Todo> getTodoList() {
		System.out.println("할 일 전체 목록 조회");
		return todoRepository.findAll();
	}
	// 할 일 추가
	@Override
	public void addTodo(Todo todo) {
			
		// 상태값 자동 설정
    if (todo.isCompleted()) {
        todo.setStatus("완료");
    } else if (todo.getAssigned_to() != null && todo.getAssigned_to() > 0) {
        todo.setStatus("신청완료");
    } else {
        todo.setStatus("미신청");
    }
    
    todoRepository.insert(todo);
    
    if (todo.isCompleted()) {

      History history = new History();
      history.setTodo_id(todo.getId());
      history.setMember_id(todo.getAssigned_to());
      history.setCompleted_at(new java.util.Date());
      history.setScore(todo.getDifficulty_point());
      history.setMemo(todo.getTitle());

      System.out.println("히스토리로 넘어가는 점수 : " + todo.getDifficulty_point());
      
      historyRepository.save(history);
      System.out.println("할 일 등록과 동시에 히스토리 자동 생성!");
  }

    // 로그 찍기
    System.out.println("등록된 할 일 제목: " + todo.getTitle());
    System.out.println("담당자 ID: " + todo.getAssigned_to());
    System.out.println("할 일 상태: " + todo.getStatus());
	}

	// 할 일 수정
	@Override
	public void updateTodo(Todo todo) {
		Todo oldTodo = todoRepository.findById(todo.getId());
		
		if (todo.isCompleted() && (todo.getAssigned_to() == null || todo.getAssigned_to() == 0)) {
	        System.out.println("담당자 미지정으로 인한 강제 완료 취소 로직 실행");
	        todo.setCompleted(false); // 미완료로 돌려버림
	        todo.setStatus("미신청");
	    } else if (todo.isCompleted()) {
	        todo.setStatus("완료");
	    } else if (todo.getAssigned_to() != null && todo.getAssigned_to() > 0) {
	        todo.setStatus("신청완료");
	    } else {
	        todo.setStatus("미신청");
	    }
		
		if (!oldTodo.isCompleted() && todo.isCompleted()) {
	        History history = new History();
	        history.setTodo_id(todo.getId());
	        history.setMember_id(todo.getAssigned_to());
	        history.setCompleted_at(new java.util.Date());
	        history.setScore(todo.getDifficulty_point());
	        history.setMemo(todo.getTitle());
	        
	        System.out.println("히스토리로 넘어가는 점수 : " + todo.getDifficulty_point());
	        historyRepository.save(history); 
	        System.out.println("히스토리 자동 등록!");
	    }
		todoRepository.update(todo);
		System.out.println("할 일 수정됨: " + todo);
	}
	// 할 일 삭제
	@Override
	public void deleteTodo(int id) {
		todoRepository.deleteById(id);
		System.out.println("삭제된 ID: " + id);
	}
	// 할 일 완료 처리
	@Override
	public void completeTodo(int id) {
		todoRepository.complete(id);
		System.out.println("완료 처리된 ID: " + id);
	}
	// 특정 ID로 할 일 하나 조회
	@Override
	public Todo findById(int id) {
		return todoRepository.findById(id);
	}
	
	@Override
	public boolean assignTodo(int todoId, int memberId) {
	    Todo todo = todoRepository.findById(todoId);

	    // 1. 이미 누가 신청했는지 확인
	    if (todo.getAssigned_to() != null) {
	        if (todo.getAssigned_to() == memberId) {
	            // 내가 이미 신청했는데 status만 '미신청'이면 → 갱신 필요
	            if ("미신청".equals(todo.getStatus())) {
	                System.out.println("이미 신청했지만 상태는 미신청 → 상태만 갱신");
	                todoRepository.updateAssignedStatus(todoId, memberId);
	            }
	            return true;  // 내가 이미 맡은 할 일이라면 OK
	        } else {
	            return false; // 다른 사람이 신청했음
	        }
	    }
	    
	    // 2. 신청 처리
	    todoRepository.updateAssignedStatus(todoId, memberId);
	    return true;
	}
	
	@Override
	public List<Todo> getTodosByMemberId(int memberId) {
	    return todoRepository.findByAssignedMember(memberId);
	}
	
	@Override
	public List<Todo> getCompletedTodos() {
		System.out.println("완료된 할 일 목록 조회 실행됨");
		return todoRepository.findCompletedTodos();
	}
	
	@Override
	public void unassignTodo(int todoId) {
		todoRepository.resetAssignedStatus(todoId);
		System.out.println("담당자 해제됨 → 다시 공용 할 일로 이동됨 (todo_id: " + todoId + ")");
	}
	@Override
	public List<Todo> findNotDone(int memberId) {
		return todoRepository.findNotDone(memberId);
	}
	@Override
	public List<TodoSimple> getTodosByDate(LocalDate date, int memberId) {
		return todoRepository.findTodosByDateAndMember(date, memberId);
	}
	@Override
	public List<Todo> findByGroupId(int groupId) {
	    // 그룹 ID로 할 일 목록 조회
	    System.out.println("그룹 ID(" + groupId + ")로 할 일 목록 조회");
	    return todoRepository.findByGroupId(groupId);
	}
	@Override
	public List<Todo> findByGroupIdAndAssignedTo(int groupId, int memberId) {
		return todoRepository.findByGroupIdAndAssignedTo(groupId, memberId);
	}
	@Override
	public List<Todo> findCompletedWithoutHistory(int groupId, int memberId) {
	    return todoRepository.findCompletedWithoutHistory(groupId, memberId);
	}
}