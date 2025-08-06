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

    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        a {
            border: none;
            text-decoration: none;
            outline: none;
        }
    </style>
</head>
<body data-context-path="${pageContext.request.contextPath}">

    <!-- ✅ 상단 타이틀 -->
    <h2>📅 ${yearMonth} ${group.name} 그룹의 점수 현황</h2>

    <!-- ✅ 월 이동 버튼 -->
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

    <!-- 월 이동 UI -->
    <div style="text-align:center; margin-bottom: 20px;">
        <c:choose>
            <c:when test="${prevMonth < 10}">
                <a href="?group_id=${group.id}&yearMonth=${prevYear}-0${prevMonth}">❮</a>
            </c:when>
            <c:otherwise>
                <a href="?group_id=${group.id}&yearMonth=${prevYear}-${prevMonth}">❮</a>
            </c:otherwise>
        </c:choose>

        <strong style="margin: 0 10px;">${month}월</strong>

        <c:choose>
            <c:when test="${nextMonth < 10}">
                <a href="?group_id=${group.id}&yearMonth=${nextYear}-0${nextMonth}">❯</a>
            </c:when>
            <c:otherwise>
                <a href="?group_id=${group.id}&yearMonth=${nextYear}-${nextMonth}">❯</a>
            </c:otherwise>
        </c:choose>
    </div>

	<!-- ✅ 그룹 총점 그래프 -->
	<div class="mt-4">
	    <h3>🏆 그룹 총 점수 그래프</h3>
	    <input type="hidden" id="groupId" value="${group.id}" />
	    <input type="hidden" id="yearMonth" value="${yearMonth}" />
	    <div style="width: 50%; margin: 0 auto;">
	        <canvas id="groupChart"></canvas>
	    </div>
	</div>

    <!-- ✅ 그룹 총 점수 출력 -->
    <c:forEach var="g" items="${groupScores}">
        <h3>${group.name} 그룹의 총 점수는 <strong>${g.totalScore}</strong>점 입니다.</h3>
    </c:forEach>

    <!-- ✅ 멤버 점수 출력 -->
    <h3>👥 멤버별 점수</h3>
    <c:forEach var="m" items="${memberScores}">
        <p>${m.nickname} <strong>${m.score}</strong>점</p>
    </c:forEach>

    <!-- ✅ Chart.js 차트 추가 -->
    <div class="mt-4" style="margin-top: 40px;">
        <h3>📊 멤버 점수 그래프</h3>
        <!-- 전달값 hidden 처리 -->
        <input type="hidden" id="groupId" value="${group.id}" />
        <input type="hidden" id="yearMonth" value="${yearMonth}" />
        <canvas id="scoreChart" width="800" height="400"></canvas>
    </div>

    <!-- JS 연결 -->
    <script src="${pageContext.request.contextPath}/resources/js/statisticsGroupChart.js"></script> <!-- 그룹 -->
    <script src="${pageContext.request.contextPath}/resources/js/statisticsChart.js"></script>	<!-- 멤버 -->

</body>
</html>
