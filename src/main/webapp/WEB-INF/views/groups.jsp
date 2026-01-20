<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>그룹 목록</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/groups.css" />
</head>
<body class="group-body" data-context-path="${pageContext.request.contextPath}">
<div class="group-container">

  <h1 class="page-title">👥 내 그룹</h1>

  <div class="toolbar">
    <div class="search">
      <svg width="16" height="16" viewBox="0 0 24 24"><path fill="#6b7280" d="M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79L20 21.5 21.5 20l-6-6zM9.5 14C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/></svg>
      <input id="groupSearch" type="text" placeholder="그룹 이름 검색" />
    </div>
    <a class="btn btn-sky" href="${pageContext.request.contextPath}/group/create">+ 새 그룹</a>
  </div>

  <div id="groupGrid" class="grid grid-3">
    <c:forEach var="g" items="${groups}">
      <div class="card group-card" data-name="${g.name}">
        <div class="color-dot"></div>
        <div class="group-info">
          <h3 class="group-name">${g.name}</h3>
          <p class="group-meta">
            👥 ${memberCounts[g.id]} / ${g.maxMember}
            · 생성일 ${g.formattedCreatedAt}
            · <c:choose><c:when test="${g.publicStatus}">공개</c:when><c:otherwise>비공개</c:otherwise></c:choose>
          </p>
        </div>
        <div class="card-actions">
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/group/detail?id=${g.id}">상세</a>
        </div>
      </div>
    </c:forEach>
  </div>

</div>
<script src="${pageContext.request.contextPath}/resources/js/group.js"></script>
</body>
</html>
