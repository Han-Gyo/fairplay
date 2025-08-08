<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>📊 월간 점수 보기</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/statistics.css" />

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="score-body" data-context-path="${pageContext.request.contextPath}">
<div class="score-container">

    <!-- ✅ 페이지 타이틀 -->
    <h2 class="score-title">📅 ${yearMonth} ${group.name} 그룹의 점수 현황</h2>

    <!-- ✅ 월 이동/선택 툴바 -->
    <c:set var="year" value="${fn:substring(yearMonth, 0, 4)}" />
    <c:set var="month" value="${fn:substring(yearMonth, 5, 7)}" />
    <c:set var="intYear" value="${year}" />
    <c:set var="intMonth" value="${month}" />

    <!-- 이전/다음 월 계산 -->
    <c:choose>
        <c:when test="${intMonth == 1}">
            <c:set var="prevYear" value="${intYear - 1}" />
            <c:set var="prevMonth" value="12" />
        </c:when>
        <c:otherwise>
            <c:set var="prevYear" value="${intYear}" />
            <c:set var="prevMonth" value="${intMonth - 1}" />
        </c:otherwise>
    </c:choose>
    <c:choose>
        <c:when test="${intMonth == 12}">
            <c:set var="nextYear" value="${intYear + 1}" />
            <c:set var="nextMonth" value="1" />
        </c:when>
        <c:otherwise>
            <c:set var="nextYear" value="${intYear}" />
            <c:set var="nextMonth" value="${intMonth + 1}" />
        </c:otherwise>
    </c:choose>

    <div class="score-toolbar">
        <!-- ◀ 이전 -->
        <c:choose>
            <c:when test="${prevMonth < 10}">
                <a class="nav-btn" href="?group_id=${group.id}&yearMonth=${prevYear}-0${prevMonth}" aria-label="이전 달">❮</a>
            </c:when>
            <c:otherwise>
                <a class="nav-btn" href="?group_id=${group.id}&yearMonth=${prevYear}-${prevMonth}" aria-label="이전 달">❮</a>
            </c:otherwise>
        </c:choose>

        <!-- 현재 월 표시 + 직접 선택 -->
        <div class="month-inline">
            <strong class="current-month">${month}월</strong>
            <input type="month" id="ymInput" value="${yearMonth}" class="month-input" />
            <button id="goMonthBtn" class="btn-sky">이동</button>
        </div>

        <!-- ▶ 다음 -->
        <c:choose>
            <c:when test="${nextMonth < 10}">
                <a class="nav-btn" href="?group_id=${group.id}&yearMonth=${nextYear}-0${nextMonth}" aria-label="다음 달">❯</a>
            </c:when>
            <c:otherwise>
                <a class="nav-btn" href="?group_id=${group.id}&yearMonth=${nextYear}-${nextMonth}" aria-label="다음 달">❯</a>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 전달 파라미터 (JS에서 사용) -->
    <input type="hidden" id="groupId" value="${group.id}" />
    <input type="hidden" id="yearMonth" value="${yearMonth}" />

    <!-- ✅ 그룹 총 점수 카드 -->
    <section class="chart-card">
        <div class="card-header"><h3>🏆 그룹 총 점수 그래프</h3></div>
        <div class="chart-wrap"><canvas id="groupChart"></canvas></div>
        <p class="hint">※ 점수는 집안일 완료 기록을 기준으로 집계됩니다.</p>
    </section>

    <!-- ✅ 그룹 총 점수 텍스트 -->
    <c:forEach var="g" items="${groupScores}">
        <div class="stat-card">
            <p><strong>${group.name}</strong> 그룹의 총 점수는 <strong class="highlight">${g.totalScore}</strong>점 입니다.</p>
        </div>
    </c:forEach>

    <!-- ✅ 멤버별 점수 카드 -->
    <section class="chart-card">
        <div class="card-header"><h3>👥 멤버별 점수 그래프</h3></div>
        <div class="chart-wrap"><canvas id="memberChart"></canvas></div>

        <!-- 텍스트 목록 (서버 렌더 값 유지) -->
        <div class="member-list">
            <c:forEach var="m" items="${memberScores}">
                <p><span class="nick">${m.nickname}</span> <strong class="highlight">${m.score}</strong>점</p>
            </c:forEach>
        </div>
    </section>

</div>

<!-- 데이터 엔드포인트 훅 -->
<div id="chartHooks"
     data-group-url="${pageContext.request.contextPath}/statistics/group-monthly-total"
     data-member-url="${pageContext.request.contextPath}/statistics/monthly-score"></div>

<!-- JS -->
<script src="${pageContext.request.contextPath}/resources/js/statisticsGroupChart.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/statisticsChart.js"></script>
<script>
  (function(){
    var btn = document.getElementById('goMonthBtn');
    if (!btn) return;
    btn.addEventListener('click', function () {
      var ymEl = document.getElementById('ymInput');
      var gidEl = document.getElementById('groupId');
      var ym = ymEl ? ymEl.value : '';
      var gid = gidEl ? gidEl.value : '';
      if (ym) location.href = '?group_id=' + encodeURIComponent(gid) + '&yearMonth=' + encodeURIComponent(ym);
    });
  })();
</script>
</body>
</html>
