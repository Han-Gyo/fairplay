<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>

<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>아이디 찾기 - Fairplay</title>
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
<div class="col-md-6 col-lg-5">
<!-- 민티 테마의 둥근 모서리를 강조하기 위해 border-radius 적용 -->
<div class="card border-0 shadow-sm" style="border-radius: 1rem; overflow: hidden;">

                <!-- 카드 헤더: 민티의 primary 색상 사용 -->
                <div class="card-header bg-primary text-white text-center py-4">
                    <h3 class="mb-0 fw-bold">아이디 찾기</h3>
                    <small>등록된 정보로 아이디를 찾으세요</small>
                </div>

                <div class="card-body p-4 p-md-5 bg-white">
                    <!-- 아이디 찾기 폼 시작 -->
                    <form action="${pageContext.request.contextPath}/forgot/findId" method="post" id="findIdForm">
                        
                        <!-- 실명 입력 섹션 -->
                        <div class="form-group mb-4">
                            <label for="realName" class="form-label text-secondary fw-bold">이름</label>
                            <input type="text" 
                                   class="form-control form-control-lg" 
                                   id="realName" 
                                   name="real_name" 
                                   placeholder="실명을 입력해 주세요" 
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
                    
                        <!-- 제출 버튼: 민티 특유의 둥근 버튼 스타일 적용 -->
                        <div class="d-grid gap-2 mt-5">
                            <button type="submit" class="btn btn-primary btn-lg fw-bold text-white shadow-sm" style="border-radius: 0.5rem;">
                                아이디 찾기
                            </button>
                            <a href="${pageContext.request.contextPath}/member/login" class="btn btn-link text-decoration-none text-muted mt-2">
                                로그인 페이지로 돌아가기
                            </a>
                        </div>
                    
                        <!-- 결과 및 에러 메시지 출력 (서버 피드백) -->
                        <div class="mt-4">
                            <c:if test="${not empty error}">
                                <div class="alert alert-dismissible alert-danger">
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    <strong>오류!</strong> ${error}
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty message}">
                                <div class="alert alert-dismissible alert-success">
                                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                                    <strong>성공!</strong> ${message}
                                </div>
                            </c:if>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 외부 JS 파일 연결 -->
<script src="${pageContext.request.contextPath}/resources/js/forgotIdForm.js"></script>


</body>
</html>