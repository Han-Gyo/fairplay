<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 정보 수정</title>

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="card shadow-lg">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">회원 정보 수정</h4>
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/member/update" method="post">
                <!-- ID는 사용자에게 안 보이게 hidden 처리 -->
                <input type="hidden" name="id" value="${member.id}">
                
                <input type="hidden" name="from" value="mypage" />

                <div class="mb-3">
                    <label for="user_id" class="form-label">아이디 (로그인용)</label>
                    <input type="text" class="form-control" id="user_id" name="user_id" value="${member.user_id}" required>
                </div>

                <div class="mb-3">
                    <label for="nickname" class="form-label">닉네임</label>
                    <input type="text" class="form-control" id="nickname" name="nickname" value="${member.nickname}" required>
                </div>

                <div class="mb-3">
                    <label for="email" class="form-label">이메일</label>
                    <input type="email" class="form-control" id="email" name="email" value="${member.email}" required>
                </div>

                <div class="mb-3">
                    <label for="phone" class="form-label">휴대폰 번호</label>
                    <input type="text" class="form-control" id="phone" name="phone" value="${member.phone}">
                </div>

                <div class="mb-3">
                    <label for="address" class="form-label">주소</label>
                    <input type="text" class="form-control" id="address" name="address" value="${member.address}">
                </div>
                
                <div class="mb-3">
				    <label class="form-label">회원 상태</label>
				    <input type="text" class="form-control" value="${member.status}" readonly>
				</div>
                

                <div class="d-flex justify-content-between">
                    <button type="submit" class="btn btn-success">수정 완료</button>
                    <a href="/fairplay/member/members" class="btn btn-secondary">목록으로</a>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
