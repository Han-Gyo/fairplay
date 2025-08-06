<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>To Do List</title>
</head>
<body>
<h2>➕ 새로운 할 일 추가</h2>

<form action="${pageContext.request.contextPath}/todos/create" method="post">
  <input type="hidden" name="group_id" value="1" />
  <div>
    <label for="title">제목:</label>
    <input type="text" id="title" name="title" required />
  </div><br>

담당자 : 
<select name="assigned_to"> <%-- 담당자 선택 드롭다운 --%>
	<option value="">-- 담당자 선택 안 함 --</option>
  <c:forEach var="member" items="${memberList}"> <%-- 서버에서 전달된 memberList를 반복 --%>
    <option value="${member.id}">${member.nickname}</option> <%-- 각 멤버의 id(선택값)와 닉네임(보이는값) 출력 --%>
  </c:forEach>
</select>
<br>
<br>
  <div>
    <label for="due_date">마감일 : </label>
    <input type="date" id="due_date" name="due_date" />
  </div><br>

  <div>
    <label for="difficulty_point">난이도 : </label>
    <select id="difficulty_point" name="difficulty_point">
      <%-- 난이도 숫자 선택 (1~5) --%>
      <option value="1">1</option>
      <option value="2">2</option>
      <option value="3">3</option>
      <option value="4">4</option>
      <option value="5">5</option>
    </select>
  </div><br>

  <div>
		완료 여부 : 
		<select id="completed" name="completed">
		  <option value="true" <c:if test="${todo.completed}">selected</c:if>>완료</option>
		  <option value="false" <c:if test="${!todo.completed}">selected</c:if>>미완료</option>
		</select>
  </div><br>

  <button type="submit">할 일 등록</button>
</form>
</body>
</html>