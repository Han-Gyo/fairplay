<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 정보 수정</title>

    <!-- Bootswatch Minty 테마 -->
    <link href="https://bootswatch.com/5/minty/bootstrap.min.css" rel="stylesheet">

    <!-- FontAwesome 아이콘 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
</head>

<body class="bg-light" data-context-path="${pageContext.request.contextPath}">

<div class="container mt-5">
    <div class="card shadow-lg border-0">
        <!-- 헤더: Minty primary 색상 -->
        <div class="card-header bg-primary text-white d-flex align-items-center">
            <i class="fas fa-user-edit me-2"></i>
            <h4 class="mb-0">회원 정보 수정</h4>
        </div>
        
        <div class="card-body">
            <!-- 회원정보 수정 폼 -->
            <form id="editForm" action="${pageContext.request.contextPath}/mypage/update" method="post" enctype="multipart/form-data">
                <input type="hidden" name="id" value="${member.id}">
                <input type="hidden" name="from" value="mypage" />

                <!-- 이름 -->
                <div class="mb-3">
                    <label for="real_name" class="form-label fw-bold">이름 (실명)</label>
                    <input type="text" class="form-control" id="real_name" name="real_name" value="${member.real_name}" required />
                </div>

                <!-- 닉네임 -->
                <div class="mb-3">
                    <label for="nickname" class="form-label fw-bold">
                        <i class="fas fa-user-tag me-1 text-success"></i> 닉네임
                    </label>
                    <div class="input-group">
                        <input type="text" class="form-control" id="nickname" name="nickname" value="${member.nickname}" required>
                        <button type="button" class="btn btn-success" id="checkNicknameBtn">
                            <i class="fas fa-search"></i> 중복 확인
                        </button>
                    </div>
                    <!-- 결과 메시지 영역 -->
                    <div id="nicknameCheckResult" class="mt-2"></div>
                </div>


                <!-- 프로필 이미지 -->
                <div class="mb-3">
                    <label class="form-label fw-bold">프로필 이미지</label>
                    <div class="mb-2">
                        <c:choose>
                            <c:when test="${empty member.profileImage or member.profileImage eq 'default_profile.png'}">
                                <img id="profilePreview"
                                     src="${pageContext.request.contextPath}/resources/img/default-profile.png"
                                     alt="기본 프로필 이미지"
                                     width="120" class="rounded-circle border shadow-sm" />
                            </c:when>
                            <c:otherwise>
                                <img id="profilePreview"
                                     src="${pageContext.request.contextPath}/upload/profile/${member.profileImage}?v=${System.currentTimeMillis()}"
                                     alt="프로필 이미지"
                                     width="120" class="rounded-circle border shadow-sm" />
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <input type="file" class="form-control" name="profileImageFile" id="profileImageFile" accept="image/*" />
                </div>

                <!-- 기본 이미지로 초기화 -->
                <div class="mb-3">
                    <input type="hidden" id="resetProfileImage" name="resetProfileImage" value="false" />
                    <button type="button" class="btn btn-outline-danger" id="resetImageBtn">기본 이미지로 변경</button>
                </div>

                <!-- 이메일 -->
				<div class="mb-3">
				    <label for="email" class="form-label fw-bold">
				        <i class="fas fa-envelope me-1 text-primary"></i> 이메일
				    </label>
				    <div class="input-group">
				        <input type="email" class="form-control" id="email" name="email" value="${member.email}" required>
				        <!-- 기존 이메일 값 hidden으로 전달 -->
				        <input type="hidden" id="originalEmail" value="${member.email}">
				        <!-- 중복 확인 버튼 -->
						<button type="button" class="btn btn-outline-primary" id="checkEmailBtn" disabled>
						    <i class="fas fa-search"></i> 중복 확인
						</button>
						<!-- 인증번호 발송 버튼 (중복검사 통과 시 활성화) -->
						<button type="button" class="btn btn-primary" id="sendEmailCodeBtn" disabled>
						    <i class="fas fa-paper-plane"></i> 인증번호 발송
						</button>
				    </div>
				    <div class="input-group mt-2">
				        <input type="text" class="form-control" id="emailCode" placeholder="인증번호 입력">
				        <button type="button" class="btn btn-success" id="verifyEmailCodeBtn">
				            <i class="fas fa-check-circle"></i> 인증 확인
				        </button>
				    </div>
				    <!-- 결과 메시지 영역 -->
				    <div id="emailCheckResult" class="mt-2"></div>
				</div>



                <!-- 휴대폰 번호 -->
                <div class="mb-3">
                    <label for="phone" class="form-label fw-bold">휴대폰 번호</label>
                    <div class="d-flex gap-2">
                        <select class="form-select" id="phone1" name="phone1" style="width: 100px;" required>
                            <option value="010" ${fn:contains(member.phone, '010') ? 'selected' : ''}>010</option>
                            <option value="011" ${fn:contains(member.phone, '011') ? 'selected' : ''}>011</option>
                            <option value="016" ${fn:contains(member.phone, '016') ? 'selected' : ''}>016</option>
                        </select>
                        <input type="text" class="form-control" id="phone2" name="phone2"
                               value="${fn:split(member.phone, '-')[1]}" maxlength="4" required />
                        <input type="text" class="form-control" id="phone3" name="phone3"
                               value="${fn:split(member.phone, '-')[2]}" maxlength="4" required />
                    </div>
                </div>

                <!-- 주소 -->
                <div class="mb-3">
                    <label for="address" class="form-label fw-bold">주소</label>
                    <div class="input-group mb-2">
                        <input type="text" id="postcode" class="form-control" placeholder="우편번호" readonly style="max-width:150px;">
                        <button type="button" class="btn btn-outline-primary" onclick="execDaumPostcode()">주소 검색</button>
                    </div>
                    <input type="text" id="roadAddress" class="form-control mb-2" placeholder="도로명 주소" readonly>
                    <input type="text" id="detailAddress" class="form-control" placeholder="상세 주소">
                    <input type="hidden" id="address" name="address" value="${member.address}" />
                </div>

                <input type="hidden" name="status" value="${member.status}" />

                <!-- 버튼 -->
                <div class="d-flex justify-content-between mt-4">
                    <button type="submit" class="btn btn-success">수정 완료</button>
                    <a href="/fairplay/member/members" class="btn btn-secondary">목록으로</a>
                </div>
            </form>

			<!-- 비밀번호 변경 -->
			<hr class="my-4">
			<h5 class="text-primary"><i class="fas fa-key me-2"></i>비밀번호 변경</h5>
			<form id="pwChangeForm" action="${pageContext.request.contextPath}/mypage/changePw" method="post">
			    <div class="mb-3">
			        <label for="currentPassword" class="form-label fw-bold">현재 비밀번호</label>
			        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required />
			    </div>
			    <div class="mb-3">
			        <label for="newPassword" class="form-label fw-bold">새 비밀번호</label>
			        <input type="password" class="form-control" id="newPassword" name="newPassword" required />
			        <!-- 안내 문구 -->
			        <div class="form-text text-muted">
			            비밀번호는 8~16자의 영문 소문자, 숫자, 특수문자를 포함해야 합니다.
			        </div>
			    </div>
			    <div class="mb-3">
			        <label for="confirmPassword" class="form-label fw-bold">새 비밀번호 확인</label>
			        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required />
			        <!-- 안내 문구 -->
			        <div class="form-text text-muted">
			            새 비밀번호와 동일하게 입력해주세요.
			        </div>
			    </div>
			    <!-- 결과 메시지 영역 -->
			    <div id="pwChangeResult" class="mt-2"></div>
			    <div class="d-flex justify-content-end">
			        <button type="submit" class="btn btn-warning">비밀번호 변경</button>
			    </div>
			</form>

        </div>
    </div>
</div>

<!-- JS -->
<script>
    const contextPath = '${pageContext.request.contextPath}';
</script>
<script src="<c:url value='/resources/js/memberEditForm.js' />"></script>

<!-- Daum 주소 API -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

</body>
</html>