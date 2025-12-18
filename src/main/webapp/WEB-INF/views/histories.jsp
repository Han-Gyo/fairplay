<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체 히스토리 보기</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/histories.css" />

</head>
<body>

<h1>📋 전체 수행 히스토리</h1>

<a href="${pageContext.request.contextPath}/todos">← 할 일 목록으로</a>
<!-- 필터용 네비게이션 -->
<div style="margin-bottom: 10px;">
  <a href="${pageContext.request.contextPath}/history/all" 
     style="${empty selectedTodoId ? 'font-weight:bold' : ''}">[전체보기]</a>

  <c:forEach var="todo" items="${todoList}">
    <a href="${pageContext.request.contextPath}/history/all?todo_id=${todo.id}" 
       style="${selectedTodoId == todo.id ? 'font-weight:bold;color:blue;' : ''}">
       ${todo.title}
    </a>
  </c:forEach>
</div>
<table>
  <thead>
    <tr>
      <th>번호</th>
      <th>할 일</th>
      <th>담당자</th>
      <th>완료일</th>
      <th>점수</th>
      <th class="memo">메모</th>
      <th>관리</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="history" items="${historyList}" varStatus="status">
      <tr>
      	<td>${status.count}</td>
        <td>
        	<a href="${pageContext.request.contextPath}/history/detail?history_id=${history.id}">${history.todo.title}</a>
        	<c:if test="${history.newComment}">
			    	<span style="color:red; font-weight:bold;">🆕</span>
			  	</c:if>
        </td>
        <td>${history.member.nickname}</td>
        <td>
        	<fmt:formatDate value="${history.completed_at}" pattern="yyyy-MM-dd" />
        </td>
        <td>
          <c:choose>
            <c:when test="${empty history.score}">
               -
            </c:when>
            <c:otherwise>
               ${history.score}
          	</c:otherwise>
        	</c:choose>
        </td>
      	<td class="memo">${history.memo}</td>
				<td class="actions">
					<c:if test="${history.member_id == loginMember.id}">
			      <a href="${pageContext.request.contextPath}/history/update?id=${history.id}">수정</a>
			    
			      <form action="${pageContext.request.contextPath}/history/delete" method="post" style="display:inline;">
			        <input type="hidden" name="id" value="${history.id}">
			        <input type="hidden" name="todo_id" value="${history.todo.id}">
			        <button type="submit" onclick="return confirm('정말 삭제할까요?');">삭제</button>
			      </form>
					</c:if>
					  
					<c:if test="${history.member_id != loginMember.id}">
					  <span style="color: #ccc;">권한 없음</span>
					</c:if>
				</td>
      </tr>
    </c:forEach>
  </tbody>
</table>
</body>
</html>
