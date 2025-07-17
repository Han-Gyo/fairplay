<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    </style>
</head>
<body>

<h2>📋 전체 수행 히스토리</h2>

<a href="${pageContext.request.contextPath}/todos">← 할 일 목록으로</a>

<table>
    <thead>
        <tr>
            <th>번호</th>
            <th>할 일 ID</th>
            <th>수행자</th>
            <th>완료일</th>
            <th>점수</th>
            <th class="memo">메모</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="history" items="${historyList}" varStatus="status">
            <tr>
                <td>
								  <a href="${pageContext.request.contextPath}/history/detail?id=${history.id}">
								    ${status.count}
								  </a>
								</td>
                <td>${history.todo_id}</td>
                <td>${history.member_id}</td>
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
            </tr>
        </c:forEach>
    </tbody>
</table>

</body>
</html>
