<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/forgotIdForm.css">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="card shadow">
            <div class="card-header bg-info text-white">
                <h4 class="mb-0">아이디 찾기</h4>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/forgot/findId" method="post" id="findIdForm">
                    <!-- 🔹 실명 입력 -->
				    <div class="mb-3">
				        <label for="realName" class="form-label">이름 (실명)</label>
				        <input type="text" class="form-control" id="realName" name="real_name" required />
				    </div>
				
				    <!-- 🔹 이메일 입력 -->
				    <div class="mb-3">
				        <label for="email" class="form-label">가입한 이메일 주소</label>
				        <input type="email" class="form-control" id="email" name="email" required />
				    </div>
				
				    <div class="d-flex justify-content-end">
				        <button type="submit" class="btn btn-info">아이디 찾기</button>
				    </div>
				
				    <!-- 🔹 메시지 출력 -->
				    <c:if test="${not empty error}">
				        <div class="alert alert-danger mt-3">${error}</div>
				    </c:if>
				    <c:if test="${not empty message}">
				        <div class="alert alert-success mt-3">${message}</div>
				    </c:if>
                </form>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/forgotIdForm.js"></script>
</body>
</html>
