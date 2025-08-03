<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 정보 수정</title>

    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light" data-context-path="${pageContext.request.contextPath}">


<div class="container mt-5">
    <div class="card shadow-lg">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">회원 정보 수정</h4>
        </div>
        
        <div class="card-body">
        
            <form id="editForm" action="${pageContext.request.contextPath}/mypage/update" method="post" enctype="multipart/form-data">
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
				    <div class="input-group">
				        <input type="text" class="form-control" id="nickname" name="nickname" value="${member.nickname}" required>
				        <button type="button" class="btn btn-outline-secondary" id="checkNicknameBtn">중복 확인</button>
				    </div>
				    <div id="nicknameCheckResult" class="form-text mt-1"></div>
				</div>
			
				<!-- 🔄 프로필 이미지 변경 (JSTL 조건 처리 포함) -->
				<div class="mb-3">
				    <label class="form-label">프로필 이미지</label>
				
				    <div class="mb-2">
				        <c:choose>
						    <c:when test="${empty member.profileImage or member.profileImage eq 'default_profile.png'}">
						        <!-- ✅ 기본 이미지 출력 -->
						        <img id="profilePreview" 
						             src="${pageContext.request.contextPath}/resources/img/default-profile.png"
						             alt="기본 프로필 이미지" 
						             width="120" class="rounded-circle border shadow-sm" />
						    </c:when>
						    <c:otherwise>
						        <!-- ✅ 사용자 업로드 이미지 출력 -->
						        <img id="profilePreview" 
						             src="${pageContext.request.contextPath}/upload/profile/${member.profileImage}?v=${System.currentTimeMillis()}" 
						             alt="프로필 이미지"
						             width="120" class="rounded-circle border shadow-sm" />
						    </c:otherwise>
						</c:choose>
				    </div>
				
				    <!-- 이미지 업로드 input -->
				    <input type="file" class="form-control" name="profileImageFile" id="profileImageFile" accept="image/*" />
				</div>
				
				<!-- 🔘 기본 이미지로 초기화 버튼 -->
				<div class="mb-3">
				    <input type="hidden" id="resetProfileImage" name="resetProfileImage" value="false" />
				    <button type="button" class="btn btn-outline-danger" id="resetImageBtn">기본 이미지로 변경</button>
				</div>


			
			
			    <div class="mb-3">
			        <label for="email" class="form-label">이메일</label>
			        <input type="email" class="form-control" id="email" name="email" value="${member.email}" required>
			    </div>
			
			    <div class="mb-3">
				    <label for="phone" class="form-label">휴대폰 번호</label>
				    <div class="d-flex gap-2">
				        <!-- 앞자리 select 박스 -->
				        <select class="form-select" id="phone1" name="phone1" style="width: 100px;" required>
				            <option value="010" ${fn:contains(member.phone, '010') ? 'selected' : ''}>010</option>
				            <option value="011" ${fn:contains(member.phone, '011') ? 'selected' : ''}>011</option>
				            <option value="016" ${fn:contains(member.phone, '016') ? 'selected' : ''}>016</option>
				        </select>
				
				        <!-- 중간/끝 번호 -->
				        <input type="text" class="form-control" id="phone2" name="phone2"
				               value="${fn:split(member.phone, '-')[1]}" maxlength="4" required />
				        <input type="text" class="form-control" id="phone3" name="phone3"
				               value="${fn:split(member.phone, '-')[2]}" maxlength="4" required />
				    </div>
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

<!-- JS 파일 연결 -->
<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="<c:url value='/resources/js/memberEditForm.js' />"></script>

</body>
</html>
