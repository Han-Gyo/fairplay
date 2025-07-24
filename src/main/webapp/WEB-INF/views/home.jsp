<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        <!-- 로그인 안 된 사용자에겐 로그인/회원가입 표시 -->
		<c:if test="${empty sessionScope.member}">
		    <a href="${pageContext.request.contextPath}/member/create">👤 회원 가입</a>
		    <a href="${pageContext.request.contextPath}/member/login">🔐 로그인</a>
		</c:if>
        
        <a href="${pageContext.request.contextPath}/group/create">🏠 그룹 등록</a>
        <a href="${pageContext.request.contextPath}/group/groups">👥 그룹 목록</a>
        <a href="${pageContext.request.contextPath}/groupmember/create">🔗 그룹멤버 등록</a>

		<!-- 로그인 + ACTIVE 상태인 회원만 마이페이지 가능 -->
		<c:if test="${not empty sessionScope.member && sessionScope.member.status == 'ACTIVE'}">
		    <a href="${pageContext.request.contextPath}/member/mypage">👤 마이페이지</a>
		</c:if>
		
		<!-- 로그인한 관리자라면 전체 회원 목록 표시 -->
		<c:if test="${not empty sessionScope.member && sessionScope.member.role == 'ADMIN'}">
		    <a href="${pageContext.request.contextPath}/member/members">👑 전체 회원 목록</a>
		</c:if>
		
		<!-- 로그인되어 있으면 로그아웃 표시 -->
		<c:if test="${not empty sessionScope.member}">
		    <a href="javascript:void(0);" onclick="confirmLogout()">🚪 로그아웃</a>
		</c:if>
		
		<a href="${pageContext.request.contextPath}/wallet/create">💸 가계부</a>
		
    </div>

		<script>
		    function confirmLogout() {
		        if (confirm("정말 로그아웃 하시겠습니까?")) {
		            // 확인 누르면 로그아웃 요청
		            window.location.href = '${pageContext.request.contextPath}/member/logout';
		        }
		    }
		</script>
</body>
</html>
