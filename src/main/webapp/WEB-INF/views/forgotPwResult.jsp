<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/nav.jsp" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>임시 비밀번호 결과</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/forgotPwResult.css">
</head>
<body>

    <div class="result-container">
        <h2>비밀번호 찾기 결과</h2>

        <c:if test="${not empty message}">
            <p class="success">${message}</p>
            <a href="${pageContext.request.contextPath}/member/login" class="btn">로그인 하러 가기</a>
        </c:if>

        <c:if test="${not empty error}">
            <p class="error">${error}</p>
            <a href="${pageContext.request.contextPath}/forgot" class="btn">다시 시도하기</a>
        </c:if>
    </div>

</body>
</html>
