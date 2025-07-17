<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그룹 멤버 목록</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #eef2f7;
            padding: 50px;
        }

        .table-box {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            padding: 30px;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px 15px;
            text-align: center;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f4f6f9;
        }

        tr:hover {
            background-color: #d6e9f8;
        }

        .btn-back {
            display: block;
            margin: 30px auto 0;
            text-align: center;
            background-color: #6c757d;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
        }

        .btn-back:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>

<div class="table-box">
    <h2>👥 그룹 멤버 목록</h2>

    <table>
        <thead>
            <tr>
                <th>회원 ID</th>
                <th>역할</th>
                <th>총 점수</th>
                <th>주간 점수</th>
                <th>경고 횟수</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="member" items="${groupMembers}">
                <tr>
                    <td>${member.memberId}</td>
                    <td>${member.role}</td>
                    <td>${member.totalScore}</td>
                    <td>${member.weeklyScore}</td>
                    <td>${member.warningCount}</td>
                    
                    <!-- 임시: 수정/추방 버튼은 누구에게나 보이게 설정 -->
					<td>
					    <a href="${pageContext.request.contextPath}/groupmember/edit?id=${member.id}" class="action-link edit">수정</a>
					    <a href="${pageContext.request.contextPath}/groupmember/delete?id=${member.id}&groupId=${member.groupId}" 
					       onclick="return confirm('정말 추방하시겠습니까?');" class="action-link delete">추방</a>
					</td>
                    
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <form action="${pageContext.request.contextPath}/group/groups">
        <button type="submit" class="btn-back">그룹 목록으로 돌아가기</button>
    </form>
</div>

</body>
</html>
