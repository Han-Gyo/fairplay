<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>마이페이지</title>
    <meta charset="UTF-8">

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">

    <!-- Bootstrap (선택) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- 커스텀 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/myPage.css" />

    <!-- 커스텀 JS -->
    <script src="${pageContext.request.contextPath}/resources/js/myPage.js"></script>
</head>
<body>
<div style="display: flex; justify-content: center; align-items: center; min-height: calc(100vh - 80px);">
    <div class="glass-card">
        <h2>👤 마이페이지</h2>

        <!-- 프로필 이미지 (클릭 시 확대) -->
        <c:choose>
          <c:when test="${member.profileImage ne 'default_profile.png'}">
            <img src="${pageContext.request.contextPath}/upload/profile/${member.profileImage}"
                 alt="프로필 이미지" class="profile-img"
                 onclick="showImageModal(this.src)" />
          </c:when>
          <c:otherwise>
            <img src="${pageContext.request.contextPath}/resources/img/default-profile.png"
                 alt="기본 프로필 이미지" class="profile-img"
                 onclick="showImageModal(this.src)" />
          </c:otherwise>
        </c:choose>

        <!-- 모달 구조 -->
        <div id="imageModal" class="modal" onclick="hideImageModal()">
          <img id="modalImg" class="modal-content" />
        </div>

        <div class="info-line">실명: ${member.real_name}</div>
        <div class="info-line">아이디: ${member.user_id}</div>
        <div class="info-line">닉네임: ${member.nickname}</div>
        <div class="info-line">이메일: ${member.email}</div>
        <div class="info-line">전화번호: ${member.phone}</div>
        <div class="info-line">주소: ${member.address}</div>
        <div class="info-line">가입일: ${member.created_at}</div>
        <div class="info-line">회원 상태: ${member.status}</div>

        <div class="action-links">
            <a class="btn-custom" href="${pageContext.request.contextPath}/member/edit?id=${member.id}">정보 수정</a>

            <form action="${pageContext.request.contextPath}/member/deactivate" method="post"
                  onsubmit="return confirm('정말 탈퇴하시겠습니까?')">
                <input type="hidden" name="id" value="${member.id}" />
                <button type="submit" class="btn-custom btn-danger">회원 탈퇴</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
