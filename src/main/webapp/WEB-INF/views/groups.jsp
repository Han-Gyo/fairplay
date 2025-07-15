<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>그룹 목록</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 50px;
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        .table-container {
            width: 90%;
            max-width: 1000px;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.05);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            border-radius: 12px;
            overflow: hidden;
        }

        thead {
            background-color: #4a90e2;
            color: white;
        }

        th, td {
            padding: 14px 16px;
            text-align: center;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .btn {
            padding: 6px 12px;
            font-size: 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s ease-in-out;
        }

        .btn-edit {
            background-color: #28a745;
            color: white;
        }

        .btn-edit:hover {
            background-color: #218838;
        }

        .btn-delete {
            background-color: #dc3545;
            color: white;
        }

        .btn-delete:hover {
            background-color: #c82333;
        }
    </style>
</head>
<body>

<h2>📋 그룹 목록</h2>

<div class="table-container">
    <table>
        <thead>
            <tr>
                <th>이름</th>
                <th>설명</th>
                <th>공개 여부</th>
                <th>초대 코드</th>
                <th>생성일</th>
                <th>수정</th>
                <th>삭제</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="group" items="${groups}">
                <tr>
                    <td>${group.name}</td>
                    <td>${group.description}</td>
                    <td>
					    <c:choose>
						  <c:when test="${group.publicStatus eq 'true'}">공개</c:when>
						  <c:otherwise>비공개</c:otherwise>
						</c:choose>
					</td>
                    <td>${group.code}</td>
                    <td>${group.created_at}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/group/edit?id=${group.id}">
                            <button class="btn btn-edit">수정</button>
                        </a>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/group/delete?id=${group.id}" onclick="return confirm('정말 삭제할까요?');">
                            <button class="btn btn-delete">삭제</button>
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>
