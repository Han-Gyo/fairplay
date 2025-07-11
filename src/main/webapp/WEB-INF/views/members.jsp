<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 목록</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background-color: #f9f9f9;
            padding: 40px;
        }
        h1 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        thead {
            background-color: #4CAF50;
            color: white;
        }
        th, td {
            padding: 12px 15px;
            text-align: center;
            border-bottom: 1px solid #ddd;
        }
        
        .action-buttons a {
            margin: 0 5px;
            text-decoration: none;
            color: #4CAF50;
            font-weight: bold;
        }
        .action-buttons a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <h1>📋 전체 회원 목록</h1>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>아이디</th>
                <th>비밀번호</th>
                <th>닉네임</th>
                <th>이메일</th>
                <th>주소</th>
                <th>전화번호</th>
                <th>상태</th>
                <th>가입일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="member" items="${members}">
                <tr>
                	<td>${member.id}</td>
                    <td>${member.username}</td>
                    <td>${member.password}</td>
                    <td>${member.nickname}</td>
                    <td>${member.email}</td>
                    <td>${member.address}</td>
                    <td>${member.phone}</td>
                    <td>${member.status}</td>
                    <td>${member.created_at}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

</body>
</html>
