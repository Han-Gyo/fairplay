<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/login.css" />
</head>
<body>
<div class="login-container">
    <h2 class="login-title">🔐 로그인</h2>

    <!-- 로그인 실패 메시지 -->
    <c:if test="${not empty loginError}">
        <div class="error-msg">${loginError}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/member/login" method="post">
        <div class="form-group">
            <label>아이디</label>
            <input type="text" name="user_id" placeholder="아이디를 입력하세요">
        </div>

        <div class="form-group">
            <label>비밀번호</label>
            <input type="password" name="password" placeholder="비밀번호를 입력하세요">
        </div>

        <button type="submit">로그인</button>
    </form>
</div>
</body>
</html>