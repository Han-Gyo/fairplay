<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 찾기 - Fairplay</title>
    <!-- 민티 테마 적용 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css">
    <!-- 아이콘 라이브러리 추가 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <style>
        /* 미세한 UI 교정을 위한 최소한의 스타일 */
        body { background-color: #f8f9fa; }
        .form-control {
            /* 부트스트랩 기본 높이를 명시적으로 맞춰서 사이즈 차이 제거 */
            padding: 0.75rem 1rem;
        }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <!-- 아이디 찾기와 동일한 너비 설정 (col-md-6 col-lg-5) -->
        <div class="col-md-6 col-lg-5">
            <!-- 카드 스타일 통일: 라운딩 및 그림자 적용 -->
            <div class="card border-0 shadow-sm" style="border-radius: 1rem; overflow: hidden;">
                
                <!-- 카드 헤더: 아이디 찾기와 동일한 구성 -->
                <div class="card-header bg-primary text-white text-center py-4">
                    <h3 class="mb-0 fw-bold">비밀번호 찾기</h3>
                    <small>가입 정보로 임시 비밀번호를 발급받으세요</small>
                </div>

                <div class="card-body p-4 p-md-5 bg-white">
                    <form action="${pageContext.request.contextPath}/forgot/sendTempPw" method="post" id="forgotPwForm">
                        
                        <!-- 아이디 입력 섹션 (form-floating 대신 아이디 찾기와 동일한 label 스타일 적용) -->
                        <div class="form-group mb-4">
                            <label for="user_id" class="form-label text-secondary fw-bold">아이디</label>
                            <input type="text" 
                                   class="form-control form-control-lg" 
                                   id="user_id" 
                                   name="user_id" 
                                   placeholder="아이디를 입력해 주세요" 
                                   required 
                                   style="border-radius: 0.5rem;">
                        </div>
                    
                        <!-- 이메일 입력 섹션 -->
                        <div class="form-group mb-4">
                            <label for="email" class="form-label text-secondary fw-bold">이메일 주소</label>
                            <input type="email" 
                                   class="form-control form-control-lg" 
                                   id="email" 
                                   name="email" 
                                   placeholder="example@fairplay.com" 
                                   required 
                                   style="border-radius: 0.5rem;">
                        </div>
                    
                        <!-- 버튼 섹션: 간격 및 둥근 스타일 통일 -->
                        <div class="d-grid gap-2 mt-5">
                            <button type="submit" id="submitBtn" class="btn btn-primary btn-lg fw-bold text-white shadow-sm" style="border-radius: 0.5rem;">
                                임시 비밀번호 전송
                            </button>
                            <div class="text-center mt-3">
                                <a href="${pageContext.request.contextPath}/forgot/forgotId" class="text-decoration-none small text-secondary me-3">아이디 찾기</a>
                                <span class="text-muted small">|</span>
                                <a href="${pageContext.request.contextPath}/member/login" class="text-decoration-none small text-secondary ms-3">로그인으로 돌아가기</a>
                            </div>
                        </div>
                    
                        <!-- 결과/에러 메시지 레이아웃 통일 -->
                        <div class="mt-4">
                            <c:if test="${not empty error}">
                                <div class="alert alert-dismissible alert-danger py-2 small">
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    <i class="bi bi-exclamation-triangle-fill"></i> ${error}
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty message}">
                                <div class="alert alert-dismissible alert-success py-2 small">
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    <i class="bi bi-check-circle-fill"></i> ${message}
                                </div>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    /* * [수정 내역]
     * 1. 폼 제출 시 버튼 비활성화 로직 유지 (중복 발송 방지)
     * 2. 아이디 찾기 페이지 디자인에 맞춰 폼 구조 및 클래스 명칭 변경
     */
    document.getElementById('forgotPwForm').onsubmit = function() {
        const btn = document.getElementById('submitBtn');
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status"></span> 전송 중...';
    };
</script>

</body>
</html>