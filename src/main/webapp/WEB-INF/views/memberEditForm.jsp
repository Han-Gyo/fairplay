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
			
			    <!-- ✅ 실명 필드 추가 -->
			    <div class="mb-3">
			        <label for="real_name" class="form-label">이름 (실명)</label>
			        <input type="text" class="form-control" id="real_name" name="real_name" value="${member.real_name}" required />
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
			
			    
			    <!-- 🔒 status는 수정은 불가하지만 서버로 넘겨야 함 -->
				<input type="hidden" name="status" value="${member.status}" />
			
			    <div class="d-flex justify-content-between">
			        <button type="submit" class="btn btn-success">수정 완료</button>
			        <a href="/fairplay/member/members" class="btn btn-secondary">목록으로</a>
			    </div>
			</form>

            
            <!-- ✅ 여기서부터 비밀번호 변경 폼 시작 -->
			<hr class="my-4">
			<h5>비밀번호 변경</h5>
			
			<form action="${pageContext.request.contextPath}/mypage/changePw" method="post">
			    <c:if test="${not empty error}">
			        <div class="alert alert-danger">${error}</div>
			    </c:if>
			    <c:if test="${not empty message}">
			        <div class="alert alert-success">${message}</div>
			    </c:if>
			
			    <div class="mb-3">
			        <label for="currentPassword" class="form-label">현재 비밀번호</label>
			        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required />
			    </div>
			
			    <div class="mb-3">
			        <label for="newPassword" class="form-label">새 비밀번호</label>
			        <input type="password" class="form-control" id="newPassword" name="newPassword" required />
			    </div>
			
			    <div class="mb-3">
			        <label for="confirmPassword" class="form-label">새 비밀번호 확인</label>
			        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required />
			    </div>
			
			    <div class="d-flex justify-content-end">
			        <button type="submit" class="btn btn-warning">비밀번호 변경</button>
			    </div>
			</form>
			
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
