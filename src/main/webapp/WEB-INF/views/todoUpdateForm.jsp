<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>수정하기</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/todoUpdate.css">
</head>
<body class="todo-update-body">

  <div class="todo-form-container">
    <h2 class="todo-form-title">✏️ 할 일 수정하기</h2>

    <form id="todoUpdateForm" class="todo-form" action="${pageContext.request.contextPath}/todos/update" method="post">
      
      <input type="hidden" name="id" value="${todo.id}"/>
      <input type="hidden" name="group_id" value="${todo.group_id}"/>
      
      <div class="form-group">
        <label for="title">제목</label>
        <input type="text" id="title" name="title" value="${todo.title}" required />
      </div>
      
      <div class="form-group">
        <label for="assigned_to">담당자</label>
        <select id="assigned_to" name="assigned_to">
          <option value="">-- 담당자 미정 (공용) --</option> 
          <c:forEach var="member" items="${memberList}">
            <option value="${member.memberId}" <c:if test="${member.memberId == todo.assigned_to}">selected</c:if>>
              ${member.nickname}
            </option>
          </c:forEach>
        </select>
        <div id="assignee-guide" style="display: none;">
          완료 상태로 변경하려면 담당자 지정이 필수예요!
        </div>
      </div>
      
      <div class="form-row">
        <div class="form-group">
          <label for="due_date">마감일</label>
          <input type="date" id="due_date" name="due_date"
                 value="${todo.due_date != null ? fn:substring(todo.due_date, 0, 10) : ''}" />
        </div>
        
        <div class="form-group">
          <label for="difficulty_point">난이도 (1~5)</label>
          <select id="difficulty_point" name="difficulty_point">
            <c:forEach var="i" begin="1" end="5">
              <option value="${i}" <c:if test="${todo.difficulty_point == i}">selected</c:if>>${i}</option>
            </c:forEach>
          </select>
        </div>
      </div>
      
      <div class="form-group">
        <label for="completed">완료 여부</label>
        <select id="completed" name="completed">
          <option value="true" <c:if test="${todo.completed}">selected</c:if>>완료</option>
          <option value="false" <c:if test="${!todo.completed}">selected</c:if>>미완료</option>
        </select>
      </div>

      <div class="form-btns">
        <button type="submit" class="btn-submit">수정완료</button>
        <a href="${pageContext.request.contextPath}/todos" class="btn-cancel">취소</a>
      </div>
    </form>
  </div>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script>
    const updateForm = document.getElementById('todoUpdateForm');
    const statusSelect = document.getElementById('completed');
    const assigneeSelect = document.getElementById('assigned_to');
    const guide = document.getElementById('assignee-guide');

    function checkValidation() {
      if (statusSelect.value === 'true' && !assigneeSelect.value) {
        guide.style.display = 'block'; 
        assigneeSelect.style.border = '2px solid #ff4d4f'; 
        return false;
      } else {
        guide.style.display = 'none';
        assigneeSelect.style.border = '';
        return true;
      }
    }

    statusSelect.addEventListener('change', checkValidation);
    assigneeSelect.addEventListener('change', checkValidation);

    updateForm.onsubmit = function(e) {
      if (!checkValidation()) {
        e.preventDefault();
        alert("담당자를 지정해야 '완료'로 수정할 수 있어요!");
        assigneeSelect.focus();
        return false;
      }
    };

    window.onload = checkValidation;
  </script>
</body>
</html>