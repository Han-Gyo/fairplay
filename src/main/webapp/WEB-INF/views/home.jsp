<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>FairPlay - 홈</title>

  <!-- 외부 라이브러리 (nav.jsp와 중복되는지 확인 후 제거 권장) -->
  <!-- 이미 nav.jsp에서 로드하고 있다면 아래 link들은 제거해도 됩니다 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link href="https://unpkg.com/aos@2.3.4/dist/aos.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/home.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/base.css">
</head>

<!-- nav.jsp 안에 Bootstrap JS와 jQuery가 포함되어 있어야 함 -->
<%@ include file="/WEB-INF/views/nav.jsp" %>

<body class="home-body">
  <div class="home-container">
    <h1 class="home-title" data-aos="fade-down">FairPlay에 오신 걸 환영해요!</h1>
    
    <div class="home-card-container">
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="100">
	    <i class="fas fa-broom fa-3x"></i>
	    <h5>집안일 등록</h5>
	    <p>할 일을 정리하세요.</p>
	  </div>
	
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="200">
	    <i class="fas fa-dumpster fa-3x"></i>
	    <h5>물품 정리</h5>
	    <p>필요한 물건 체크!</p>
	  </div>
	
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="300">
	    <i class="fas fa-calendar-alt fa-3x"></i>
	    <h5>일정 관리</h5>
	    <p>캘린더 확인.</p>
	  </div>
	
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="400">
	    <i class="fas fa-book-open fa-3x"></i>
	    <h5>히스토리</h5>
	    <p>기록 되돌아보기.</p>
	  </div>
	
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="500">
	    <i class="fas fa-wallet fa-3x"></i>
	    <h5>가계부</h5>
	    <p>지출 내역 확인.</p>
	  </div>
	
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="600">
	    <i class="fas fa-chart-pie fa-3x"></i>
	    <h5>기여도 통계</h5>
	    <p>활동 통계 확인.</p>
	  </div>
	
	  <div class="home-card" data-aos="zoom-in" data-aos-delay="700">
	    <i class="fas fa-users fa-3x"></i>
	    <h5>그룹 관리</h5>
	    <p>그룹 멤버 관리.</p>
	  </div>
	</div>
  </div>

  <!-- JS 섹션 -->
  <!-- 
    주의: bootstrap.bundle.min.js는 nav.jsp에서 이미 로드했으므로 여기서 삭제합니다.
    중복 로드는 드롭다운 이벤트를 파괴합니다.
  -->
  <script src="https://unpkg.com/aos@2.3.4/dist/aos.js"></script>
  <script src="${pageContext.request.contextPath}/resources/js/home.js"></script>
  <script>
    document.addEventListener('DOMContentLoaded', function() {
      AOS.init();
    });
  </script>
</body>
</html>