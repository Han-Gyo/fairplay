<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<!-- FullCalendar Core -->
<link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.css' rel='stylesheet' />
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>
<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/locales-all.global.min.js'></script>


<style>
    .navbar {
        background-color: #4a90e2;
        color: white;
        padding: 10px 0;
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin: 0;
        font-family: 'Segoe UI', sans-serif;
        
        position: fixed;
		    top: 0;
		    left: 0;
		    width: 100%;
		    z-index: 1000;
    }

    .navbar a {
        color: white;
        text-decoration: none;
        margin: 0 12px;
        font-weight: bold;
        position: relative;
    }

    .navbar a:hover {
        text-decoration: underline;
    }

    .navbar .left,
    .navbar .right {
        display: flex;
        align-items: center;
        position: relative;
    }

    .dropdown {
        position: relative;
    }

    .dropdown-content {
        display: none;
        position: absolute;
        background-color: white;
        min-width: 180px;
        box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        z-index: 1;
        top: 100%;
        left: 0;
        border-radius: 8px;
        padding: 10px 0;
    }

    .dropdown-content a {
        color: #333;
        padding: 8px 16px;
        display: block;
        text-decoration: none;
        font-weight: normal;
    }

    .dropdown-content a:hover {
        background-color: #f1f1f1;
        color: #4a90e2;
        font-weight: bold;
    }

    .dropdown:hover .dropdown-content {
        display: block;
    }
    body {
        padding-top: 50px; /* 네비 높이만큼 여백 주기 */
    }
    .fc-header-toolbar {
		  margin-top: 60px !important;  /* ← 여백 충분히 줘서 X랑 안 겹치게 */
		}
		#calendarModal {
		  background-color: rgba(255, 192, 203, 0.2); /* 연핑크 반투명 */
		}
		#calendarModal .modal-content {
		  background: #fff0f5; /* 연한 핑크톤 배경 */
		  border-radius: 20px;
		  padding: 30px;
		  box-shadow: 0 0 12px rgba(0,0,0,0.15);
		}
		/* 이전/다음/오늘 버튼 */
.fc .fc-button {
  background-color: #ffb6c1;     /* 연핑크 */
  border: none;
  color: white;
  font-weight: bold;
  border-radius: 8px;
}

.fc .fc-button:hover {
  background-color: #ff8da7;     /* 좀 더 진한 핑크 */
}

/* 활성화된 view 버튼 (month/week 등) */
.fc .fc-button.fc-button-active {
  background-color: #ff69b4;     /* 진핑크 하이라이트 */
  border: none;
}
.fc-toolbar-title {
  color: #e75480;     /* 예쁜 진한 연핑크 계열 */
  font-size: 24px;
  font-weight: bold;
}
.fc-daygrid-day:hover {
  background-color: #ffe4e9;  /* 셀 hover 시 연핑크 강조 */
}

.fc-day-today {
  background-color: #ffeef2 !important;  /* 오늘 날짜 배경 */
  border: 1px solid #ffb6c1 !important;
}
.calendar-toggle {
  position: fixed;
  top: 60px; /* 네비바 바로 아래로 */
  right: 20px;
  z-index: 1500;
  font-weight: bold;
  cursor: pointer;
  align-items: center; 
  text-align: center; 
}

.calendar-toggle a {
  border: none;
  text-decoration: none;
  outline: none;
  font-size: 20px;
}
.calendar-toggle p {
	font-size: 12px;
	margin-top: -3px;
	color: black;
}
.calendar-toggle p:hover {
	color: darkgray;
}
#calendar-full {
  width: 100%;
  height: 100%;
  min-height: 500px;
}
</style>

</head>
<body>

<div class="navbar">
    <div class="left">
        <a href="${pageContext.request.contextPath}/">🏠 Home</a>

        <!-- Todo 드롭다운 -->
        <div class="dropdown">
            <a href="javascript:void(0);">🧹 Todo</a>
            <div class="dropdown-content">
                <a href="${pageContext.request.contextPath}/todos">📋 Todo 목록</a>
                <a href="${pageContext.request.contextPath}/todos/myTodos">✅ MyTodo 목록</a>
                <a href="${pageContext.request.contextPath}/todos/create">✅ Todo 등록</a>
            </div>
        </div>

        <!-- History 드롭다운 -->
        <div class="dropdown">
            <a href="javascript:void(0);">📋 History</a>
            <div class="dropdown-content">
                <a href="${pageContext.request.contextPath}/history/all">📋 전체 조회</a>
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
        
        <!-- 📊 점수 드롭다운 -->
		<div class="dropdown">
		    <a href="javascript:void(0);">📊 점수</a>
		    <div class="dropdown-content">
		        <a href="${pageContext.request.contextPath}/history/monthly-score?group_id=1">📅 월간 점수 보기</a>
		        <!-- 추후: 전체 통계 페이지 추가도 고려 가능 -->
		    </div>
		</div>
				
		<!-- 📦 필요 물품 드롭다운 추가 -->
		<c:if test="${not empty sessionScope.loginMember}">
		    <!-- 📦 필요 물품 드롭다운 -->
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
  <a href="javascript:void(0);" onclick="openCalendarModal()">📅<p>Calender</p></a>
</div>

<!-- 모달 영역 추가 -->
<div id="calendarModal"
     style="display: none; position: fixed; z-index: 2000;
            top: 0; left: 0; width: 100%; height: 100%;
            overflow: hidden;
            background-color: rgba(0,0,0,0.5);">
  <div style="background: white; width: 70%; height: 70%;
              margin: 40px auto; padding: 20px;
              position: relative; border-radius: 12px;">
    <span onclick="closeModal()"
          style="position:absolute; top:10px; right:20px;
                 font-size:20px; cursor:pointer;">❌</span>
    <div id="calendar-full" style="height: 100%;"></div>
  </div>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function () {

    // 전역 변수로 캘린더 저장
    let fullCal = null;

    window.openCalendarModal = function () {
      document.getElementById('calendarModal').style.display = 'block';

      // 모달 열릴 때 캘린더가 없으면 새로 생성
      if (!fullCal) {
        fullCal = new FullCalendar.Calendar(document.getElementById('calendar-full'), {
        	locale: 'ko',
        	titleFormat: { year: 'numeric', month: 'long' },  
          initialView: 'dayGridMonth',
          height: 600,
          selectable: true,
          editable: true,
          headerToolbar: {
            left: 'prev,next',
            center: 'title',
            right: 'today'
          }
        });
        fullCal.render();
      }
    };

    window.closeModal = function () {
      document.getElementById('calendarModal').style.display = 'none';
    };

    // 날짜 클릭 시 강제로 이동하며 열기 (필요 시)
    window.openModal = function (dateStr) {
      openCalendarModal();
      if (fullCal) {
        fullCal.gotoDate(dateStr);
      }
    };

    window.confirmLogout = function () {
      if (confirm("정말 로그아웃 하시겠습니까?")) {
        window.location.href = '${pageContext.request.contextPath}/member/logout';
      }
    };

  });
</script>

</body>
</html>
