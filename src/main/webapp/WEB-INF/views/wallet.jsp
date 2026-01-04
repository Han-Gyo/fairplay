<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<html>
<head>
<title>가계부 목록</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/wallet.css" />

</head>
<body class="wallet-body">

<div class="container wallet-container">

  <div class="page-head">
    <h1 class="page-title">💸 가계부 전체 목록</h1>
    <a class="btn btn-primary" href="${pageContext.request.contextPath}/wallet/create">+ 새 항목 등록</a>
  </div>

  <!-- 항목 리스트 테이블 -->
  <div class="table-card">
	  <table class="wallet-table">
	    <thead>
	      <tr>
	        <th>ID</th>
	        <th>품목명</th>
	        <th>카테고리</th>
	        <th>가격</th>
	        <th>수량</th>
	        <th>단위</th>
	        <th>단가(1개당)</th>
	        <th>구매처</th>
	        <th>유형</th>
	        <th>구매일</th>
	        <th>메모</th>
	        <th>관리</th>
	      </tr>
	    </thead>
	    <tbody>
	      <c:forEach var="item" items="${walletList}">
	        <tr>
	          <td class="num">${item.id}</td>
	          <td class="strong">${item.item_name}</td>
	          <td>
	            <span class="badge badge-cat">${item.category}</span>
	          </td>
	          <td class="num">
	            <fmt:formatNumber value="${item.price}" pattern="#,###" />원
	          </td>
	          <td class="num">${item.quantity}</td>
	          <td>${item.unit}</td>
	          <td class="num">
	            <c:if test="${item.unit_count != 0}">
	              <span class="chip chip-price">
	              	<fmt:formatNumber value="${item.price / item.unit_count}" pattern="#,###"/>원
	              </span>
	            </c:if>
	          </td>
	          <td>${item.store}</td>
	          <td>
	            <span class="badge badge-type">${item.type}</span>
	          </td>
	          <td><fmt:formatDate value="${item.purchase_date}" pattern="yyyy-MM-dd"/></td>
	          <td class="memo">${item.memo}</td>
	          <td class="actions">
	            <a class="btn btn-ghost" href="${pageContext.request.contextPath}/wallet/edit?id=${item.id}">✏️ 수정</a>
	            <a class="btn btn-danger" href="${pageContext.request.contextPath}/wallet/delete?id=${item.id}&member_id=${member_id}" onclick="return confirm('정말 삭제할까요?');">🗑️ 삭제</a>
	          </td>
	        </tr>
	      </c:forEach>
	    </tbody>
	  </table>
	</div>

  <!-- 단가 비교 검색 -->
<div class="compare-section card border-0 shadow-sm rounded-4 mt-5">
  <div class="card-body p-4">
    <div class="d-flex align-items-center mb-3">
      <h5 class="fw-bold text-dark mb-0">
        <i class="fas fa-chart-bar text-primary me-2"></i>최저가 똑똑하게 비교하기
      </h5>
    </div>
    
    <form class="compare-form-new" action="${pageContext.request.contextPath}/wallet/compare" method="get">
      <input type="hidden" name="member_id" value="${member_id}" />
      <div class="input-group-custom">
        <div class="search-input-wrapper">
          <i class="fas fa-search search-icon"></i>
          <input class="input-field" type="text" name="item_name" placeholder="어떤 품목의 단가가 궁금하신가요?" required/>
        </div>
        <button class="btn-compare-gradient" type="submit">
          <span>📊 단가 분석하기</span>
        </button>
      </div>
    </form>
  </div>
</div>

</div>
</body>

</html>
