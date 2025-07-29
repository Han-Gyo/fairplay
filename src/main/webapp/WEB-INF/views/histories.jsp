<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전체 히스토리 보기</title>
    <style>
        body {
            font-family: '맑은 고딕', sans-serif;
            margin: 40px;
        }
        h2 {
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 16px;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #ccc;
            text-align: center;
        }
        th {
            background-color: #f4f4f4;
        }
        tr:hover {
            background-color: #f9f9f9;
        }
        .memo {
            text-align: left;
        }
        .actions {
				    display: flex;
				    justify-content: center;
				    gap: 8px; /* 버튼 사이 간격 */
				}
				
				.actions form {
				    margin: 0;
				}
				
				.actions a,
				.actions button {
				    padding: 6px 10px;
				    font-size: 14px;
				    border: none;
				    background-color: #4CAF50;
				    color: white;
				    border-radius: 4px;
				    cursor: pointer;
				    text-decoration: none;
				}
				
				.actions button {
				    background-color: #f44336;
				}
				
				.actions a:hover {
				    background-color: #45a049;
				}
				
				.actions button:hover {
				    background-color: #d32f2f;
				}
				a {
					color : black;
					text-decoration : none;
				}
				a:hover {
					color : pink;
				}
    </style>
</head>
<body>

<h1><a href="${pageContext.request.contextPath}/">📋 전체 수행 히스토리</a></h1>

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
								  <!-- 수정 버튼 -->
								  <a href="${pageContext.request.contextPath}/history/update?id=${history.id}">수정</a>
								
								  <!-- 삭제 버튼 -->
								  <form action="${pageContext.request.contextPath}/history/delete" method="post">
								    <input type="hidden" name="id" value="${history.id}">
								    <input type="hidden" name="todo_id" value="${history.todo.id}">
								    <button type="submit" onclick="return confirm('정말 삭제할까요?');">삭제</button>
								  </form>
								</td>
            </tr>
        </c:forEach>
    </tbody>
</table>
</body>
</html>
