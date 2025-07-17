<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>히스토리 상세 보기</title>
</head>
<body>

<h2>📄 히스토리 상세</h2>

<p><strong>할 일 ID:</strong> ${history.todo_id}</p>
<p><strong>수행자 ID:</strong> ${history.member_id}</p>
<p><strong>완료일:</strong> <fmt:formatDate value="${history.completed_at}" pattern="yyyy-MM-dd" /></p>
<p><strong>점수:</strong> ${history.score}</p>
<p><strong>메모:</strong> ${history.memo}</p>
<!-- 인증사진 -->
<c:if test="${not empty history.photo}">
    <p>인증사진:</p>
    <img src="${pageContext.request.contextPath}/upload/${history.photo}" alt="인증사진" width="300"/>
</c:if>

<br>
<a href="${pageContext.request.contextPath}/history/all">← 전체 히스토리로 돌아가기</a>

</body>
</html>
