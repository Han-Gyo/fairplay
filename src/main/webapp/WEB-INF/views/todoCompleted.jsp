<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>✔ 완료된 할 일 목록</title>
  <style>
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      border: 1px solid #ccc;
      padding: 10px;
      text-align: center;
    }
    th {
      background-color: #f0f0f0;
    }
  </style>
</head>
<body>

<h2>✔ 완료된 할 일 목록</h2>

<table>
  <thead>
    <tr>
      <th>#</th>
      <th>제목</th>
      <th>담당자</th>
      <th>마감일</th>
      <th>난이도</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="todo" items="${completedList}" varStatus="loop">
      <tr>
        <td>${loop.index + 1}</td>
        <td>${todo.title}</td>
        <td>
          <c:choose>
            <c:when test="${not empty todo.assigned_to}">
              ${memberMap[todo.assigned_to]}
            </c:when>
            <c:otherwise>없음</c:otherwise>
          </c:choose>
        </td>
        <td><fmt:formatDate value="${todo.due_date}" pattern="yyyy-MM-dd" /></td>
        <td>${todo.difficulty_point}</td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<div style="margin-top: 20px;">
  <a href="${pageContext.request.contextPath}/todos">
    <button>🔙 할 일 목록으로 돌아가기</button>
  </a>
</div>

</body>
</html>
