<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- 
  수정 사항:
  1. nav.jsp에 이미 html, head, body 태그 및 Bootstrap 라이브러리가 포함되어 있으므로 
     본 파일에서는 본문(Content) 위주로 구성함.
  2. nav.jsp의 fixed-top 네비게이션 바 높이를 고려하여 여백(padding-top) 추가.
  3. 이모티콘 제거 및 주석으로 코드 정리.
--%>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!-- 커스텀 CSS (nav.jsp 로드 이후에 위치하여 마이페이지 전용 스타일 적용) -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/myPage.css" />

<style>
    /* 네비게이션 바(fixed-top)에 가려지지 않도록 패딩 추가 */
    .mypage-container {
        padding-top: 100px;
        padding-bottom: 50px;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
    }
    
    .glass-card {
        background: #fff;
        border-radius: 12px;
        padding: 30px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        width: 100%;
        max-width: 550px;
    }

    .profile-img-container {
        text-align: center;
        margin-bottom: 25px;
    }

    .profile-img {
        width: 130px;
        height: 130px;
        border-radius: 50%;
        object-fit: cover;
        cursor: pointer;
        border: 3px solid #78c2ad; /* Minty 테마 포인트 컬러 사용 */
        transition: 0.3s;
    }

    .info-group {
        margin-bottom: 15px;
        border-bottom: 1px solid #f1f1f1;
        padding-bottom: 8px;
    }

    .info-label {
        font-weight: bold;
        color: #78c2ad;
        width: 100px;
        display: inline-block;
    }

    .action-links {
        margin-top: 30px;
        display: flex;
        gap: 15px;
        justify-content: center;
    }

    /* 모달 기본 스타일 */
    #imageModal {
        display: none;
        position: fixed;
        z-index: 3000; /* nav.jsp의 z-index보다 높게 설정 */
        top: 0; left: 0; width: 100%; height: 100%;
        background: rgba(0,0,0,0.8);
        justify-content: center;
        align-items: center;
    }
    #modalImg { max-width: 90%; max-height: 90%; }
</style>

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
		    <form action="${pageContext.request.contextPath}/member/deactivate" method="post"
		          onsubmit="return confirm('정말 탈퇴하시겠습니까?')">
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