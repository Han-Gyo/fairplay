<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FairPlay</title>
  <link href="https://bootswatch.com/5/minty/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css">
</head>

<body class="home-body">
  <%@ include file="/WEB-INF/views/nav.jsp" %>

  <div class="bg-blob blob-1"></div>
  <div class="bg-blob blob-2"></div>

  <div class="main-wrapper">
    <!-- home-alignment-box: 이 컨테이너만 정렬을 담당하여 캘린더 간섭 방지 -->
    <div class="home-alignment-box">
      <div class="container home-content-area">
        <div class="row align-items-center justify-content-center w-100">
          
          <!-- Hero Section (좌측) -->
          <div class="col-lg-6 hero-section">
            <div class="logo-title-group">
              <img src="${pageContext.request.contextPath}/resources/img/logo.png" class="home-logo-img" alt="F">
              <h1 class="hero-title">airPlay</h1>
            </div>
            
            <div class="hero-desc">
              <p class="main-text">당신의 일상을 더 가치 있게,</p>
              <p class="sub-text">
                <c:choose>
                  <c:when test="${not empty sessionScope.loginMember}">
                    <span class="nickname-highlight">${sessionScope.loginMember.nickname}</span>님을 위한 완벽한 관리
                  </c:when>
                  <c:otherwise>fairplay와 함께하는 완벽한 관리</c:otherwise>
                </c:choose>
              </p>
            </div>
          </div>
          
          <!-- Interactive Menu (우측) -->
          <div class="col-lg-6 interactive-menu">
            <div class="main-nav-item" onclick="location.href='${pageContext.request.contextPath}/todos?groupId=${sessionScope.currentGroupId}'">
              <span class="main-nav-link">집안일 관리</span>
              <span class="main-nav-hover-text">오늘 할 일, 놓친 건 없는지 체크해볼까요?</span>
            </div>
            <div class="main-nav-item" onclick="location.href='${pageContext.request.contextPath}/needed/list?groupId=${sessionScope.currentGroupId}'">
              <span class="main-nav-link">물품 정리</span>
              <span class="main-nav-hover-text">부족한 물건이 없는지 체크해볼까요?</span>
            </div>
            <div class="main-nav-item" onclick="openCalendarModal()">
              <span class="main-nav-link">일정 관리</span>
              <span class="main-nav-hover-text">소중한 약속들을 챙겨볼까요?</span>
            </div>
            <div class="main-nav-item" onclick="location.href='${pageContext.request.contextPath}/history/all?groupId=${currentGroupId}'">
              <span class="main-nav-link">히스토리</span>
              <span class="main-nav-hover-text">우리가 함께한 기록들을 되돌아볼까요?</span>
            </div>
            <div class="main-nav-item" onclick="location.href='${pageContext.request.contextPath}/wallet'">
              <span class="main-nav-link">가계부</span>
              <span class="main-nav-hover-text">현명한 소비를 위한 지출 내역 확인!</span>
            </div>
            <div class="main-nav-item" onclick="location.href='${pageContext.request.contextPath}/history/monthly-score?groupId=${sessionScope.currentGroupId}'">
              <span class="main-nav-link">기여도 통계</span>
              <span class="main-nav-hover-text">누가 더 열심히 했는지 확인해볼까요?</span>
            </div>
          </div>

        </div>
      </div>
    </div>
    <%@ include file="/WEB-INF/views/footer.jsp" %>
  </div>
</body>
</html>