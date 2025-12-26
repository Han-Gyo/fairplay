<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>필요 물품 목록</title>

  <!-- Bootswatch Minty 테마 -->
  <link href="https://bootswatch.com/5/minty/bootstrap.min.css" rel="stylesheet">

  <!-- FontAwesome 아이콘 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"/>

  <!-- 기존 CSS/JS -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/needed.css">
  <script defer src="${pageContext.request.contextPath}/resources/js/needed.js"></script>
</head>
<body class="bg-light" data-context-path="${pageContext.request.contextPath}">

<div class="container mt-5">
  <div class="card shadow-lg border-0">
    <!-- 헤더 -->
    <div class="card-header bg-primary text-white d-flex align-items-center">
      <i class="fas fa-box me-2"></i>
      <h4 class="mb-0">필요 물품 목록</h4>
    </div>

    <div class="card-body">
      <!-- 그룹 선택 -->
      <form method="get" action="${pageContext.request.contextPath}/needed/list" class="mb-3">
        <label for="groupId" class="form-label fw-bold">그룹 선택</label>
        <select name="groupId" id="groupId" class="form-select" onchange="this.form.submit()">
          <c:forEach var="group" items="${joinedGroups}">
            <option value="${group.id}" ${group.id == groupId ? 'selected' : ''}>${group.name}</option>
          </c:forEach>
        </select>
      </form>

      <!-- 추가 버튼 -->
      <div class="mb-3 text-end">
        <a href="${pageContext.request.contextPath}/needed/add?groupId=${groupId}" class="btn btn-success">
          <i class="fas fa-plus"></i> 물품 등록
        </a>
      </div>

      <!-- 물품 카드 리스트 -->
      <div class="row">
		<c:forEach var="item" items="${items}">
		  <div class="col-md-6 mb-4">
		    <!-- purchased 상태일 때 purchased 클래스 추가 -->
		    <div class="card needed-card ${item.purchased ? 'purchased border-success' : 'border-secondary'} h-100">
		      
		      <!-- 카드 헤더 -->
		      <div class="card-header d-flex justify-content-between align-items-center">
		        <h5 class="card-title mb-0">${item.itemName}</h5>
		        <div class="form-check">
		          <input type="checkbox" 
		                 class="form-check-input purchase-check" 
		                 data-id="${item.id}" 
		                 ${item.purchased ? 'checked' : ''}>
		          <label class="form-check-label">구매 완료</label>
		        </div>
		      </div>
		      
		      <!-- 카드 본문 -->
		      <div class="card-body">
		        <p><strong>수량:</strong> ${item.quantity}</p>
		        <p><strong>메모:</strong> ${item.memo}</p>
		        <p><strong>작성자:</strong> ${item.writerNickname}</p>
		      </div>
		      
		      <!-- 카드 푸터 -->
			<div class="card-footer d-flex justify-content-between align-items-center">
			  <!-- 수정 버튼: a태그 -->
			  <a href="${pageContext.request.contextPath}/needed/edit?id=${item.id}" 
			     class="btn btn-warning btn-sm btn-eq d-inline-flex align-items-center">
			    <i class="fas fa-edit me-1"></i> 수정
			  </a>
			
			  <!-- 삭제 버튼: form을 flex로 전환 + 여백 제거 -->
			  <form action="${pageContext.request.contextPath}/needed/delete" 
			        method="post" 
			        class="d-flex align-items-center m-0 p-0">
			    <input type="hidden" name="id" value="${item.id}">
			    <input type="hidden" name="groupId" value="${groupId}">
			    <button type="submit" class="btn btn-danger btn-sm btn-eq d-inline-flex align-items-center m-0">
			      <i class="fas fa-trash me-1"></i> 삭제
			    </button>
			  </form>
			</div>



		    </div>
		  </div>
		</c:forEach>
      </div>
    </div>
  </div>
</div>

</body>
</html>