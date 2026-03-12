<!-- myPage.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/myPage.css" />
</head>

<div class="mypage-container">
    <div class="glass-card">
        <h3 class="text-center mb-4">마이페이지</h3>

        <!-- 프로필 이미지 섹션 -->
        <div class="profile-img-container">
            <c:choose>
                <c:when test="${member.profileImage ne 'default_profile.png'}">
                    <img src="${pageContext.request.contextPath}/upload/profile/${member.profileImage}"
                         alt="Profile" class="profile-img"
                         onclick="showImageModal(this.src)" />
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/resources/img/default-profile.png"
                         alt="Default Profile" class="profile-img"
                         onclick="showImageModal(this.src)" />
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 상세 정보 리스트 -->
        <div class="info-group"><span class="info-label">실명</span> ${member.real_name}</div>
        <div class="info-group"><span class="info-label">아이디</span> ${member.user_id}</div>
        <div class="info-group"><span class="info-label">닉네임</span> ${member.nickname}</div>
        <div class="info-group"><span class="info-label">이메일</span> ${member.email}</div>
        <div class="info-group"><span class="info-label">전화번호</span> ${member.phone}</div>
        <div class="info-group"><span class="info-label">주소</span> ${member.address}</div>
        <div class="info-group"><span class="info-label">가입일</span> ${member.createdAtFormatted}</div>
        <div class="info-group"><span class="info-label">회원 상태</span> ${member.status}</div>

        <!-- 하단 버튼 영역 -->
        <div class="action-links">
            <!-- 정보 수정 버튼 -->
            <form action="${pageContext.request.contextPath}/member/edit" method="get">
                <input type="hidden" name="id" value="${member.id}" />
                <button type="submit" class="btn btn-primary action-btn">정보 수정</button>
            </form>

            <!-- 회원 탈퇴 버튼 -->
            <!-- 확인 문구를 더 구체적으로 안내 -->
            <form action="${pageContext.request.contextPath}/member/deactivate" method="post"
                  onsubmit="return confirm('정말 탈퇴하시겠습니까?\n- 혼자 있는 그룹은 함께 삭제됩니다.\n- 리더인 그룹은 자동 위임 후 탈퇴됩니다.\n- 가입된 모든 그룹은 자동 탈퇴 처리됩니다.')">
                <input type="hidden" name="id" value="${member.id}" />
                <button type="submit" class="btn btn-outline-danger action-btn">회원 탈퇴</button>
            </form>
        </div>
    </div>
</div>

<!-- 이미지 확대 모달 -->
<div id="imageModal" onclick="this.style.display='none'">
    <img id="modalImg" src="" alt="Enlarged" />
</div>

<script>
    /**
     * 이미지 확대 모달 제어
     */
    function showImageModal(src) {
        const modal = document.getElementById('imageModal');
        const modalImg = document.getElementById('modalImg');
        modal.style.display = 'flex';
        modalImg.src = src;
    }
</script>