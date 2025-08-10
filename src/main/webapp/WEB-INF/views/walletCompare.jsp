<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<html>
<head>
<title>단가 비교 - ${item_name}</title>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/walletCompare.css">
</head>
<body class="score-body">
<div class="score-container">
<h1>📊 "${item_name}" 단가 비교</h1>

<a href="${pageContext.request.contextPath}/wallet?member_id=${param.member_id}">← 목록으로 돌아가기</a>

<!-- 차트를 그릴 캔버스 -->
<div class="chart-card">
  <div class="chart-wrap">
    <canvas id="compareChart"></canvas>
  </div>
  <div class="hint">단가(₩)는 가격 ÷ 수량 기준</div>
</div>

<script>
    const labels = [
        <c:forEach var="item" items="${compareList}" varStatus="status">
            "${item.store}"<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    const unitPrices = [
        <c:forEach var="item" items="${compareList}" varStatus="status">
            <c:out value="${item.unit_count != 0 ? item.price / item.unit_count : 0}" />
            <c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    const data = {
        labels: labels,
        datasets: [{
            label: "단가 (₩)",
            data: unitPrices,
            borderWidth: 1,
            backgroundColor: "rgba(54, 162, 235, 0.5)",
            borderColor: "rgba(54, 162, 235, 1)",
            borderRadius: 6,
            hoverBackgroundColor: "rgba(54, 162, 235, 0.65)",
            maxBarThickness: 48
        }]
    };

    const config = {
        type: "bar",
        data: data,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            
            plugins: {
                legend: { display: false },
                title: {
                    display: true,
                    text: "구매처별 단가 비교"
                }
            },
            scales: {
            	  y: {
            	    beginAtZero: true,
            	    grid: { color: "rgba(0,0,0,0.06)" },   // 연한 그리드
            	    title: { display: true, text: "단가 (₩)" }
            	  },
            	  x: {
            	    grid: { display: false }               // x축 그리드는 제거
            	  }
            }
        }
    };

    new Chart(document.getElementById("compareChart"), config);
</script>
</div>
</body>
</html>