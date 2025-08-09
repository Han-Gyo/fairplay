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
	  <!-- 집안일 -->
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="100">
	    <i class="fas fa-broom fa-3x"></i>
	    <h5>집안일 등록</h5>
	    <p>빗자루 쓸 듯 깔끔하게 할 일 정리해요.</p>
	  </div>
	
	  <!-- 물품 정리 -->
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="200">
	    <i class="fas fa-dumpster fa-3x"></i>
	    <h5>물품 정리</h5>
	    <p>필요한 물건들을 스마트하게 체크!</p>
	  </div>
	
	  <!-- 일정 관리 -->
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="300">
	    <i class="fas fa-calendar-alt fa-3x"></i>
	    <h5>일정 관리</h5>
	    <p>모두의 캘린더를 한 눈에 확인하세요.</p>
	  </div>
	
	  <!-- 히스토리 -->
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="400">
	    <i class="fas fa-book-open fa-3x"></i>
	    <h5>히스토리</h5>
	    <p>완료한 집안일 기록을 되돌아봐요.</p>
	  </div>
	
	  <!-- 가계부 -->
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="500">
	    <i class="fas fa-wallet fa-3x"></i>
	    <h5>가계부</h5>
	    <p>누가 뭘 샀는지, 얼마나 썼는지 확인해요.</p>
	  </div>
	
	  <!-- 통계 보기 -->
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="600">
	    <i class="fas fa-chart-pie fa-3x"></i>
	    <h5>기여도 통계</h5>
	    <p>이번 달, 누가 제일 많이 했을까요?</p>
	  </div>
	
	  <!-- 그룹관리 -->
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="700">
	    <i class="fas fa-users fa-3x"></i>
	    <h5>그룹 관리</h5>
	    <p>그룹 초대, 멤버 확인, 권한 설정 등 관리해요.</p>
	  </div>
	</div>
  </div>

  <!-- JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="https://unpkg.com/aos@2.3.4/dist/aos.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/home.js"></script>
</body>
</html>
