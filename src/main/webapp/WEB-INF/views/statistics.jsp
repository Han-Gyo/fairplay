<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>통계 시각화</title>

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/statistics.css" />

    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>

    <div class="container">
        <h2>📊 멤버 월별 점수 통계</h2>

        <!-- 서버에서 전달된 값 -->
        <input type="hidden" id="groupId" value="${groupId}" />
        <input type="hidden" id="yearMonth" value="${yearMonth}" />

        <!-- 차트 영역 -->
        <canvas id="scoreChart" width="800" height="400"></canvas>
        
        <!-- ⬇ 그룹 총점 차트 추가 -->
		<h3 style="margin-top: 40px;">이번 달 우리 그룹 총점</h3>
		<canvas id="groupTotalChart" width="600" height="300"></canvas>
    </div>

    <!-- JS -->
    <script src="${pageContext.request.contextPath}/resources/js/statisticsChart.js"></script>

</body>
</html>
