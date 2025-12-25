<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
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
<nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm fixed-top">
  <div class="container-fluid">

    <!-- 로고 -->
    <a class="navbar-brand d-flex align-items-center fw-bold" href="${pageContext.request.contextPath}/">
      <i class="fas fa-broom fa-lg me-2"></i>
      FairPlay
    </a>

    <!-- 모바일 토글 -->
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <!-- 메뉴 -->
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav me-auto fw-bold">

        <!-- Todo -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">🧹 Todo</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/todos?groupId=${sessionScope.currentGroupId}">📋 Todo 목록</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/todos/myTodos">✅ MyTodo 목록</a></li>
            <c:if test="${sessionScope.role eq 'LEADER'}">
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/todos/create?groupId=${sessionScope.currentGroupId}">✅ Todo 등록</a></li>
            </c:if>
          </ul>
        </li>

        <!-- History -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">📋 History</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/history/all?groupId=${currentGroupId}">📋 전체 히스토리</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/history/create">📝 기록 등록</a></li>
          </ul>
        </li>

        <!-- Wallet -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">💸 가계부</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/wallet">💰 내 가계부</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/wallet/create">💸 작성하기</a></li>
          </ul>
        </li>

        <!-- 그룹 -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">👥 그룹</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/group/create">🏠 그룹 등록</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/group/groups">👥 그룹 목록</a></li>
          </ul>
        </li>
                <!-- 점수 -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">📊 점수</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/history/monthly-score?groupId=${sessionScope.currentGroupId}">📅 월간 점수 보기</a></li>
          </ul>
        </li>

        <!-- 필요 물품 -->
        <c:if test="${not empty sessionScope.loginMember}">
          <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">📦 필요 물품</a>
            <ul class="dropdown-menu">
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/needed/list?groupId=${sessionScope.currentGroupId}">📋 전체 물품 목록</a></li>
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/needed/add?groupId=${sessionScope.currentGroupId}">📝 물품 등록</a></li>
            </ul>
          </li>
        </c:if>
      </ul>

      <!-- 오른쪽 로그인/회원/마이페이지 -->
      <ul class="navbar-nav ms-auto fw-bold">
        <c:choose>
          <c:when test="${empty sessionScope.loginMember}">
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/member/login">🔐 로그인</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/member/create">👤 회원가입</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/forgot/forgotId">🆔 아이디찾기</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/forgot">🔑 비밀번호 찾기</a></li>
          </c:when>
          <c:otherwise>
            <li class="nav-item">
              <span class="nav-link text-warning fw-bold">
                ♥ ${sessionScope.loginMember.nickname}님 안녕하세요 ♥
              </span>
            </li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/mypage">🙋 마이페이지</a></li>
            <li class="nav-item"><a class="nav-link" href="javascript:void(0);" onclick="confirmLogout()">🚪 로그아웃</a></li>
          </c:otherwise>
        </c:choose>
      </ul>
    </div>
  </div>
</nav>

<!-- 캘린더 토글 버튼 -->
<div class="position-fixed bottom-0 end-0 m-3">
  <button type="button" class="btn btn-primary rounded-pill shadow"
          onclick="openCalendarModal()">
    📅 Calendar
  </button>
</div>

<!-- 커스텀 캘린더 모달 -->
<div id="calendarModal" 
	style="display:none; position:fixed; z-index:2000; 
		top:0; left:0; width:100%; height:100%; 
		background-color:rgba(0,0,0,0.4); backdrop-filter: blur(5px);">
  <div class="modal-content calendar-custom-modal">
    <span class="close-calendar" onclick="closeModal()">
        <i class="fas fa-times"></i>
    </span>
    
    <div id="calendar-full"></div>
    
    <div class="row mt-4">
      <div class="col-md-6">
        <h5 class="fw-bold"><i class="fas fa-check-circle text-primary me-2"></i> 할 일</h5>
        <ul id="todoList">
            <li class="text-muted">날짜를 클릭해 일정을 확인하세요!</li>
        </ul>
      </div>
      <div class="col-md-6">
        <h5 class="fw-bold"><i class="fas fa-calendar-alt text-info me-2"></i> 상세 일정</h5>
        <div id="schedule-container"></div>
      </div>
    </div>
  </div>
</div>

<div id="calendar"></div>

<!-- 일정 등록 모달 -->
<div class="modal fade" id="scheduleModal" tabindex="-1" aria-labelledby="scheduleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form method="post" id="scheduleForm">
        <div class="modal-header">
          <h5 class="modal-title" id="scheduleModalLabel">📌 일정 등록</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
        </div>
        <div class="modal-body">
          <input type="hidden" name="date" id="selectedDate" />
          <div class="mb-3">
            <label class="form-label">제목</label>
            <input type="text" class="form-control" name="title" required>
          </div>
          <div class="mb-3">
            <label class="form-label">메모</label>
            <textarea class="form-control" name="memo" rows="3"></textarea>
          </div>
          <div class="mb-3">
            <label class="form-label">공개 여부</label>
            <select class="form-select" name="visibility">
              <option value="PRIVATE">🔒 개인일정</option>
              <option value="GROUP">👥 그룹공유</option>
            </select>
          </div>
        </div>
        <div class="modal-footer">
          <button type="submit" class="btn btn-primary">등록</button>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        </div>
      </form>
    </div>
  </div>
</div>


<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
<script>
  // 전역 변수 설정
  const contextPath = "${pageContext.request.contextPath}";
  
  // 로그아웃 컨펌 함수 (필요하면 추가)
  function confirmLogout() {
      if(confirm("정말 로그아웃 하시겠습니까?")) {
          location.href = contextPath + "/member/logout";
      }
  }
</script>
<script src="${pageContext.request.contextPath}/resources/js/calendarCustom.js"></script>
</body>
</html>