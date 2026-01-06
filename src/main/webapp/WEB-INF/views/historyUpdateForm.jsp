<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>기록 수정</title>
</head>
<body>

<h2>✏️ 집안일 기록 수정</h2>

<form action="${pageContext.request.contextPath}/history/update" method="post" enctype="multipart/form-data">

    <!-- 히스토리 기본 정보 -->
    <input type="hidden" name="id" value="${history.id}" />
    <input type="hidden" name="todo_id" value="${history.todo.id}">
    <input type="hidden" name="member_id" value="${history.member.id}">

    <!-- 할 일 (수정 불가) -->
    <label>할 일 : </label>
    <select name="todo_id" required> 
	    	<option>${history.todo.title}</option> 
    </select>
    <br><br>

    <!-- 수행자 (수정 불가) -->
    <label>수행자 : </label>
    <select name="member_id" required>
    	<option>${history.member.nickname}</option>
    </select>
    <br><br>

    <!-- 날짜 -->
    <fmt:formatDate value="${history.completed_at}" pattern="yyyy-MM-dd" var="completedDate" />
    <label>완료 날짜 : </label> 
    <input type="date" name="completed_at" value="${completedDate}" required />
    <br><br>

    <!-- 점수 -->
    <label>점수 (1~5) :</label>
    <select name="score">
        <c:forEach begin="1" end="5" var="i">
            <option value="${i}" <c:if test="${history.score == i}">selected</c:if>>${i}</option>
        </c:forEach>
    </select>
    <br><br>

    <!-- 메모 -->
    <label>메모 :</label><br>
    <textarea name="memo" rows="4" cols="40">${history.memo}</textarea>
    <br><br>

    <!-- 인증샷 업로드 -->
    <label>인증샷</label><br>
    <input type="file" name="photo" accept="image/*" />
    <br><br>

    <button type="submit">수정 완료</button>
</form>

</body>
</html>
