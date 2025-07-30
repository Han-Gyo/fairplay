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
    <h2>📅 ${yearMonth} ${group.name} 그룹의 점수 현황</h2>

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
    <h3>${group.name} 그룹의 총 점수는 <strong>${g.totalScore}</strong>점 입니다.</h3>
    </c:forEach>

    <!-- ✅ 멤버 점수 차트 -->
    <h3>👥 멤버별 점수</h3>
        <c:forEach var="m" items="${memberScores}">
			    <p>${m.nickname} <strong>${m.score}</strong>점</p>
				</c:forEach>


</body>
</html>
