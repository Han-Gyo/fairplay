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
<nav class="navbar navbar-expand-lg shadow-sm fixed-top">
  <div class="container-fluid">

    <!-- 로고 -->
    <a class="navbar-brand d-flex align-items-center fw-bold" href="${pageContext.request.contextPath}/">
      <img src="${pageContext.request.contextPath}/resources/img/logo.png" class="logo-img" alt="FairPlay 로고">
      airPlay
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
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">Todo</a>
          <ul class="dropdown-menu">
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/todos?groupId=${sessionScope.currentGroupId}">Todo 목록</a></li>
            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/todos/myTodos">MyTodo 목록</a></li>
            <c:if test="${sessionScope.role eq 'LEADER'}">
              <li><a class="dropdown-item" href="${pageContext.request.contextPath}/todos/create?groupId=${sessionScope.currentGroupId}">Todo 등록</a></li>
            </c:if>
          </ul>
        </li>

        <!-- History -->
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">History</a>
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
      </ul>
    </div>

      <!-- 오른쪽 로그인/회원/마이페이지 -->
      <div class="nav-right-group">
	      <ul class="navbar-nav ms-auto fw-bold">
	        <c:choose>
	          <c:when test="${empty sessionScope.loginMember}">
	            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/member/login">로그인</a></li>
	            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/member/create">회원가입</a></li>
	            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/forgot/forgotId">아이디찾기</a></li>
	            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/forgot">비밀번호 찾기</a></li>
	          </c:when>
	          <c:otherwise>
	            <li class="nav-item">
	              <span class="nav-link text-warning fw-bold">
	                ♥ ${sessionScope.loginMember.nickname}님 안녕하세요 ♥
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


<!-- 커스텀 캘린더 모달 -->
<div id="calendarModal">
  <div class="modal-content calendar-custom-modal">
    <span class="close-calendar" onclick="closeModal()">
        <i class="fas fa-times"></i>
    </span>
    
    <div id="calendar-full"></div>
    
  </div>
</div>

<div id="calendar"></div>

<!-- 일정 등록 모달 -->
<div class="position-fixed bottom-0 end-0 m-3">
  <button type="button" class="btn btn-primary rounded-pill shadow-lg p-3" onclick="openCalendarModal()">
    <i class="fas fa-calendar-alt me-2"></i> Calendar
  </button>
</div>

<div class="modal fade" id="eventDetailModal" tabindex="-1"> 
	<div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius: 20px; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.2);">
      <div class="modal-header">
        <h5 class="modal-title fw-bold" style="color: #78C2AD;">📅일정 상세 정보
        	<span id="detailGroupName" class="badge rounded-pill ms-2" style="font-size: 0.6em; display: none;"></span>
        </h5>
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
        <button type="button" class="btn btn-outline-danger rounded-pill" onclick="deleteEvent()">
          <i class="fas fa-trash-alt me-1"></i> 삭제
        </button>
        <button type="button" class="btn btn-secondary rounded-pill" data-bs-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="scheduleModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
			<form id="scheduleForm">
			    <input type="hidden" id="editScheduleId" name="id">
			    
			    <div class="modal-header">
			        <h5 class="modal-title" id="scheduleModalLabel">📌 일정 등록</h5>
			        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
			    </div>
			    
			    <div class="modal-body">
			        <input type="hidden" name="date" id="selectedDate" />
			        <div class="mb-3">
			            <label class="form-label">일정 제목</label>
			            <input type="text" class="form-control" name="title" placeholder="무슨 일정인가요?" required>
			        </div>
			        <div class="mb-3">
			            <label class="form-label">메모</label>
			            <textarea class="form-control" name="memo" rows="3" placeholder="상세 내용을 적어주세요."></textarea>
			        </div>
			        <div class="mb-3">
			            <label class="form-label">공개 범위</label>
			            <select class="form-select" name="visibility" id="visibilitySelect">
			                <option value="private">🔒 개인일정</option>
			                <option value="group">👥 그룹공유</option>
			            </select>
			        </div>
			        
			        <div class="mb-3" id="groupSelectSection" style="display: none;">
							  <label class="form-label text-primary fw-bold">공유할 그룹 선택</label>
							  <select class="form-select" name="groupId" id="groupIdSelect">
							    <option value="">-- 그룹을 선택해주세요 --</option>
							  </select>
							</div>
			    </div>
			    
			    <div class="modal-footer">
			        <button type="submit" id="submitBtn" class="btn btn-primary w-100">일정 등록하기</button>
			    </div>
			</form>
    </div>
  </div>
</div>
<div class="modal fade" id="dailySummaryModal" tabindex="-1">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content" style="border-radius: 20px;">
      <div class="modal-header border-0">
        <h5 class="modal-title fw-bold text-primary" id="summaryDateTitle">2025-08-09 일상</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <h6 class="fw-bold mb-2">📌 일정</h6>
        <div id="summaryScheduleList" class="list-group mb-4">
          </div>
        
        <h6 class="fw-bold mb-2">✅ Todo</h6>
        <div id="summaryTodoList" class="list-group mb-3">
          </div>
      </div>
      <div class="modal-footer border-0">
        <button type="button" class="btn btn-primary w-100 rounded-pill" onclick="openRegisterModalFromSummary()">
          <i class="fas fa-plus me-1"></i> 새 일정 등록하기
        </button>
      </div>
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
  
$(document).ready(function() {
	// 1. 공개 범위 변경 이벤트 감지
  $(document).on('change', '#visibilitySelect', function() {
    const selectedVal = $(this).val();
    console.log("공주님, 선택하신 범위는:", selectedVal);

    if (selectedVal === 'group') {
      $('#groupSelectSection').slideDown(200);
      fetchMyGroups(); // 그룹 목록 불러오기
    } else {
      $('#groupSelectSection').slideUp(200);
      $('#groupIdSelect').val(''); // 값 초기화
    }
  });

	// 2. 그룹 목록 가져오는 함수
	function fetchMyGroups() {
	  const $select = $('#groupIdSelect');
	  
	  $.ajax({
	    url: contextPath + "/todos/api/myGroups",
	    type: "GET",
	    success: function(data) {
	      $select.empty(); 
	      $select.append('<option value="">-- 그룹을 선택해주세요 --</option>');
	      
	      if (data && data.length > 0) {
	        let htmlOptions = "";
	        data.forEach(function(group) {
	          htmlOptions += '<option value="' + group.id + '">' + group.name + '</option>';
	        });
	        
	        $select.append(htmlOptions);
	        $select.val(""); 
	      }
	    }
	  });
	}
});
</script>
<script src="${pageContext.request.contextPath}/resources/js/calendarCustom.js"></script>
</body>
</html>