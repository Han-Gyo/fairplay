<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <!-- 1. 부트스트랩 테마 (CDN) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.3/dist/minty/bootstrap.min.css">
    <!-- 2. 커스텀 CSS (외부 파일 연결) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/login.css" />
</head>
<body>

<div class="login-container">
    <h2 class="login-title text-primary">로그인</h2>

    <!-- 로그인 실패 메시지 표시 -->
    <c:if test="${not empty loginError}">
        <div class="alert alert-dismissible alert-danger py-2">
            <small>${loginError}</small>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/member/login" method="post">
        <div class="form-group mb-3">
            <label class="form-label ps-1">아이디</label>
            <input type="text" name="user_id" class="form-control" placeholder="아이디를 입력하세요" required>
        </div>

        <div class="form-group mb-4">
            <label class="form-label ps-1">비밀번호</label>
            <input type="password" name="password" class="form-control" placeholder="비밀번호를 입력하세요" required>
        </div>

        <button type="submit" class="btn btn-primary w-100 btn-lg shadow-sm">로그인</button>
    </form>

    <!-- 아이디 / 비밀번호 찾기 링크 추가 -->
    <div class="d-flex justify-content-center mt-3 mb-1">
        <a href="${pageContext.request.contextPath}/forgot/forgotId" class="text-secondary small text-decoration-none">아이디 찾기</a>
        <span class="text-muted small mx-2">|</span>
        <a href="${pageContext.request.contextPath}/forgot" class="text-secondary small text-decoration-none">비밀번호 찾기</a>
    </div>

    <div class="text-center mt-2">
        <span class="text-muted small">계정이 없으신가요?</span>
        <a href="${pageContext.request.contextPath}/member/create" class="text-primary small fw-bold text-decoration-none ms-1">회원가입</a>
    </div>
</div>

</body>
</html>