<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>그룹 정보 수정 | Fairplay</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css">
  <script src="https://unpkg.com/lucide@latest"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/groupEditForm.css" />
</head>
<body class="bg-light" data-context-path="${pageContext.request.contextPath}">

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-lg-7">
      <div class="text-center mb-5">
        <h2 class="fw-bold text-primary">그룹 정보 수정</h2>
      </div>

      <div class="card shadow-sm border-0">
        <div class="card-body p-4 p-md-5">
          <form id="groupEditForm" method="post" action="${pageContext.request.contextPath}/group/update" enctype="multipart/form-data">
            <input type="hidden" name="id" value="${group.id}" />
            <input type="hidden" name="imageDeleted" id="imageDeleted" value="false" />

            <div class="mb-5 text-center">
              <label class="form-label fw-bold d-block mb-3 text-start">그룹 대표 이미지</label>
              <div class="image-upload-wrapper mx-auto">
                <input type="file" name="file" id="groupImageInput" accept="image/*" class="d-none" />
                <label for="groupImageInput" class="image-preview-placeholder shadow-sm">
                  <c:choose>
                    <c:when test="${not empty group.profile_img}">
                      <img id="groupImagePreview" src="${pageContext.request.contextPath}/upload/${group.profile_img}" class="img-fluid">
                      <div id="placeholderContent" style="display: none;"><i data-lucide="camera"></i></div>
                    </c:when>
                    <c:otherwise>
                      <div id="placeholderContent"><i data-lucide="camera"></i></div>
                      <img id="groupImagePreview" src="" class="img-fluid" style="display: none;">
                    </c:otherwise>
                  </c:choose>
                  <div class="image-overlay"><span class="small">변경</span></div>
                </label>
                <button type="button" id="clearImageBtn" class="btn btn-sm btn-danger rounded-circle position-absolute" 
                        style="${not empty group.profile_img ? 'display: flex;' : 'display: none;'} top: -10px; right: -10px;">
                   <i data-lucide="x" style="width: 14px;"></i>
                </button>
              </div>
            </div>

            <div class="mb-4">
              <label class="form-label fw-bold">그룹 이름</label>
              <input class="form-control" type="text" name="name" value="${group.name}" required />
            </div>

            <div class="row g-3 mb-4">
              <div class="col-md-6">
                <label class="form-label fw-bold">공개 여부</label>
                <div class="btn-group w-100">
                  <input type="radio" class="btn-check" name="publicStatus" id="pubTrue" value="true" <c:if test="${group.publicStatus}">checked</c:if>>
                  <label class="btn btn-outline-primary" for="pubTrue">공개</label>
                  <input type="radio" class="btn-check" name="publicStatus" id="pubFalse" value="false" <c:if test="${!group.publicStatus}">checked</c:if>>
                  <label class="btn btn-outline-primary" for="pubFalse">비공개</label>
                </div>
              </div>
              <div class="col-md-6">
                <label class="form-label fw-bold">최대 인원</label>
                <input type="number" name="maxMember" class="form-control" value="${group.maxMember}" min="1" />
              </div>
            </div>

            <!-- 초대 코드: 수정 시에도 8자리 유지 필수 -->
            <div class="mb-4">
              <label class="form-label fw-bold">초대 코드 (8자리 필수)</label>
              <div class="input-group input-group-lg">
                <input id="codeInput" class="form-control bg-white" type="text" 
                       name="code" value="${group.code}" maxlength="8" minlength="8" required 
                       style="letter-spacing: 0.2em; text-transform: uppercase;" />
                <button type="button" class="btn btn-outline-primary" id="genCodeBtn">재생성</button>
              </div>
              <div class="form-text mt-2 text-danger" id="codeError" style="display:none;">8자리 코드가 필요합니다.</div>
            </div>

            <div class="mb-5">
              <label class="form-label fw-bold">그룹장 한마디</label>
              <textarea class="form-control" name="admin_comment" rows="3">${group.admin_comment}</textarea>
            </div>

            <div class="d-flex gap-3">
              <a href="${pageContext.request.contextPath}/group/detail?id=${group.id}" class="btn btn-outline-secondary btn-lg flex-grow-1 py-3 fw-bold">취소</a>
              <button type="submit" class="btn btn-primary btn-lg flex-grow-1 py-3 fw-bold">수정 완료</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/groupEditForm.js"></script>
<script>lucide.createIcons();</script>
</body>
</html>