<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .navbar {
        background-color: #4a90e2;
        color: white;
        padding: 10px 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-family: 'Segoe UI', sans-serif;
    }

    .navbar a {
        color: white;
        text-decoration: none;
        margin: 0 12px;
        font-weight: bold;
        position: relative;
    }

    .navbar a:hover {
        text-decoration: underline;
    }

    .navbar .left,
    .navbar .right {
        display: flex;
        align-items: center;
        position: relative;
    }

    .dropdown {
        position: relative;
    }

    .dropdown-content {
        display: none;
        position: absolute;
        background-color: white;
        min-width: 180px;
        box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        z-index: 1;
        top: 100%;
        left: 0;
        border-radius: 8px;
        padding: 10px 0;
    }

    .dropdown-content a {
        color: #333;
        padding: 8px 16px;
        display: block;
        text-decoration: none;
        font-weight: normal;
    }

    .dropdown-content a:hover {
        background-color: #f1f1f1;
        color: #4a90e2;
        font-weight: bold;
    }

    .dropdown:hover .dropdown-content {
        display: block;
    }
</style>

<div class="navbar">
    <div class="left">
        <a href="${pageContext.request.contextPath}/">🏠 Home</a>

        <!-- Todo 드롭다운 -->
        <div class="dropdown">
            <a href="javascript:void(0);">🧹 Todo</a>
            <div class="dropdown-content">
                <a href="${pageContext.request.contextPath}/todos">📋 Todo 목록</a>
                <a href="${pageContext.request.contextPath}/todos/myTodos">✅ MyTodo 목록</a>
                <a href="${pageContext.request.contextPath}/todos/create">✅ Todo 등록</a>
            </div>
        </div>

        <!-- History 드롭다운 -->
        <div class="dropdown">
            <a href="javascript:void(0);">📋 History</a>
            <div class="dropdown-content">
                <a href="${pageContext.request.contextPath}/history/all">📋 전체 조회</a>
                <a href="${pageContext.request.contextPath}/history/create">📝 기록 등록</a>
            </div>
        </div>

        <!-- Wallet 드롭다운 -->
        <div class="dropdown">
            <a href="javascript:void(0);">💸 가계부</a>
            <div class="dropdown-content">
                <a href="${pageContext.request.contextPath}/wallet">💰 내 가계부</a>
                <a href="${pageContext.request.contextPath}/wallet/create">💸 작성하기</a>
            </div>
        </div>

        <!-- 그룹 드롭다운 -->
        <div class="dropdown">
            <a href="javascript:void(0);">👥 그룹</a>
            <div class="dropdown-content">
                <a href="${pageContext.request.contextPath}/group/create">🏠 그룹 등록</a>
                <a href="${pageContext.request.contextPath}/group/groups">👥 그룹 목록</a>
            </div>
        </div>
    </div>

	<div class="right">
	    <c:choose>
	    
	        <c:when test="${empty sessionScope.loginMember}">
	            <a href="${pageContext.request.contextPath}/member/login">🔐 로그인</a>
	            <a href="${pageContext.request.contextPath}/member/create">👤 회원가입</a>
	            <a href="${pageContext.request.contextPath}/forgot/forgotId">🆔 아이디찾기</a>
	            <a href="${pageContext.request.contextPath}/forgot">🔑 비밀번호 찾기</a>
	        </c:when>
	
	        <c:otherwise>
	            <span style="color:pink; font-weight:bold;">
	               ♥ ${sessionScope.loginMember.nickname}님 안녕하세요 ♥
	            </span>
	            <a href="${pageContext.request.contextPath}/member/mypage">🙋 마이페이지</a>
	            <a href="javascript:void(0);" onclick="confirmLogout()">🚪 로그아웃</a>
	            
	        </c:otherwise>
	    </c:choose>
	</div>
</div>

<script>
    function confirmLogout() {
        if (confirm("정말 로그아웃 하시겠습니까?")) {
            window.location.href = '${pageContext.request.contextPath}/member/logout';
        }
    }
</script>
