<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>FairPlay - 홈</title>

  <!-- 외부 라이브러리 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link href="https://unpkg.com/aos@2.3.4/dist/aos.css" rel="stylesheet">

  <!-- 사용자 정의 CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css">
</head>

<%@ include file="/WEB-INF/views/nav.jsp" %>

<body class="home-body">
  <div class="home-container">
    <h1 class="home-title" data-aos="fade-down">✨ FairPlay에 오신 걸 환영해요!</h1>

    <!-- 카드 컨테이너 -->
    <div class="home-card-container">
      <div class="home-card" data-aos="zoom-in" data-aos-delay="100">
        <i class="fas fa-broom fa-3x"></i>
        <h5>집안일 등록</h5>
        <p>빗자루 쓸 듯 깔끔하게 할 일 정리해요.</p>
      </div>
      <div class="home-card" data-aos="zoom-in" data-aos-delay="200">
        <i class="fas fa-dumpster fa-3x"></i>
        <h5>물품 정리</h5>
        <p>필요한 물건들을 스마트하게 체크!</p>
      </div>
      <div class="home-card" data-aos="zoom-in" data-aos-delay="300">
        <i class="fas fa-calendar-alt fa-3x"></i>
        <h5>일정 관리</h5>
        <p>모두의 캘린더를 한 눈에 확인하세요.</p>
      </div>
    </div>
  </div>

  <!-- JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://unpkg.com/aos@2.3.4/dist/aos.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/home.js"></script>
</body>
</html>
