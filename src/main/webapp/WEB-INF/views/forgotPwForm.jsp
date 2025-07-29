<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/forgotPwForm.css">
</head>
<body>

    <div class="form-container">
        <h2>비밀번호 찾기</h2>

        <form action="${pageContext.request.contextPath}/forgot/sendTempPw" method="post">
            <!-- 사용자 아이디 입력 -->
            <label for="user_id">아이디</label>
            <input type="text" id="user_id" name="user_id" required />

            <!-- 이메일 주소 입력 -->
            <label for="email">이메일</label>
            <input type="email" id="email" name="email" required />

            <!-- 제출 버튼 -->
            <button type="submit">임시 비밀번호 전송</button>
        </form>

        <!-- 결과 메시지 영역 -->
        <div class="message">
            <c:if test="${not empty message}">
                <p class="success">${message}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p class="error">${error}</p>
            </c:if>
        </div>
    </div>

</body>
</html>
