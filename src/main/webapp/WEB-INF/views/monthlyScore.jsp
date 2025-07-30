<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>📊 월간 점수 보기</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <h2>📅 ${yearMonth} 점수 현황</h2>

    <!-- 🔄 월 이동 버튼 -->
    <div>
        <c:set var="year" value="${fn:substring(yearMonth, 0, 4)}"/>
        <c:set var="month" value="${fn:substring(yearMonth, 5, 7)}"/>
        <c:set var="prevMonth" value="${month - 1}" />
        <c:set var="nextMonth" value="${month + 1}" />
        
        <c:if test="${prevMonth > 0}">
            <a href="?group_id=1&yearMonth=${year}-${prevMonth < 10 ? '0' : ''}${prevMonth}">&lt; ${prevMonth}월</a>
        </c:if>

        <strong>${month}월</strong>

        <c:if test="${nextMonth <= 12}">
            <a href="?group_id=1&yearMonth=${year}-${nextMonth < 10 ? '0' : ''}${nextMonth}">${nextMonth}월 &gt;</a>
        </c:if>
    </div>

    <br/>

    <!-- ✅ 그룹 점수 -->
    <c:forEach var="g" items="${groupScores}">
        <p>총점: <strong>${g.totalScore}</strong>점</p>
        <p>🏠 멤버: ${g.groupId}</p> 
    </c:forEach>

    <!-- ✅ 멤버 점수 차트 -->
    <h3>👥 멤버별 점수</h3>
    <canvas id="memberChart" width="400" height="200"></canvas>

    <script>
        // JSP 데이터를 JS로 전달
        const memberLabels = [
            <c:forEach var="m" items="${memberScores}" varStatus="status">
                "${m.nickname}"<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        const memberScores = [
            <c:forEach var="m" items="${memberScores}" varStatus="status">
                ${m.score}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        const ctx = document.getElementById('memberChart').getContext('2d');
        const chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: memberLabels,
                datasets: [{
                    label: '점수',
                    data: memberScores,
                    backgroundColor: 'rgba(54, 162, 235, 0.6)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    </script>
</body>
</html>
