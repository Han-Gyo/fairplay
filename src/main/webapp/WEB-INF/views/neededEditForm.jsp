<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>물품 수정</title>

  <!-- Bootswatch Minty 테마 -->
  <link href="https://bootswatch.com/5/minty/bootstrap.min.css" rel="stylesheet">

  <!-- FontAwesome 아이콘 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>
</head>
<body class="bg-light">

<div class="container mt-5">
  <div class="card shadow-lg border-0">
    <!-- 헤더 -->
    <div class="card-header bg-primary text-white d-flex align-items-center">
      <i class="fas fa-edit me-2"></i>
      <h4 class="mb-0">물품 수정</h4>
    </div>

    <div class="card-body">
      <form action="${pageContext.request.contextPath}/needed/edit" method="post">
        <!-- hidden 값 -->
        <input type="hidden" name="id" value="${item.id}">
        <input type="hidden" name="groupId" value="${item.groupId}">

        <!-- 물품 이름 -->
        <div class="mb-3">
          <label for="itemName" class="form-label fw-bold">물품 이름</label>
          <input type="text" id="itemName" name="itemName" value="${item.itemName}" 
                 class="form-control" required>
        </div>

        <!-- 수량 -->
        <div class="mb-3">
          <label for="quantity" class="form-label fw-bold">수량</label>
          <input type="number" id="quantity" name="quantity" value="${item.quantity}" 
                 class="form-control" min="1" required>
        </div>

        <!-- 메모 -->
        <div class="mb-3">
          <label for="memo" class="form-label fw-bold">메모</label>
          <textarea id="memo" name="memo" class="form-control" rows="4">${item.memo}</textarea>
        </div>

        <!-- 버튼 -->
        <div class="d-flex justify-content-between">
          <button type="submit" class="btn btn-warning">
            <i class="fas fa-save"></i> 수정
          </button>
          <a href="${pageContext.request.contextPath}/needed/list?groupId=${item.groupId}" 
             class="btn btn-secondary">
            <i class="fas fa-times"></i> 취소
          </a>
        </div>
      </form>
    </div>
  </div>
</div>

</body>
</html>