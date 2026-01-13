<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수정하기</title>
</head>
<body>
<h2>할 일 수정하기</h2>
<form id="todoUpdateForm" action="${pageContext.request.contextPath}/todos/update" method="post">
  
  <!-- 기존 할 일 ID 전달 -->
  <input type="hidden" name="id" value="${todo.id}"/>
  <input type="hidden" name="group_id" value="${todo.group_id}"/>
  
  <div>
    <label for="title">제목 : </label>
    <input type="text" id="title" name="title" value="${todo.title}" required />
  </div>
  
<div>
  <label for="assigned_to">담당자 : </label>
  <select id="assigned_to" name="assigned_to">
    <option value="">-- 담당자 미정 (공용) --</option> <c:forEach var="member" items="${memberList}">
      <option value="${member.memberId}" <c:if test="${member.memberId == todo.assigned_to}">selected</c:if>>
        ${member.nickname}
      </option>
    </c:forEach>
  </select>
</div>
  
   <div>
    <label for="due_date">마감일 : </label>
    <input type="date" id="due_date" name="due_date"
           value="${todo.due_date != null ? fn:substring(todo.due_date, 0, 10) : ''}" />
  </div>
  
  <div>
    <label for="difficulty_point">난이도 : </label>
    <select id="difficulty_point" name="difficulty_point">
      <c:forEach var="i" begin="1" end="5">
        <option value="${i}" <c:if test="${todo.difficulty_point == i}">selected</c:if>>${i}</option>
      </c:forEach>
    </select>
  </div>
	
	<div>
		완료 여부 : 
		<select id="completed" name="completed">
		  <option value="true" <c:if test="${todo.completed}">selected</c:if>>완료</option>
		  <option value="false" <c:if test="${!todo.completed}">selected</c:if>>미완료</option>
		</select>
	</div>
  <div id="assignee-guide" style="color: #ff4d4f; font-size: 12px; display: none; margin-top: 5px;">
  	완료 상태로 변경하려면 담당자 지정이 필수예요!
	</div>

  <button type="submit">수정완료</button>
</form>
</body>

<script>
// 요소 가져오기
const updateForm = document.getElementById('todoUpdateForm');
const statusSelect = document.getElementById('completed');
const assigneeSelect = document.getElementById('assigned_to');
const guide = document.getElementById('assignee-guide');

// 검증 함수 정의
function checkValidation() {
    // 상태가 '완료(true)'인데 담당자 값(assigned_to)이 비어있을 때
    if (statusSelect.value === 'true' && !assigneeSelect.value) {
        guide.style.display = 'block'; 
        assigneeSelect.style.border = '2px solid #ff4d4f'; 
        return false; // 유효하지 않음
    } else {
        guide.style.display = 'none';
        assigneeSelect.style.border = '';
        return true; // 유효함
    }
}

// 1. 실시간 체크: 값이 바뀔 때마다 안내 문구 조절
statusSelect.addEventListener('change', checkValidation);
assigneeSelect.addEventListener('change', checkValidation);

// 2. 폼 제출 시 전송 막기
updateForm.onsubmit = function(e) {
    // 버튼 누르는 순간 다시 한번 체크
    if (!checkValidation()) {
        e.preventDefault();
        alert("담당자를 지정해야 '완료'로 수정할 수 있어요!");
        assigneeSelect.focus(); // 담당자 칸으로 자동 이동
        return false;
    }
};

// 3. 페이지 로드 시 초기 상태 체크
window.onload = checkValidation;
</script>

</html>