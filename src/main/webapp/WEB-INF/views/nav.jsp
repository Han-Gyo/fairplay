<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <!-- Bootswatch Minty 테마 -->
  <link href="https://bootswatch.com/5/minty/bootstrap.min.css" rel="stylesheet">

  <!-- Icons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

  <!-- Custom CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/nav.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/calendar.css">
</head>

<body>
<!-- 네비게이션 바 -->
<nav class="navbar navbar-expand-lg shadow-sm fixed-top">
  <div class="container-fluid">

    <!-- 로고 -->
    <a class="navbar-brand d-flex align-items-center fw-bold" href="${pageContext.request.contextPath}/">
      <img src="${pageContext.request.contextPath}/resources/img/logo.png" class="logo-img" alt="FairPlay 로고">
      airPlay
    </a>

    <!-- [수정] 모바일 해상도에서 우측에 닉네임만 표시 (d-lg-none) -->
    <c:if test="${not empty sessionScope.loginMember}">
      <div class="ms-auto d-lg-none me-2">
        <span class="text-warning fw-bold small">
          ${sessionScope.loginMember.nickname}님
        </span>
      </div>
    </c:if>

    <!-- 모바일 토글 (햄버거 버튼) -->
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <!-- 가운데 메뉴 및 통합 메뉴 -->
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav mx-auto fw-bold">
        <!-- Todo -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">집안일</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/todos?groupId=${sessionScope.currentGroupId}">집안일 목록</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/todos/myTodos">나의 집안일 목록</a></li>
            <c:if test="${sessionScope.role eq 'LEADER'}">
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/todos/create?groupId=${sessionScope.currentGroupId}">집안일 등록</a></li>
            </c:if>
          </ul>
        </li>

        <!-- History -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">히스토리</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/history/all?groupId=${currentGroupId}">전체 히스토리</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/history/create">기록 등록</a></li>
          </ul>
        </li>

        <!-- Wallet -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">가계부</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/wallet">내 가계부</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/wallet/create">작성하기</a></li>
          </ul>
        </li>

        <!-- 그룹 -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">그룹</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/group/create">그룹 등록</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/group/groups">그룹 목록</a></li>
          </ul>
        </li>

        <!-- 점수 -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">점수</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/history/monthly-score?groupId=${sessionScope.currentGroupId}">월간 점수 보기</a></li>
          </ul>
        </li>

        <!-- 필요 물품 -->
        <c:if test="${not empty sessionScope.loginMember}">
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">필요 물품</a>
            <ul class="dropdown-menu">
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/needed/list?groupId=${sessionScope.currentGroupId}">전체 물품 목록</a></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/needed/add?groupId=${sessionScope.currentGroupId}">물품 등록</a></li>
            </ul>
          </li>
        </c:if>

        <!-- [수정] 모바일용 통합 메뉴 (아이디/비번 찾기 포함) -->
        <li class="nav-item d-lg-none border-top mt-2 pt-2">
          <c:choose>
            <c:when test="${empty sessionScope.loginMember}">
              <a class="nav-link" href="${pageContext.request.contextPath}/member/login">로그인</a>
              <a class="nav-link" href="${pageContext.request.contextPath}/member/create">회원가입</a>
              <a class="nav-link text-muted small" href="${pageContext.request.contextPath}/forgot/forgotId">아이디 찾기</a>
              <a class="nav-link text-muted small" href="${pageContext.request.contextPath}/forgot">비밀번호 찾기</a>
            </c:when>
            <c:otherwise>
              <a class="nav-link text-info" href="${pageContext.request.contextPath}/mypage">마이페이지</a>
              <a class="nav-link text-danger" href="javascript:void(0);" onclick="confirmLogout()">로그아웃</a>
            </c:otherwise>
          </c:choose>
        </li>
      </ul>

      <!-- 오른쪽 로그인/회원/마이페이지 (데스크톱 전용) -->
      <ul class="navbar-nav fw-bold ms-auto d-none d-lg-flex">
        <c:choose>
          <c:when test="${empty sessionScope.loginMember}">
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/member/login">로그인</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/member/create">회원가입</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/forgot/forgotId">아이디 찾기</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/forgot">비밀번호 찾기</a></li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <span class="nav-link text-warning fw-bold">
                ${sessionScope.loginMember.nickname}님 안녕하세요
              </span>
            </li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/mypage">마이페이지</a></li>
            <li class="nav-item"><a class="nav-link" href="javascript:void(0);" onclick="confirmLogout()">로그아웃</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<!-- 본문 컨테이너 -->
<div id="mainContent">
  <!-- 캘린더 모달 및 기타 UI 요소는 이전과 동일하게 유지 -->
  <div id="calendarModal">
    <div class="modal-content calendar-custom-modal">
      <span class="close-calendar" onclick="closeModal()">
          <i class="fas fa-times"></i>
      </span>
      <div id="calendar-full"></div>
    </div>
  </div>

  <div id="calendar"></div>

  <div class="position-fixed bottom-0 end-0 m-3">
    <button type="button" class="btn btn-primary rounded-pill shadow-lg p-3" onclick="openCalendarModal()">
      <i class="fas fa-calendar-alt me-2"></i> Calendar
    </button>
  </div>

  <!-- 일정 상세 모달 -->
  <div class="modal fade" id="eventDetailModal" tabindex="-1"> 
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.2);">
        <div class="modal-header">
          <h5 class="modal-title fw-bold" style="color: #78C2AD;">일정 상세 정보</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" id="detailId">
          <div class="mb-3">
            <label class="form-label text-muted small">제목</label>
            <h4 id="detailTitle" class="fw-bold"></h4>
          </div>
          <hr>
          <div class="mb-3">
            <label class="form-label text-muted small">메모</label>
            <p id="detailMemo" class="p-3 bg-light rounded" style="min-height: 100px; white-space: pre-wrap;"></p>
          </div>
          <div class="mb-1">
            <label class="form-label text-muted small">날짜</label>
            <p id="detailDate" class="fw-bold text-primary"></p>
          </div>
        </div>
        <div class="modal-footer d-flex justify-content-between">
          <button type="button" class="btn btn-warning" onclick="updateEvent()">수정</button>
          <button type="button" class="btn btn-outline-danger rounded-pill" onclick="deleteEvent()">삭제</button>
          <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">닫기</button>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
<script>
const contextPath = "${pageContext.request.contextPath}";
function confirmLogout() {
    if(confirm("정말 로그아웃 하시겠습니까?")) {
        location.href = contextPath + "/member/logout";
    }
}
const navCollapse = document.getElementById('navbarNav');
const mainContent = document.getElementById('mainContent');
navCollapse.addEventListener('show.bs.collapse', () => { mainContent.classList.add('blurred'); });
navCollapse.addEventListener('hidden.bs.collapse', () => { mainContent.classList.remove('blurred'); });
</script>
<script src="${pageContext.request.contextPath}/resources/js/calendarCustom.js"></script>
</body>
</html>