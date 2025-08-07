<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>필요 물품 목록</title>

  <!-- CSS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/needed.css">
  <!-- Js -->
  <script defer src="${pageContext.request.contextPath}/resources/js/needed.js"></script>
</head>
<body class="needed-body">

  <div class="needed-container">
    <h2 class="needed-title">📦 필요 물품 목록</h2>

    <!-- ✅ 그룹 선택 -->
    <form method="get" action="${pageContext.request.contextPath}/needed/list" class="group-select-form">
      <select name="groupId" id="groupId" onchange="this.form.submit()">
        <c:forEach var="group" items="${joinedGroups}">
          <option value="${group.id}" ${group.id == groupId ? 'selected' : ''}>${group.name}</option>
        </c:forEach>
      </select>
    </form>

    <!-- ✅ 추가 버튼 -->
    <div class="add-btn-wrap">
      <a href="${pageContext.request.contextPath}/needed/add?groupId=${groupId}" class="btn-add">➕ 물품 등록</a>
    </div>

    <!-- ✅ 물품 카드 리스트 -->
    <div class="needed-card-list">
      <c:forEach var="item" items="${items}">
        <div class="needed-card ${item.purchased ? 'purchased' : ''}">
          <div class="item-header">
            <h4>${item.itemName}</h4>
            <label>
              <input type="checkbox" class="purchase-check" data-id="${item.id}" ${item.purchased ? 'checked' : ''}>
              구매 완료
            </label>
          </div>
          <p><strong>수량:</strong> ${item.quantity}</p>
          <p><strong>메모:</strong> ${item.memo}</p>
          <p><strong>작성자:</strong> ${item.writerNickname}</p>
          <div class="item-actions">
            <a href="${pageContext.request.contextPath}/needed/edit?id=${item.id}" class="btn-small">수정</a>
            <form action="${pageContext.request.contextPath}/needed/delete" method="post">
              <input type="hidden" name="id" value="${item.id}">
              <input type="hidden" name="groupId" value="${groupId}">
              <button type="submit" class="btn-small red">삭제</button>
            </form>
          </div>
        </div>
      </c:forEach>
    </div>
  </div>

</body>
</html>
