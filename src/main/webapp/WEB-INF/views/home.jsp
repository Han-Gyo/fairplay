<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FairPlay</title>
  <link href="https://bootswatch.com/5/minty/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css">
</head>

<body class="home-body">
  <%@ include file="/WEB-INF/views/nav.jsp" %>

  <div class="bg-blob blob-1"></div>
  <div class="bg-blob blob-2"></div>

  <div class="main-wrapper">
    <div class="home-content-area">
      <div class="hero-section">
        <h1 class="hero-title">
        <img src="${pageContext.request.contextPath}/resources/img/nav-logo.png" class="home-logo-img" alt="FairPlay 로고">
        airPlay</h1>
        <p class="hero-desc">
          당신의 일상을 더 가치 있게,<span class="second-line">
          <c:choose>
            <c:when test="${not empty sessionScope.loginMember}">
              <strong>${userNickname}</strong>님을 위한 완벽한 관리
            </c:when>
            <c:otherwise>
              fairplay와 함께하는 완벽한 관리
            </c:otherwise>
          </c:choose>
          </span>
        </p>
      </div>

      <nav class="interactive-menu">
        <div class="main-nav-item" onclick="location.href='#'">
          <span class="main-nav-link">집안일 관리</span>
          <span class="main-nav-hover-text">오늘 할 일, 놓친 건 없는지 체크해볼까요?</span>
        </div>
        <div class="main-nav-item" onclick="location.href='#'">
          <span class="main-nav-link">물품 정리</span>
          <span class="main-nav-hover-text">부족한 물건이 없는지 체크해볼까요?</span>
        </div>
        <div class="main-nav-item" onclick="location.href='#'">
          <span class="main-nav-link">일정 관리</span>
          <span class="main-nav-hover-text">
	          <c:choose>
	            <c:when test="${not empty sessionScope.loginMember}">
	              <strong>${userNickname}</strong>님의 소중한 약속들을 챙겨볼까요?
	            </c:when>
	            <c:otherwise>
	              fairplay의 중요한 약속과 일정을 관리해볼까요?
	            </c:otherwise>
	          </c:choose>
          </span>
        </div>
        <div class="main-nav-item" onclick="location.href='#'">
          <span class="main-nav-link">히스토리</span>
          <span class="main-nav-hover-text">우리가 함께한 기록들을 되돌아볼까요?</span>
        </div>
        <div class="main-nav-item" onclick="location.href='#'">
          <span class="main-nav-link">가계부</span>
          <span class="main-nav-hover-text">현명한 소비를 위한 지출 내역 확인해볼까요?</span>
        </div>
        <div class="main-nav-item" onclick="location.href='#'">
          <span class="main-nav-link">기여도 통계</span>
          <span class="main-nav-hover-text">누가 더 열심히 했는지 확인해볼까요?</span>
        </div>
      </nav>
    </div>
    
    <%@ include file="/WEB-INF/views/footer.jsp" %>
  </div>
  <script src="https://unpkg.com/aos@2.3.4/dist/aos.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/home.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      AOS.init();
    });
  </script>
</body>
</html>