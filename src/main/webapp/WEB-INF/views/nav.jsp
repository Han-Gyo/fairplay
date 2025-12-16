<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>

<link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css' rel='stylesheet' />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/locales-all.global.min.js'></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/nav.css">

<script src="${pageContext.request.contextPath}/resources/js/calendarModal.js"></script>

</head>
<body>

<div id="app-nav" class="navbar">
  <div class="left">
  <!-- 로고 -->
	<a class="navbar-brand d-flex align-items-center" href="${pageContext.request.contextPath}/">
	  <i class="fas fa-broom fa-lg me-2"></i> <!-- 빗자루 아이콘 -->
	  <span style="font-weight: 600; font-size: 1.3rem;">FairPlay</span>
	</a>

  <!-- Todo 드롭다운 -->
  <div class="dropdown">
    <a href="javascript:void(0);">🧹 Todo</a>
    <div class="dropdown-content">
      <a href="${pageContext.request.contextPath}/todos?groupId=${sessionScope.currentGroupId}">📋 Todo 목록</a>
      <a href="${pageContext.request.contextPath}/todos/myTodos">✅ MyTodo 목록</a>
      <c:if test="${sessionScope.role eq 'LEADER'}">
			  <a href="${pageContext.request.contextPath}/todos/create?groupId=${sessionScope.currentGroupId}">✅ Todo 등록</a>
			</c:if>
    </div>
  </div>

  <!-- History 드롭다운 -->
  <div class="dropdown">
      <a href="javascript:void(0);">📋 History</a>
      <div class="dropdown-content">
          <a href="${pageContext.request.contextPath}/history/all?groupId=${currentGroupId}">📋 전체 히스토리</a>
          <a href="${pageContext.request.contextPath}/history/create">📝 기록 등록</a>
      </div>
  </div>

   <!-- Wallet 드롭다운 -->
   <div class="dropdown">
       <a href="javascript:void(0);">💸 가계부</a>
       <div class="dropdown-content">
           <a href="${pageContext.request.contextPath}/wallet">💰 내 가계부</a>
           <a href="${pageContext.request.contextPath}/wallet/create">💸 작성하기</a>
       </div>
   </div>

   <!-- 그룹 드롭다운 -->
   <div class="dropdown">
      <a href="javascript:void(0);">👥 그룹</a>
      <div class="dropdown-content">
         <a href="${pageContext.request.contextPath}/group/create">🏠 그룹 등록</a>
         <a href="${pageContext.request.contextPath}/group/groups">👥 그룹 목록</a>
      </div>
   </div>
   
   <!-- 점수 드롭다운 -->
		<div class="dropdown">
	    <a href="javascript:void(0);">📊 점수</a>
	    <div class="dropdown-content">
	        <a href="${pageContext.request.contextPath}/history/monthly-score?group_id=1">📅 월간 점수 보기</a>
	     <!-- 추후: 전체 통계 페이지 추가도 고려 가능 -->
	    </div>
		</div>
				
		<!-- 필요 물품 드롭다운 추가 -->
		<c:if test="${not empty sessionScope.loginMember}">
		    <!-- 필요 물품 드롭다운 -->
	    <div class="dropdown">
	        <a href="javascript:void(0);">📦 필요 물품</a>
	        <div class="dropdown-content">
            <a href="${pageContext.request.contextPath}/needed/list?groupId=1">📋 전체 물품 목록</a>
            <a href="${pageContext.request.contextPath}/needed/add?groupId=1">📝 물품 등록</a>
	        </div>
	    </div>
		</c:if>
		
    </div>

	<div class="right">
	  <c:choose>
	  
	      <c:when test="${empty sessionScope.loginMember}">
          <a href="${pageContext.request.contextPath}/member/login">🔐 로그인</a>
          <a href="${pageContext.request.contextPath}/member/create">👤 회원가입</a>
          <a href="${pageContext.request.contextPath}/forgot/forgotId">🆔 아이디찾기</a>
          <a href="${pageContext.request.contextPath}/forgot">🔑 비밀번호 찾기</a>
	      </c:when>
	
	      <c:otherwise>
          <span style="color:pink; font-weight:bold;">
             ♥ ${sessionScope.loginMember.nickname}님 안녕하세요 ♥
          </span>
          <a href="${pageContext.request.contextPath}/mypage">🙋 마이페이지</a>
          <a href="javascript:void(0);" onclick="confirmLogout()">🚪 로그아웃</a>
          
	      </c:otherwise>
	  </c:choose>
	</div>
</div>

<div class="calendar-toggle">
  <a href="javascript:void(0);" onclick="openCalendarModal()">📅<p>Calendar</p></a>
</div>

<!-- 모달 영역 추가 -->
<!-- 단 하나의 calendarModal -->
<div id="calendarModal"
     style="display: none; position: fixed; z-index: 2000;
            top: 0; left: 0; width: 100%; height: 100%;
            overflow: hidden;
            background-color: rgba(0,0,0,0.5);">
  
  <div class="modal-content calendar-custom-modal"
  	style="
    position: absolute;
    top: 50%; left: 50%;
    transform: translate(-50%, -50%);
    background: white;
    width: 80%; max-width: 1000px;
    max-height: 90%;
    overflow-y: auto;
    padding: 30px;
    border-radius: 20px;
    box-shadow: 0 0 12px rgba(0,0,0,0.2);">
    
    <!-- 닫기 버튼 -->
    <span onclick="closeModal()"
          style="position:absolute; top:10px; right:20px;
                 font-size:20px; cursor:pointer;">❌</span>

    <!-- FullCalendar 본체 -->
    <div id="calendar-full" style="height: 400px;"></div>

    <!-- 날짜 클릭 시 todo 표시되는 영역 -->
    <div style="margin-top: 30px;">
      <h5>📋 <span class="modal-date">선택 날짜</span>의 할 일</h5>
      <ul id="todoList" style="padding-left: 20px;"></ul>
    </div>
    <div style="margin-top: 30px;">
		  <h5>🗓 <span class="modal-date">선택 날짜</span>의 일정</h5>
		  <div id="schedule-container" style="padding-left: 20px;"></div>
		</div>

    <hr />
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
          <!-- 날짜를 숨겨서 넘김 -->
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

<script>
  const contextPath = "${pageContext.request.contextPath}";
  console.log(contextPath);
</script>
</body>
</html>
