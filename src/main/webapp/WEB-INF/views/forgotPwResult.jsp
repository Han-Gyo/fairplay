<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/nav.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 결과 - Fairplay</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .result-container { max-width: 500px; margin-top: 100px; }
        .icon-box { font-size: 3rem; margin-bottom: 20px; }
    </style>
</head>
<body>

<div class="container result-container">
    <div class="card shadow border-0 text-center">
        <div class="card-body p-5">
            
            <c:choose>
                <c:when test="${not empty message}">
                    <div class="icon-box text-primary">
                        <i class="bi bi-envelope-check"></i>
                    </div>
                    <h3 class="fw-bold mb-3 text-primary">발송 완료!</h3>
                    <p class="text-muted mb-4">${message}</p>
                    <a href="${pageContext.request.contextPath}/member/login" class="btn btn-primary btn-lg w-100 fw-bold text-white">
                        로그인하러 가기
                    </a>
                </c:when>
                
                <c:otherwise>
                    <div class="icon-box text-danger">
                        <i class="bi bi-x-circle"></i>
                    </div>
                    <h3 class="fw-bold mb-3 text-danger">요청 실패</h3>
                    <p class="text-muted mb-4">${error != null ? error : "정보가 일치하지 않습니다."}</p>
                    <a href="${pageContext.request.contextPath}/forgot" class="btn btn-outline-danger btn-lg w-100 fw-bold">
                        다시 시도하기
                    </a>
                </c:otherwise>
            </c:choose>
            
        </div>
    </div>
</div>

</body>
</html>