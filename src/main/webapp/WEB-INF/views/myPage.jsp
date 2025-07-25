<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>마이페이지</title>
    <meta charset="UTF-8">
    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
    <!-- Bootstrap (선택사항) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: 'Nanum Gothic', sans-serif;
            background: linear-gradient(135deg, #fce3ec, #ffe6f7);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.25);
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.2);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            padding: 40px;
            width: 400px;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }

        .info-line {
            margin: 10px 0;
            font-size: 16px;
            color: #444;
        }

        .action-links {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }

        .btn-custom {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            background: #ff8ec7;
            color: white;
            transition: 0.3s;
            text-decoration: none;
        }

        .btn-custom:hover {
            background: #e471b0;
        }

        .btn-danger {
            background: #ff5e7e;
        }

        .btn-danger:hover {
            background: #d94c68;
        }
    </style>
</head>
<body>
    <div class="glass-card">
        <h2>👤 마이페이지</h2>

        <div class="info-line">실명: ${member.real_name}</div>
        <div class="info-line">아이디: ${member.user_id}</div>
        <div class="info-line">닉네임: ${member.nickname}</div>
        <div class="info-line">이메일: ${member.email}</div>
        <div class="info-line">전화번호: ${member.phone}</div>
        <div class="info-line">주소: ${member.address}</div>
        <div class="info-line">가입일: ${member.created_at}</div>
        
        <!-- 👇 enum 상태 확인용 -->
    	<div class="info-line">회원 상태: ${member.status}</div>

        <div class="action-links">
            <a class="btn-custom" href="${pageContext.request.contextPath}/member/edit?id=${member.id}">정보 수정</a>

            <form action="${pageContext.request.contextPath}/member/deactivate" method="post"
                  onsubmit="return confirm('정말 탈퇴하시겠습니까?')">
                <input type="hidden" name="id" value="${member.id}" />
                <button type="submit" class="btn-custom btn-danger">회원 탈퇴</button>
            </form>
        </div>
    </div>
</body>
</html>
