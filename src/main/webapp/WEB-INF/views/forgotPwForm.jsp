<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/nav.jsp" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 찾기 - Fairplay</title>
    <!-- Bootswatch Minty Theme -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css">
    <!-- Bootstrap Icons (아이콘 표시를 위해 반드시 필요) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .forgot-container { max-width: 450px; margin-top: 80px; }
        /* 입력 폼 포커스 시 테두리 색상 조정 */
        .form-control:focus { box-shadow: none; border-color: #78c2ad; }
    </style>
</head>
<body>

<div class="container forgot-container">
    <div class="card shadow-sm border-0">
        <div class="card-body p-4">
            <div class="text-center mb-4">
                <h2 class="fw-bold text-primary">비밀번호 찾기</h2>
                <p class="text-muted">가입하신 아이디와 이메일을 입력해주세요.</p>
            </div>

            <form action="${pageContext.request.contextPath}/forgot/sendTempPw" method="post" id="forgotPwForm">
                <!-- 아이디 입력 -->
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="user_id" name="user_id" placeholder="아이디" required>
                    <label for="user_id">아이디</label>
                </div>

                <!-- 이메일 입력 -->
                <div class="form-floating mb-4">
                    <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                    <label for="email">이메일 주소</label>
                </div>

                <!-- 에러 메시지 표시 -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2 small mb-3">
                        <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                    </div>
                </c:if>

                <!-- 제출 버튼 -->
                <button type="submit" class="btn btn-primary w-100 py-2 fw-bold text-white mb-3">
                    임시 비밀번호 전송
                </button>
                
                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/forgot/forgotId" class="text-decoration-none small text-secondary">아이디를 잊으셨나요?</a>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // 폼 제출 시 중복 클릭 방지 및 사용자 경험(UX) 개선
    document.getElementById('forgotPwForm').onsubmit = function() {
        const btn = this.querySelector('button[type="submit"]');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> 전송 중...';
    };
</script>

</body>
</html>