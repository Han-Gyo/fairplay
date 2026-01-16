<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>그룹 상세 - Fairplay</title>
  <!-- Minty Theme -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css">
  <!-- Lucide Icons for better visuals -->
  <script src="https://unpkg.com/lucide@latest"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group.css" />
</head>
<body class="bg-light" 
      data-context-path="${pageContext.request.contextPath}"
      data-msg="${msg}">

<div class="container py-5">
  <!-- 상단 헤더 영역 -->
  <div class="d-flex justify-content-between align-items-end mb-4 border-bottom pb-3">
    <div>
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-1">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/group/groups" class="text-decoration-none">Groups</a></li>
          <li class="breadcrumb-item active">Detail</li>
        </ol>
      </nav>
      <h2 class="fw-bold text-primary m-0 display-6">${group.name}</h2>
    </div>
    <a href="${pageContext.request.contextPath}/group/groups" class="btn btn-outline-secondary btn-sm rounded-pill shadow-sm">
      <i data-lucide="arrow-left" class="size-sm"></i> 목록으로
    </a>
  </div>

  <div class="row g-4">
    <!-- 왼쪽 컬럼: 상세 정보 -->
    <div class="col-md-7">
      <div class="card shadow-sm border-0 rounded-4 mb-4 overflow-hidden">
        <div class="card-body p-4">
          <!-- 배지 영역 -->
          <div class="d-flex flex-wrap gap-2 mb-4">
            <c:set var="isFull" value="${currentMemberCount >= group.maxMember}" />
            <span class="badge bg-primary px-3 py-2 rounded-pill shadow-sm">
               <i data-lucide="users" class="size-xs me-1"></i> 멤버 ${currentMemberCount} / ${group.maxMember}
            </span>
            <span class="badge bg-info px-3 py-2 rounded-pill shadow-sm">
               <i data-lucide="calendar" class="size-xs me-1"></i> ${group.formattedCreatedAt}
            </span>
            <span class="badge ${group.publicStatus ? 'bg-success' : 'bg-warning'} px-3 py-2 rounded-pill shadow-sm text-white">
               <i data-lucide="${group.publicStatus ? 'unlock' : 'lock'}" class="size-xs me-1"></i>
               ${group.publicStatus ? '공개 그룹' : '비공개 그룹'}
            </span>
          </div>

          <!-- 소개 내용 -->
          <div class="info-section mb-4">
            <h5 class="section-title"><i data-lucide="info" class="me-2 text-primary"></i>그룹 소개</h5>
            <div class="description-box p-3 rounded-3 bg-white border">
              <p class="text-dark mb-0" style="white-space: pre-wrap;">${empty group.description ? '작성된 설명이 없습니다.' : group.description}</p>
            </div>
          </div>

          <!-- 대표 이미지 -->
          <c:if test="${not empty group.profile_img}">
            <div class="info-section mb-4">
              <h5 class="section-title"><i data-lucide="image" class="me-2 text-primary"></i>대표 이미지</h5>
              <div class="text-center bg-light p-2 rounded-3">
                <img class="img-thumb" 
                     src="${pageContext.request.contextPath}/upload/${group.profile_img}"
                     data-full="${pageContext.request.contextPath}/upload/${group.profile_img}"
                     alt="대표 이미지" />
              </div>
            </div>
          </c:if>

          <!-- 리더 한마디 -->
          <div class="info-section">
            <h5 class="section-title"><i data-lucide="message-circle" class="me-2 text-primary"></i>리더 한마디</h5>
            <div class="admin-comment-card p-4 rounded-4 position-relative">
              <i data-lucide="quote" class="quote-icon text-primary opacity-25"></i>
              <div class="position-relative z-1">
                <c:choose>
                  <c:when test="${not empty group.admin_comment}">
                    <c:out value="${group.formattedAdminComment}" escapeXml="false"/>
                  </c:when>
                  <c:otherwise>
                    <span class="text-muted italic text-center d-block">"아직 작성된 한마디가 없어요."</span>
                  </c:otherwise>
                </c:choose>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 오른쪽 컬럼: 액션/관리 -->
    <div class="col-md-5">
      <!-- 관리자 전용 초대 코드 -->
      <c:if test="${not empty loginMember && loginMember.id == group.leaderId}">
        <div class="card shadow-sm border-0 rounded-4 mb-4 bg-primary text-white">
          <div class="card-body p-4">
            <h5 class="fw-bold mb-3 d-flex align-items-center">
              <i data-lucide="key" class="me-2"></i> 초대 코드 관리
            </h5>
            <div class="input-group mb-2">
              <input id="codeInput" class="form-control border-0 bg-white" value="${group.code}" readonly type="password">
              <button class="btn btn-dark shadow-none" type="button" id="copyCodeBtn">복사</button>
            </div>
            <p class="small mb-0 opacity-75">이 코드를 공유하면 비공개 그룹에도 가입할 수 있습니다.</p>
          </div>
        </div>
      </c:if>

      <!-- 활동/가입 버튼 카드 -->
      <div class="card shadow-sm border-0 rounded-4 sticky-top" style="top: 20px;">
        <div class="card-body p-4 text-center">
          <div class="mb-4">
             <div class="avatar-placeholder mx-auto mb-3">
                <i data-lucide="play-circle" class="size-lg text-primary"></i>
             </div>
             <h5 class="fw-bold text-secondary">그룹 활동 메뉴</h5>
          </div>

          <div class="d-grid gap-3">
            <c:choose>
              <c:when test="${empty loginMember}">
                <a class="btn btn-primary btn-lg rounded-pill py-3 shadow-sm" href="${pageContext.request.contextPath}/member/setRedirect?redirectURI=/group/detail?id=${group.id}">
                  <i data-lucide="log-in" class="me-2"></i>로그인 후 가입하기
                </a>
              </c:when>
              <c:when test="${isMember}">
                <div class="p-3 bg-light rounded-pill border text-primary fw-bold mb-1">
                  <i data-lucide="check-circle" class="me-1"></i> 가입 완료된 멤버입니다
                </div>
                <c:choose>
                  <c:when test="${loginMember.id == group.leaderId}">
                    <a class="btn btn-outline-warning rounded-pill shadow-sm" href="${pageContext.request.contextPath}/groupmember/transferForm?groupId=${group.id}">
                      리더 권한 위임/탈퇴
                    </a>
                  </c:when>
                  <c:otherwise>
                    <form action="${pageContext.request.contextPath}/groupmember/delete" method="post" onsubmit="return confirm('정말 탈퇴하시겠어요?');">
                      <input type="hidden" name="groupId" value="${group.id}" />
                      <input type="hidden" name="memberId" value="${loginMember.id}" />
                      <button type="submit" class="btn btn-outline-danger w-100 rounded-pill shadow-sm">그룹 탈퇴하기</button>
                    </form>
                  </c:otherwise>
                </c:choose>
              </c:when>
              <c:otherwise>
                <c:choose>
                  <c:when test="${isFull}">
                    <button class="btn btn-secondary btn-lg rounded-pill py-3 shadow-sm" disabled>정원 초과</button>
                  </c:when>
                  <c:otherwise>
                    <a class="btn btn-primary btn-lg rounded-pill py-3 shadow-sm pulse-animation" href="${pageContext.request.contextPath}/groupmember/create?groupId=${group.id}">
                      이 그룹 가입 신청
                    </a>
                  </c:otherwise>
                </c:choose>
              </c:otherwise>
            </c:choose>

            <c:choose>
              <c:when test="${group.publicStatus}">
                <a class="btn btn-info text-white btn-lg rounded-pill py-3 shadow-sm" href="${pageContext.request.contextPath}/groupmember/list?groupId=${group.id}">
                  <i data-lucide="users" class="me-2"></i>멤버 목록 보기
                </a>
              </c:when>
              <c:otherwise>
                <c:if test="${not empty loginMember && isMember}">
                  <a class="btn btn-info text-white btn-lg rounded-pill py-3 shadow-sm" href="${pageContext.request.contextPath}/groupmember/list?groupId=${group.id}">
                    <i data-lucide="users" class="me-2"></i>멤버 목록 보기
                  </a>
                </c:if>
              </c:otherwise>
            </c:choose>

            <c:if test="${not empty loginMember && loginMember.id == group.leaderId}">
              <hr class="my-3">
              <div class="d-flex gap-2">
                <a class="btn btn-outline-info flex-grow-1 rounded-pill" href="${pageContext.request.contextPath}/group/edit?id=${group.id}">
                  정보 수정
                </a>
                <button class="btn btn-outline-danger flex-grow-1 rounded-pill" data-delete-id="${group.id}">
                  그룹 삭제
                </button>
              </div>
            </c:if>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- 라이트박스 생략 (기존 유지) -->
<div id="imgLightbox" class="lightbox" aria-hidden="true">
  <button class="lightbox-close">×</button>
  <img id="lightboxImg" alt="확대 이미지" />
</div>

<script src="${pageContext.request.contextPath}/resources/js/group.js"></script>
<script>
  // 아이콘 초기화
  lucide.createIcons();
</script>
</body>
</html>