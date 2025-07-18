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
            color: #007bff;
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
            
                <!-- ID 컬럼 제거 -->
                <th>아이디</th>
                <th>비밀번호</th>
                <th>닉네임</th>
                <th>이메일</th>
                <th>주소</th>
                <th>전화번호</th>
                <th>상태</th>
                <th>가입일</th>
                <th>관리</th>
                
            </tr>
            
        </thead>
        <tbody>
        
            <c:forEach var="member" items="${members}">
            
                <tr>
                    <!-- ID 제거 -->
                    <td>${member.user_id}</td>
                    <td>${member.password}</td>
                    <td>${member.nickname}</td>
                    <td>${member.email}</td>
                    <td>${member.address}</td>
                    <td>${member.phone}</td>
                    <td>${member.status}</td>
                    <td>${member.created_at}</td>
                    <td class="action-buttons">
					    <a href="${pageContext.request.contextPath}/member/edit?id=${member.id}">수정</a>
					    |
					    <a href="${pageContext.request.contextPath}/member/delete?id=${member.id}"
					       onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</a>
					</td>
                    
                </tr>
                
            </c:forEach>
            
        </tbody>
        
    </table>

</body>
</html>
