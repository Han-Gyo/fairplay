<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${group.name} - 상세 정보</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css">
  <script src="https://unpkg.com/lucide@latest"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/groupDetail.css" />
</head>
<body class="bg-light" 
      data-context-path="${pageContext.request.contextPath}"
      data-msg="${msg}">

<div class="container py-5">
  <!-- 상단 헤더 -->
  <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
    <div>
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-1">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/group/groups" class="text-decoration-none">Groups</a></li>
          <li class="breadcrumb-item active">Detail</li>
        </ol>
      </nav>
      <h2 class="fw-bold m-0">${group.name}</h2>
    </div>
    <!-- 목록 버튼: 무채색 아웃라인으로 변경하여 시각적 부담 감소 -->
    <a href="${pageContext.request.contextPath}/group/groups" class="btn btn-outline-secondary btn-sm rounded-pill px-3 shadow-sm">
      <i data-lucide="list" class="size-xs me-1"></i> 목록으로
    </a>
  </div>

  <div class="row g-4">
    <!-- 왼쪽 컬럼: 콘텐츠 -->
    <div class="col-lg-8">
      <div class="card shadow-sm border-0 rounded-4 mb-4">
        <div class="card-body p-4">
          <!-- 배지 영역: 톤을 Primary로 통일 -->
          <div class="d-flex flex-wrap gap-2 mb-4">
            <!-- 멤버 배지: align-items-center 추가로 수직 정렬 수정 -->
            <span class="badge rounded-pill bg-primary px-3 py-2 d-inline-flex align-items-center">
              <i data-lucide="users" class="size-xs"></i> 
              <span class="lh-1">멤버 ${currentMemberCount}/${group.maxMember}</span>
            </span>
            
            <span class="badge rounded-pill bg-light text-secondary border px-3 py-2 d-inline-flex align-items-center">
              <i data-lucide="calendar" class="size-xs"></i> 
              <span class="lh-1">${group.formattedCreatedAt}</span>
            </span>

            <span class="badge rounded-pill ${group.publicStatus ? 'bg-info-subtle text-info border-info-subtle' : 'bg-warning-subtle text-warning border-warning-subtle'} border px-3 py-2 d-inline-flex align-items-center">
              <i data-lucide="${group.publicStatus ? 'unlock' : 'lock'}" class="size-xs"></i>
              <span class="lh-1">${group.publicStatus ? '공개' : '비공개'}</span>
            </span>
          </div>

          <!-- 이미지 -->
          <c:if test="${not empty group.profile_img}">
            <div class="mb-4 rounded-4 overflow-hidden border">
              <img class="img-fluid w-100 img-thumb" 
                   src="${pageContext.request.contextPath}/upload/${group.profile_img}"
                   data-full="${pageContext.request.contextPath}/upload/${group.profile_img}"
                   alt="Group Image" />
            </div>
          </c:if>

          <!-- 소개글 -->
          <div class="mb-5">
            <h6 class="fw-bold text-primary mb-3 text-uppercase small tracking-wider">Group Description</h6>
            <div class="description-box p-4 rounded-4 bg-light border-0">
              <p class="mb-0 text-dark lh-base">${empty group.description ? '등록된 소개가 없습니다.' : group.description}</p>
            </div>
          </div>

          <!-- 리더 한마디 -->
          <div class="mb-2">
            <h6 class="fw-bold text-primary mb-3 text-uppercase small tracking-wider">Leader's Note</h6>
            <div class="admin-comment-card p-4 rounded-4 position-relative overflow-hidden">
              <div class="position-relative z-1">
                <p class="mb-0 fw-medium">
                  <c:choose>
                    <c:when test="${not empty group.admin_comment}">
                      "${group.formattedAdminComment}"
                    </c:when>
                    <c:otherwise>
                      <span class="text-muted">작성된 메시지가 없습니다.</span>
                    </c:otherwise>
                  </c:choose>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 오른쪽 컬럼: 액션 -->
    <div class="col-lg-4">
      <div class="sticky-top" style="top: 20px;">
        
        <!-- 가입/참여 위젯 -->
        <div class="card shadow-sm border-0 rounded-4 mb-4">
          <div class="card-body p-4">
            <h6 class="fw-bold mb-4 text-center text-secondary">참여 정보</h6>
            
            <div class="d-grid gap-3">
              <c:choose>
                <c:when test="${empty loginMember}">
                  <a class="btn btn-primary btn-lg rounded-pill py-3 shadow-sm" href="${pageContext.request.contextPath}/member/setRedirect?redirectURI=/group/detail?id=${group.id}">
                    참여하려면 로그인
                  </a>
                </c:when>
                <c:when test="${isMember}">
                  <div class="p-3 bg-primary-subtle rounded-4 text-center text-primary mb-1 border border-primary-subtle">
                    <i data-lucide="check-circle" class="size-sm me-1"></i> 현재 활동 멤버입니다
                  </div>
                  <c:choose>
                    <c:when test="${loginMember.id == group.leaderId}">
                      <a class="btn btn-outline-primary rounded-pill py-2" href="${pageContext.request.contextPath}/groupmember/transferForm?groupId=${group.id}">
                        그룹장 위임 후 탈퇴
                      </a>
                    </c:when>
                    <c:otherwise>
                      <form action="${pageContext.request.contextPath}/groupmember/delete" method="post" onsubmit="return confirm('정말 탈퇴하시겠어요?');">
                        <input type="hidden" name="groupId" value="${group.id}" />
                        <input type="hidden" name="memberId" value="${loginMember.id}" />
                        <button type="submit" class="btn btn-outline-danger w-100 rounded-pill py-2">탈퇴하기</button>
                      </form>
                    </c:otherwise>
                  </c:choose>
                </c:when>
                <c:otherwise>
                  <c:choose>
                    <c:when test="${currentMemberCount >= group.maxMember}">
                      <button class="btn btn-secondary btn-lg rounded-pill py-3 disabled" disabled>정원 초과</button>
                    </c:when>
                    <c:otherwise>
                      <a class="btn btn-primary btn-lg rounded-pill py-3 shadow-sm pulse-animation" href="${pageContext.request.contextPath}/groupmember/create?groupId=${group.id}">
                        그룹 가입하기
                      </a>
                    </c:otherwise>
                  </c:choose>
                </c:otherwise>
              </c:choose>

              <!-- 멤버 목록: 중요도가 낮으므로 아웃라인 스타일 -->
              <c:if test="${group.publicStatus || (not empty loginMember && isMember)}">
                <a class="btn btn-outline-info rounded-pill py-2" href="${pageContext.request.contextPath}/groupmember/list?groupId=${group.id}">
                  멤버 명단 보기
                </a>
              </c:if>
            </div>
          </div>
        </div>

        <!-- 초대 코드: 배경색을 밝게 변경하여 톤 일치 -->
        <c:if test="${not empty loginMember && loginMember.id == group.leaderId}">
          <div class="card shadow-sm border-0 rounded-4 mb-4 bg-white">
            <div class="card-body p-4 text-center">
              <h6 class="fw-bold mb-3 small text-uppercase text-muted tracking-wide">Invite Code</h6>
              <div class="input-group mb-2">
                <input id="codeInput" class="form-control border-light bg-light text-center fw-bold" value="${group.code}" readonly type="password" style="letter-spacing: 0.3em;">
                <button class="btn btn-primary px-3" type="button" id="copyCodeBtn">복사</button>
              </div>
              <p class="x-small text-muted mb-0">그룹 멤버를 초대할 때 이 코드를 공유하세요.</p>
            </div>
          </div>

          <!-- 수정/삭제 버튼: 강조를 줄인 버튼 디자인 -->
          <div class="d-flex gap-2">
            <a class="btn btn-light border flex-grow-1 rounded-pill text-secondary" href="${pageContext.request.contextPath}/group/edit?id=${group.id}">수정</a>
            <button class="btn btn-light border flex-grow-1 rounded-pill text-danger" data-delete-id="${group.id}">삭제</button>
          </div>
        </c:if>
      </div>
    </div>
  </div>
</div>

<!-- 라이트박스 -->
<div id="imgLightbox" class="lightbox" aria-hidden="true">
  <button class="lightbox-close">&times;</button>
  <img id="lightboxImg" alt="확대 이미지" />
</div>

<script src="${pageContext.request.contextPath}/resources/js/groupDetail.js"></script>
</body>
</html>