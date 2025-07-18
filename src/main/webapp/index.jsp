<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Fairplay - Home</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f5f7fa;
            color: #333;
            text-align: center;
            padding: 50px;
        }
        h1 {
            font-size: 36px;
            margin-bottom: 30px;
            color: #4a90e2;
        }
        .link-box {
            display: inline-block;
            text-align: left;
            padding: 30px 40px;
            background-color: #ffffff;
            border-radius: 16px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .link-box h2 {
            font-size: 20px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
            margin-bottom: 15px;
            color: #666;
        }
        .link-box a {
            display: block;
            margin: 8px 0;
            font-size: 16px;
            text-decoration: none;
            color: #2c3e50;
            transition: 0.2s;
        }
        .link-box a:hover {
            color: #4a90e2;
            font-weight: bold;
        }
    </style>
</head>
<body>

    <h1>🏠 Fairplay</h1>

    <div class="link-box">
        <h2>📌 기능 바로가기</h2>
        <a href="${pageContext.request.contextPath}/history/all">📋 History 전체 조회</a>
        <a href="${pageContext.request.contextPath}/history/create">📝 History 등록</a>
        <a href="${pageContext.request.contextPath}/todos">🧹 Todo 목록</a>
        <a href="${pageContext.request.contextPath}/member/create">👤 회원 가입</a>
        <a href="${pageContext.request.contextPath}/member/members">👥 회원 목록</a>
        <a href="${pageContext.request.contextPath}/group/create">🏠 그룹 등록</a>
        <a href="${pageContext.request.contextPath}/group/groups">👥 그룹 목록</a>
        <a href="${pageContext.request.contextPath}/groupmember/create">🔗 그룹멤버 등록</a>
        <a href="${pageContext.request.contextPath}/member/login">로그인</a>
        <a href="${pageContext.request.contextPath}/member/mypage">👤 마이페이지</a><br>
    </div>

</body>
</html>
