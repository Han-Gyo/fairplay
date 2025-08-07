<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>물품 등록</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/needed.css">
</head>
<body class="needed-body">

  <div class="form-container">
    <h2 class="needed-title">📝 새 물품 등록</h2>

    <form action="${pageContext.request.contextPath}/needed/add" method="post">
      <div class="form-group">
        <label for="groupId">그룹 선택</label>
        <select name="groupId" id="groupId" required>
          <c:forEach var="group" items="${joinedGroups}">
            <option value="${group.id}" ${group.id == item.groupId ? 'selected' : ''}>${group.name}</option>
          </c:forEach>
        </select>
      </div>

      <div class="form-group">
        <label for="itemName">물품 이름</label>
        <input type="text" id="itemName" name="itemName" value="${item.itemName}" required>
      </div>

      <div class="form-group">
        <label for="quantity">수량</label>
        <input type="number" id="quantity" name="quantity" value="${item.quantity}" min="1" required>
      </div>

      <div class="form-group">
        <label for="memo">메모</label>
        <textarea id="memo" name="memo">${item.memo}</textarea>
      </div>

      <div class="form-btns">
        <button type="submit" class="btn-submit">등록</button>
        <a href="${pageContext.request.contextPath}/needed/list?groupId=${item.groupId}" class="btn-cancel">취소</a>
      </div>
    </form>
  </div>

</body>
</html>
