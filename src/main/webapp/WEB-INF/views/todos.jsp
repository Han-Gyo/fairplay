<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>To Do List</title>
</head>
<body>
	<h1>🧹오늘의 할 일 리스트</h1>
	
	<!-- ✅ 할 일 등록 폼 -->
	<form action="${pageContext.request.contextPath}/todos/add" method="post">
		<input type="text" name="title" placeholder="할 일을 입력하세요" required />
		<input type="hidden" name="group_id" value="1" />
		<button type="submit">등록</button>
	</form>

	<br>
	
	<!-- ✅ 할 일 리스트 출력 -->
	<c:forEach var="todo" items="${todoList}" varStatus="loop">
		<div style="margin-bottom: 10px;">
			<span>
				${loop.index + 1}. 							<!-- 화면용 순번 (1번부터 증가) -->
				${todo.title} 								<!-- 제목 -->
				<c:if test="${todo.completed}">✔</c:if> 	<!-- 완료 여부 체크 -->
				<c:if test="${!todo.completed}">⏳</c:if>
			</span>

			<!-- 완료 버튼 -->
			<form action="${pageContext.request.contextPath}/todos/complete" method="post" style="display: inline;">
				<input type="hidden" name="id" value="${todo.id}" />
				<button type="submit">완료</button>
			</form>

			<!-- 삭제 버튼 -->
			<form action="${pageContext.request.contextPath}/todos/delete" method="post" style="display: inline;">
				<input type="hidden" name="id" value="${todo.id}" />
				<button type="submit">삭제</button>
			</form>
		</div>
	</c:forEach>
</body>
</html>