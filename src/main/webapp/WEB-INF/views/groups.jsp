<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>그룹 목록</title>
    <!-- BootSwatch Minty Theme CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/groups.css" />
</head>
<body class="bg-light" data-context-path="${pageContext.request.contextPath}">

<div class="container py-5">
    <!-- Page Header -->
    <div class="text-center mb-5">
        <h1 class="display-5 fw-bold text-primary">그룹 목록</h1>
        <p class="text-muted">참여 중인 그룹 목록을 확인하고 관리하세요.</p>
    </div>

    <!-- Toolbar: Search & Action -->
    <div class="row g-3 mb-4 justify-content-between align-items-center">
        <div class="col-md-6 col-lg-6 d-flex align-items-center">
            <div class="input-group shadow-sm me-3">
                <span class="input-group-text bg-white border-end-0">
                    <svg width="16" height="16" viewBox="0 0 24 24" ...></svg>
                </span>
                <input id="groupSearch" type="text" class="form-control border-start-0 ps-0" placeholder="그룹 이름으로 검색">
            </div>
            
        </div>
        <div class="col-auto">
            <a href="${pageContext.request.contextPath}/group/create" class="btn btn-primary btn-lg shadow-sm px-4">
                <i class="bi bi-plus-lg"></i> 새 그룹 생성
            </a>
        </div>
    </div>
    
    <!-- 내 그룹만 보기 체크박스 -->
    <div class="form-check form-switch mb-4">
        <input class="form-check-input" type="checkbox" id="myGroupsOnly">
        <label class="form-check-label" for="myGroupsOnly">내 그룹</label>
    </div>

    <!-- Group Grid -->
    <div id="groupGrid" class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:forEach var="g" items="${groups}">
            <div class="col group-item" 
                 data-name="${g.name}" 
                 data-mygroup="${myGroupIds != null && myGroupIds.contains(g.id) ? 'true' : 'false'}">
                <div class="card h-100 border-0 shadow-sm hover-shadow transition">
                    <div class="card-body p-4">
                        <div class="d-flex align-items-center mb-3">
                            <!-- Status Indicator -->
                            <div class="rounded-circle me-2 ${g.publicStatus ? 'bg-success' : 'bg-warning'}" 
                                 style="width: 12px; height: 12px;" 
                                 title="${g.publicStatus ? '공개' : '비공개'}"></div>
                            <span class="badge rounded-pill bg-light text-primary border border-primary-subtle">
                                ${g.publicStatus ? 'Public' : 'Private'}
                            </span>
                        </div>
                        
                        <h5 class="card-title fw-bold mb-2 text-dark">${g.name}</h5>
                        
                        <div class="card-text small text-muted mb-4">
                            <div class="mb-1">
                                <strong>멤버:</strong> ${memberCounts[g.id]} / ${g.maxMember} 명
                            </div>
                            <div>
                                <strong>생성일:</strong> ${g.formattedCreatedAt}
                            </div>
                        </div>

                        <div class="d-grid">
                            <a href="${pageContext.request.contextPath}/group/detail?id=${g.id}" 
                               class="btn btn-outline-primary border-2 fw-bold">상세보기</a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Empty State (Hidden by default) -->
    <div id="noResults" class="text-center py-5 d-none">
        <p class="text-muted fs-5">검색 결과와 일치하는 그룹이 없습니다.</p>
    </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/groups.js"></script>
</body>
</html>