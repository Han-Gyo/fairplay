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

<div class="container history-page">
    
   <header class="history-header">
       <h1 class="page-title">📋 전체 수행 히스토리</h1>
       <div class="top-nav">
           <a href="${pageContext.request.contextPath}/todos" class="back-link">← 할 일 목록으로</a>
       </div>
   </header>

	<div class="card border-0 shadow-sm mb-5 rounded-4">
	  <div class="card-body p-4">
	    <form method="get" action="${pageContext.request.contextPath}/history/all">
	      <label for="groupId" class="form-label fw-bold text-secondary small">그룹 선택</label>
	      <div class="input-group">
	        <span class="input-group-text bg-primary text-white border-primary"><i class="fas fa-users"></i></span>
	        <select name="groupId" id="groupId" class="form-select border-primary" onchange="this.form.submit()">
	          <c:forEach var="group" items="${joinedGroups}">
	            <option value="${group.id}" ${group.id == groupId ? 'selected' : ''}>${group.name}</option>
	          </c:forEach>
	        </select>
	      </div>
	    </form>
	  </div>
	</div>

	<div class="table-card shadow-sm">
	    <table class="table history-table">
	        <thead>
	            <tr>
	                <th>번호</th>
	                <th>할 일</th>
	                <th>담당자</th>
	                <th>완료일</th>
	                <th>점수</th>
	                <th class="memo-col">메모</th>
	                <th>관리</th>
	            </tr>
	        </thead>
	        <tbody>
	            <c:forEach var="history" items="${historyList}" varStatus="status">
	                <tr>
	                    <td>${status.count}</td>
	                    <td class="text-start px-4">
	                        <a href="${pageContext.request.contextPath}/history/detail?history_id=${history.id}" class="todo-link">
	                            ${history.todo.title}
	                        </a>
	                        <c:if test="${history.newComment}">
	                            <span class="new-tag">NEW</span>
	                        </c:if>
	                    </td>
	                    <td><span class="nickname">${history.member.nickname}</span></td>
	                    <td><fmt:formatDate value="${history.completed_at}" pattern="yyyy-MM-dd" /></td>
	                    <td>
	                        <span class="score-pill ${empty history.score ? 'is-empty' : ''}">
	                            ${empty history.score ? '-' : history.score}
	                        </span>
	                    </td>
	                    <td class="memo-col text-muted">${history.memo}</td>
	                    <td class="action-btns">
	                        <c:if test="${history.member_id == loginMember.id}">
	                            <a href="${pageContext.request.contextPath}/history/update?id=${history.id}" class="btn-mint">수정</a>
	                            <form action="${pageContext.request.contextPath}/history/delete" method="post" style="display:inline;">
	                                <input type="hidden" name="id" value="${history.id}">
	                                <input type="hidden" name="todo_id" value="${history.todo.id}">
	                                <button type="submit" class="btn-pink" onclick="return confirm('정말 삭제할까요?');">삭제</button>
	                            </form>
	                        </c:if>
	                        <c:if test="${history.member_id != loginMember.id}">
	                            <small class="text-light-gray">권한 없음</small>
	                        </c:if>
	                    </td>
	                </tr>
	            </c:forEach>
	        </tbody>
	    </table>
	</div>
</div>

</body>
</html>