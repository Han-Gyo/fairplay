<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>기록 등록</title>
</head>
<body>

<h2>✅ 집안일 수행 기록 등록</h2>
<!-- enctype 추가! 파일 업로드 시 필수 -->
<form action="${pageContext.request.contextPath}/history/create" method="post" enctype="multipart/form-data">

		<!-- ✅ 할 일 선택 -->
		<label>할 일 : </label>
		<select name="todo_id" required>
		    <c:forEach var="todo" items="${todoList}">
		        <option value="${todo.id}" 
		                <c:if test="${todo.id == selectedTodoId}">selected</c:if>>
		            ${todo.title}
		        </option>
		    </c:forEach>
		</select>
		<br><br>
		
		<!-- ✅ 수행자 선택 -->
		<label>수행자 : </label>
		<select name="member_id" required>
		    <c:forEach var="member" items="${memberList}">
		        <option value="${member.id}">${member.nickname}</option>
		    </c:forEach>
		</select>
		<br><br>

    <!-- 완료 날짜 -->
    <label>완료 날짜 : </label>
    <input type="date" name="completed_at" required /><br><br>

    <!-- 점수 -->
    <label>점수 (1~5) : </label>
    <select name="score">
        <c:forEach begin="1" end="5" var="i">
            <option value="${i}">${i}</option>
        </c:forEach>
    </select><br><br>

    <!-- 메모 -->
    <label>메모 : </label><br>
    <textarea name="memo" rows="4" cols="40"></textarea><br><br>

		<!-- 인증샷 업로드 -->
		<label>인증샷</label><br>
		<input type="file" name="photo" accept="image/*" /><br><br>
		
    <!-- 제출 -->
    <button type="submit">기록 등록</button>
</form>

</body>
</html>
