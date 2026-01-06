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
<h1>📊 ${item_name} 단가 비교</h1>

<a href="${pageContext.request.contextPath}/wallet?member_id=${param.member_id}">← 목록으로 돌아가기</a>

<!-- 차트를 그릴 캔버스 -->
<div class="chart-card">
  <div class="chart-wrap">
    <canvas id="compareChart"></canvas>
  </div>
  <div class="hint">단가(₩)는 가격 ÷ 수량 기준</div>
</div>
</div>
</body>
<script>
  // 1. 서버에서 데이터 가져오기
  const rawData = [
    <c:forEach var="item" items="${compareList}" varStatus="status">
      {
        store: "${item.store}",
        price: ${item.price},
        quantity: ${item.quantity},
        unit_count: ${item.unit_count > 0 ? item.unit_count : 1},
        unit: "${item.unit}"
      }<c:if test="${!status.last}">,</c:if>
    </c:forEach>
  ];

  // 2. 단위에 따른 단가 계산
  const labels = rawData.map(item => item.store);
  const unitPrices = rawData.map(item => {
    // 총 개수 = 수량 * 단위당 개수
    const totalCount = item.quantity * item.unit_count;
    if (totalCount === 0) return 0;

    let pricePerUnit = item.price / totalCount;

    // 단위가 mL, ml, g이면 100단위당 가격
    if (['mL', 'ml', 'g'].includes(item.unit)) {
      return Math.round(pricePerUnit * 100);
    }
    // 그 외에는 1개당 가격
    return Math.round(pricePerUnit);
  });

  const data = {
    labels: labels,
    datasets: [{
      label: "단가 (₩)",
      data: unitPrices,
      backgroundColor: "#78C2AD",
      borderColor: "#78C2AD",
      borderWidth: 1,
      borderRadius: 10,
      hoverBackgroundColor: "#64a190",
      maxBarThickness: 40
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
          text: "구매처별 단가 비교 (100ml/g 또는 1개 기준)",
          font: { size: 16 }
        },
        // 마우스 올렸을 때 툴팁에 단위 표시
        tooltip: {
          callbacks: {
            label: function(context) {
              return '단가: ' + context.parsed.y.toLocaleString() + '원';
            }
          }
        }
      },
      scales: {
        y: {
          beginAtZero: true,
          grid: { color: "rgba(0,0,0,0.06)" },
          title: { display: true, text: "단가 (₩)" }
        },
        x: { grid: { display: false } }
      }
    }
  };

  new Chart(document.getElementById("compareChart"), config);
</script>
</html>