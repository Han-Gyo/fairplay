<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>히스토리 상세 보기</title>
</head>
<body>

<h2>📄 히스토리 상세</h2>

<p><strong>할 일 : </strong> ${history.todo.title}</p>
<p><strong>수행자 : </strong> ${history.member.nickname}</p>
<p><strong>완료일 : </strong> <fmt:formatDate value="${history.completed_at}" pattern="yyyy-MM-dd" /></p>
<p><strong>점수 : </strong> ${history.score}</p>
<p><strong>메모 :</strong> ${history.memo}</p>
<!-- 인증사진 -->
<c:if test="${not empty history.photo}">
    <p>인증사진</p>
    <img src="${pageContext.request.contextPath}/upload/${history.photo}" alt="인증사진" width="300"/>
</c:if>
<hr>
<h3>💬 댓글</h3>

<!-- 🔄 댓글 목록 -->
<c:forEach var="comment" items="${commentList}">
    <div style="border:1px solid #ccc; padding:10px; margin-bottom:10px;">
        <p><strong>${comment.nickname}</strong> (${comment.createdAt})</p>
        <p>${comment.content}</p>

        <!-- 댓글 작성자거나 관리자일 경우 삭제 가능 -->
        <c:if test="${loginMember.id == comment.memberId || loginMember.role == 'ADMIN'}">
            <form action="${pageContext.request.contextPath}/history/comments/delete" method="post" style="display:inline;">
                <input type="hidden" name="id" value="${comment.id}" />
                <input type="hidden" name="history_id" value="${history.id}" />
                <button type="submit" onclick="return confirm('댓글을 삭제할까요?')">🗑 삭제</button>
            </form>
        </c:if>
    </div>
</c:forEach>

<!-- ✏️ 댓글 작성 폼 -->
<form action="${pageContext.request.contextPath}/history/comments/add" method="post">
    <input type="hidden" name="history_id" value="${history.id}" />
    <textarea name="content" rows="3" cols="50" placeholder="댓글을 입력하세요" required></textarea><br>
    <button type="submit">➕ 댓글 작성</button>
</form>

<br>
<a href="${pageContext.request.contextPath}/history/all">← 전체 히스토리로 돌아가기</a>

</body>
</html>
