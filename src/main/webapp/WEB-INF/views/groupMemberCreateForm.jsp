<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%-- nav.jsp 포함: 상단 내비게이션 바 --%>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>그룹 멤버 등록 - Fairplay</title>
    <!-- Bootswatch Minty Theme -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css">
    <!-- Google Fonts: Noto Sans KR -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f8f9fa;
        }
        .container-wrapper {
            min-height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .form-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
            width: 100%;
            max-width: 450px;
        }
        .card-header-custom {
            background-color: #78c2ad;
            color: white;
            border-radius: 15px 15px 0 0 !important;
            padding: 20px;
            text-align: center;
        }
        .btn-join {
            background-color: #78c2ad;
            border-color: #78c2ad;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        .btn-join:hover {
            background-color: #5bb097;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

<div class="container-wrapper">
    <div class="card form-card">
        <div class="card-header-custom">
            <h3 class="mb-0">그룹 가입</h3>
        </div>
        <div class="card-body p-4">
            <p class="text-center text-muted mb-4 small">가입을 위해 그룹의 초대코드(8자리)를 입력해주세요.</p>

            <c:if test="${not empty msg}">
                <div class="alert alert-dismissible alert-danger">
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    <strong>오류:</strong> ${msg}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/groupmember/create" method="post">
                <input type="hidden" name="groupId" value="${group.id}" />

                <div class="form-group mb-3">
                    <label for="inviteCode" class="form-label fw-bold">초대코드</label>
                    <%-- 
                        추가 및 수정 사항:
                        1. maxlength="8": 8자 이상 입력 방지
                        2. minlength="8": 8자 미만일 시 브라우저단에서 경고
                        3. pattern="[A-Za-z0-9]{8}": 영문/숫자 8자리 정규식 검사
                        4. oninput: 소문자 입력 시 자동으로 대문자 변환 (사용자 편의성)
                    --%>
                    <input type="text" 
                           id="inviteCode" 
                           name="inviteCode" 
                           class="form-control form-control-lg text-center" 
                           required 
                           maxlength="8"
                           minlength="8"
                           pattern="[A-Za-z0-9]{8}"
                           title="8자리의 영문 또는 숫자를 입력해주세요."
                           placeholder="EX: A1B2C3D4"
                           style="letter-spacing: 2px; font-weight: bold;"
                           oninput="this.value = this.value.toUpperCase()"
                           autocomplete="off">
                </div>

                <div class="d-grid gap-2 mt-4">
                    <button type="submit" class="btn btn-primary btn-join btn-lg text-white">가입하기</button>
                    <a href="${pageContext.request.contextPath}/group/groups" class="btn btn-outline-secondary btn-sm border-0 mt-2 text-muted">목록으로 돌아가기</a>
                </div>
            </form>
        </div>
    </div>
</div>


</body>
</html>