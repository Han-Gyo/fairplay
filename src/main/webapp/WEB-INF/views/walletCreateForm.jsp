<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <!-- 날짜 포맷용 -->
<%@ include file="/WEB-INF/views/nav.jsp" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>지출 항목 등록/수정</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/walletCreate.css">
</head>
<body class="wallet-form-body">

<c:if test="${wallet.purchase_date != null}">
  <fmt:formatDate value="${wallet.purchase_date}" pattern="yyyy-MM-dd" var="purchaseDateStr"/>
</c:if>

<div class="wallet-form-container">
  <h1 class="wallet-form-title">
    ${wallet.id == 0 ? "💸가계부 등록" : "✏️ 항목 수정"}
  </h1>

  <form class="wallet-form"
        action="${pageContext.request.contextPath}${wallet.id == 0 ? '/wallet/save' : '/wallet/update'}"
        method="post">
    
    <!-- 숨겨진 값 -->
    <input type="hidden" name="id" value="${wallet.id}" />
    <input type="hidden" name="member_id" value="${member_id}" />

    <div class="form-group">
      <label for="item_name">품목명</label>
      <input type="text" id="item_name" name="item_name"
             value="${wallet.item_name}" required placeholder="예: 우유, 세제">
    </div>

    <div class="form-group">
      <label for="category">카테고리</label>
      <input type="text" id="category" name="category"
             value="${wallet.category}" placeholder="예: 식비, 생필품">
    </div>

    <div class="form-row">
      <div class="form-group">
        <label for="price">가격</label>
        <input type="number" id="price" name="price"
               value="${wallet.price}" required placeholder="예: 6800">
      </div>

      <div class="form-group">
        <label for="quantity">수량</label>
        <input type="number" id="quantity" name="quantity"
               value="${wallet.quantity}" min="1" placeholder="예: 2">
      </div>
    </div>

    <div class="form-row">
      <div class="form-group">
        <label for="unit">단위</label>
        <input type="text" id="unit" name="unit"
               value="${wallet.unit}" placeholder="예: mL, g, 개">
      </div>

      <div class="form-group">
        <label for="unit_count">단위당 개수</label>
        <input type="number" id="unit_count" name="unit_count"
               value="${wallet.unit_count}" placeholder="예: 500">
      </div>
    </div>

    <div class="form-group">
      <label for="store">구매처</label>
      <input type="text" id="store" name="store"
             value="${wallet.store}" placeholder="예: 이마트, 쿠팡, 편의점">
    </div>

    <div class="form-group">
      <label for="type">유형</label>
      <select id="type" name="type">
        <option value="지출" ${wallet.type == '지출' ? 'selected' : ''}>지출</option>
        <option value="수입" ${wallet.type == '수입' ? 'selected' : ''}>수입</option>
      </select>
    </div>

    <div class="form-group">
      <label for="purchase_date">구매일</label>
      <input type="date" id="purchase_date" name="purchase_date"
             value="${wallet.purchase_date != null ? purchaseDateStr : ''}" required>
    </div>

    <div class="form-group">
      <label for="memo">메모</label>
      <textarea id="memo" name="memo" rows="4" placeholder="필요 시 간단 메모를 남겨주세요 :)">${wallet.memo}</textarea>
      <p class="hint">* 단가 비교하려면 '수량/단위/단위당 개수' 입력해두면 좋아요.</p>
    </div>

    <div class="form-btns">
      <button type="submit" class="btn-submit">${wallet.id == 0 ? "등록" : "수정 완료"}</button>
      <a href="${pageContext.request.contextPath}/wallet" class="btn-cancel">뒤로가기</a>
    </div>
  </form>
</div>

</body>
</html>
