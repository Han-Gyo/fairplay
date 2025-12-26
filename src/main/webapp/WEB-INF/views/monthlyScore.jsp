<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>📊 월간 점수 보기</title>

    <!-- Bootswatch Minty theme -->
    <link rel="stylesheet" href="https://bootswatch.com/5/minty/bootstrap.min.css">
    <!-- Custom CSS (Minty 위에 로드해 커스텀 우선 적용) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/statistics.css" />

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="score-body" data-context-path="${pageContext.request.contextPath}">

<div class="container py-4">
    <!-- 페이지 타이틀 -->
    <h2 class="mb-3">📅 ${yearMonth} ${group.name} 그룹의 점수 현황</h2>

    <!-- 그룹 선택 폼 -->
    <form method="get" action="${pageContext.request.contextPath}/history/monthly-score" class="card mb-4">
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-sm-4">
                    <label for="groupSelect" class="form-label">그룹 선택</label>
                    <select name="group_id" id="groupSelect" class="form-select" onchange="this.form.submit()">
                        <c:forEach var="g" items="${myGroups}">
                            <option value="${g.id}" <c:if test="${g.id == groupId}">selected</c:if>>
                                ${g.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-sm-4">
                    <label for="ymInput" class="form-label">월 선택</label>
                    <input type="month" id="ymInput" name="yearMonth" value="${yearMonth}" class="form-control" />
                </div>
                <div class="col-sm-4 d-flex justify-content-sm-start justify-content-md-end">
                    <button type="submit" class="btn btn-primary">조회</button>
                </div>
            </div>
        </div>
    </form>

    <!-- 월 이동/선택 툴바 -->
    <c:set var="year" value="${fn:substring(yearMonth, 0, 4)}" />
    <c:set var="month" value="${fn:substring(yearMonth, 5, 7)}" />
    <c:set var="intYear" value="${year}" />
    <c:set var="intMonth" value="${month}" />

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

    <div class="d-flex align-items-center justify-content-between mb-3">
        <div>
            <c:choose>
                <c:when test="${prevMonth < 10}">
                    <a class="btn btn-outline-secondary" href="?group_id=${group.id}&yearMonth=${prevYear}-0${prevMonth}" aria-label="이전 달">❮</a>
                </c:when>
                <c:otherwise>
                    <a class="btn btn-outline-secondary" href="?group_id=${group.id}&yearMonth=${prevYear}-${prevMonth}" aria-label="이전 달">❮</a>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="text-center">
            <span class="badge bg-success fs-6 px-3 py-2">${month}월</span>
        </div>
        <div>
            <c:choose>
                <c:when test="${nextMonth < 10}">
                    <a class="btn btn-outline-secondary" href="?group_id=${group.id}&yearMonth=${nextYear}-0${nextMonth}" aria-label="다음 달">❯</a>
                </c:when>
                <c:otherwise>
                    <a class="btn btn-outline-secondary" href="?group_id=${group.id}&yearMonth=${nextYear}-${nextMonth}" aria-label="다음 달">❯</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- 전달 파라미터 (JS에서 사용) -->
    <input type="hidden" id="groupId" value="${group.id}" />
    <input type="hidden" id="yearMonth" value="${yearMonth}" />

    <div class="row g-4">
        <!-- 그룹 총 점수 카드 -->
        <div class="col-12 col-lg-6">
            <section class="card h-100">
                <div class="card-header"><h5 class="mb-0">🏆 그룹 총 점수 그래프</h5></div>
                <div class="card-body">
                    <div class="chart-wrap">
                        <canvas id="groupChart"></canvas>
                    </div>
                    <p class="text-muted small mt-2">※ 점수는 집안일 완료 기록을 기준으로 집계됩니다.</p>
                </div>
            </section>
        </div>

        <!-- 멤버별 점수 카드 -->
        <div class="col-12 col-lg-6">
            <section class="card h-100">
                <div class="card-header"><h5 class="mb-0">👥 멤버별 점수 그래프</h5></div>
                <div class="card-body">
                    <div class="chart-wrap">
                        <canvas id="memberChart"></canvas>
                    </div>

                    <div class="mt-3">
                        <c:forEach var="m" items="${memberScores}">
                            <p class="mb-1">
                                <span class="fw-semibold">${m.nickname}</span>
                                <span class="badge bg-info text-dark ms-2">${m.score}점</span>
                            </p>
                        </c:forEach>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <!-- 그룹 총 점수 텍스트 (별도 카드) -->
    <c:forEach var="g" items="${groupScores}">
        <div class="card mt-4">
            <div class="card-body">
                <p class="mb-0">
                    <strong>${group.name}</strong> 그룹의 총 점수는
                    <span class="badge bg-primary ms-1">${g.totalScore}점</span>
                    입니다.
                </p>
            </div>
        </div>
    </c:forEach>
</div>

<!-- 데이터 엔드포인트 훅 -->
<div id="chartHooks"
     data-group-url="${pageContext.request.contextPath}/statistics/group-monthly-total"
     data-member-url="${pageContext.request.contextPath}/statistics/monthly-score"></div>

<!-- JS -->
<script src="${pageContext.request.contextPath}/resources/js/statisticsGroupChart.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/statisticsChart.js"></script>
</body>
</html>