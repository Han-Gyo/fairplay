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
<form action="${pageContext.request.contextPath}/todos/update" method="post">
  
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
      <option value="${member.id}" <c:if test="${member.id == todo.assigned_to}">selected</c:if>>
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
  

  <button type="submit">수정완료</button>
</form>
</body>
</html>