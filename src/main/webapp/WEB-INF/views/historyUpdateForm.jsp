<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>기록 수정</title>
</head>
<body>

<h2>✏️ 집안일 기록 수정</h2>

<form action="${pageContext.request.contextPath}/history/update" method="post">

    <!-- 수정 시 꼭 ID 넘겨줘야 함 (hidden으로) -->
    <input type="hidden" name="id" value="${history.id}" />

    <!-- 할 일 ID -->
    <label>할 일 ID:</label>
    <input type="number" name="todo_id" value="${history.todo_id}" required /><br><br>

    <!-- 수행자 ID -->
    <label>수행자 ID:</label>
    <input type="number" name="member_id" value="${history.member_id}" required /><br><br>

    <!-- 날짜 -->
    <label>완료 날짜:</label>
    <input type="date" name="completed_at" value="${history.completed_at}" required /><br><br>

    <!-- 점수 -->
    <label>노력 점수 (1~5):</label>
    <select name="score">
        <c:forEach begin="1" end="5" var="i">
            <option value="${i}" <c:if test="${history.score == i}">selected</c:if>>${i}</option>
        </c:forEach>
    </select><br><br>

    <!-- 메모 -->
    <label>메모:</label><br>
    <textarea name="memo" rows="4" cols="40">${history.memo}</textarea><br><br>

    <!-- 제출 -->
    <button type="submit">수정 완료</button>
</form>

</body>
</html>
