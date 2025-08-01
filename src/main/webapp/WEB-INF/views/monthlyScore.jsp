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
<style>
	a {
		  border: none;
		  text-decoration: none;
		  outline: none;
	}
</style>
</head>
<body>
    <h2>📅 ${yearMonth} ${group.name} 그룹의 점수 현황</h2>

    <!-- 🔄 월 이동 버튼 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="year" value="${fn:substring(yearMonth, 0, 4)}" />
<c:set var="month" value="${fn:substring(yearMonth, 5, 7)}" />
<c:set var="intYear" value="${year}" />
<c:set var="intMonth" value="${month}" />

<%-- 이전 월 계산 --%>
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

<%-- 다음 월 계산 --%>
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

<!-- 🔄 월 이동 버튼 -->
<div style="text-align:center; margin-bottom: 20px;">
    <!-- ◀ 이전 -->
    <c:choose>
        <c:when test="${prevMonth < 10}">
            <a href="?group_id=${group.id}&yearMonth=${prevYear}-0${prevMonth}">❮</a>
        </c:when>
        <c:otherwise>
            <a href="?group_id=${group.id}&yearMonth=${prevYear}-${prevMonth}">❮</a>
        </c:otherwise>
    </c:choose>

    <!-- 현재 월 -->
    <strong style="margin: 0 10px;">${month}월</strong>

    <!-- ▶ 다음 -->
    <c:choose>
        <c:when test="${nextMonth < 10}">
            <a href="?group_id=${group.id}&yearMonth=${nextYear}-0${nextMonth}">❯</a>
        </c:when>
        <c:otherwise>
            <a href="?group_id=${group.id}&yearMonth=${nextYear}-${nextMonth}">❯</a>
        </c:otherwise>
    </c:choose>
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
