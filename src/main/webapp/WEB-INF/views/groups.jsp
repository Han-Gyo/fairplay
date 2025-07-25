<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
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

        .btn-detail {
            background-color: #007bff;
            color: white;
        }

        .btn-detail:hover {
            background-color: #0056b3;
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
                <th>상세보기</th> <!-- ✅ 수정 -->
            </tr>
        </thead>
        <tbody>
            <c:forEach var="group" items="${groups}">
                <tr>
                    <td>${group.name}</td>
                    <td>${group.description}</td>
                    <td>
                        <c:choose>
                            <c:when test="${group.publicStatus}">공개</c:when>
                            <c:otherwise>비공개</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${group.code}</td>
                    <td>${group.created_at}</td>
                    <td>
                        <!-- ✅ 상세보기 버튼만 남김 -->
                        <a href="${pageContext.request.contextPath}/group/detail?id=${group.id}">
                            <button class="btn btn-detail">상세보기</button>
                        </a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>
