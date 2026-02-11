<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>새 그룹 만들기 | Fairplay</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css">
  <script src="https://unpkg.com/lucide@latest"></script>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/groupCreateForm.css" />
</head>
<body class="bg-light" data-context-path="${pageContext.request.contextPath}">

<div class="container py-5">
  <div class="row justify-content-center">
    <div class="col-lg-7">
      <div class="text-center mb-5">
        <h2 class="fw-bold text-primary">새 그룹 만들기</h2>
        <p class="text-secondary">새로운 팀원을 모집하고 활동을 시작해보세요.</p>
      </div>

      <div class="card shadow-sm border-0">
        <div class="card-body p-4 p-md-5">
          <form id="groupForm" method="post" action="${pageContext.request.contextPath}/group/create" enctype="multipart/form-data">
            
            <!-- 이미지 섹션 -->
            <div class="mb-5 text-center">
              <label class="form-label fw-bold d-block mb-3 text-start">그룹 대표 이미지</label>
              <div class="image-upload-wrapper mx-auto">
                <input type="file" name="file" id="groupImageInput" accept="image/*" class="d-none" />
                <label for="groupImageInput" class="image-preview-placeholder shadow-sm">
                  <div id="placeholderContent">
                    <i data-lucide="camera" class="mb-2 text-muted" style="width: 40px; height: 40px;"></i>
                    <p class="small text-muted mb-0">사진 업로드</p>
                  </div>
                  <img id="groupImagePreview" src="" alt="Preview" class="img-fluid" style="display: none;">
                  <div class="image-overlay">
                    <span class="text-white small">이미지 변경</span>
                  </div>
                </label>
                <button type="button" id="clearImageBtn" class="btn btn-sm btn-danger rounded-circle position-absolute" style="display: none; top: -10px; right: -10px; z-index: 10;">
                   <i data-lucide="x" style="width: 16px; height: 16px;"></i>
                </button>
              </div>
            </div>

            <div class="mb-4">
              <label class="form-label fw-bold">그룹 이름</label>
              <input class="form-control form-control-lg" type="text" name="name" placeholder="그룹 이름을 입력하세요" required />
            </div>

            <div class="mb-4">
              <label class="form-label fw-bold">그룹 설명</label>
              <textarea class="form-control" name="description" rows="3"></textarea>
            </div>

            <div class="row g-3 mb-4">
              <div class="col-md-6">
                <label class="form-label fw-bold">공개 여부</label>
                <div class="btn-group w-100" role="group">
                  <input type="radio" class="btn-check" name="publicStatus" id="pubTrue" value="true" checked>
                  <label class="btn btn-outline-primary" for="pubTrue">공개</label>
                  <input type="radio" class="btn-check" name="publicStatus" id="pubFalse" value="false">
                  <label class="btn btn-outline-primary" for="pubFalse">비공개</label>
                </div>
              </div>
              <div class="col-md-6">
                <label class="form-label fw-bold">최대 인원</label>
                <div class="input-group">
                  <input type="number" name="maxMember" class="form-control" value="4" min="1" />
                  <span class="input-group-text bg-white">명</span>
                </div>
              </div>
            </div>

            <!-- 초대 코드 섹션: readonly 제거 및 필수 입력 강화 -->
            <div class="mb-4">
              <label class="form-label fw-bold">초대 코드 (8자리 필수)</label>
              <div class="input-group input-group-lg">
                <input id="codeInput" class="form-control bg-white border-end-0" type="text" 
                       name="code" maxlength="8" minlength="8" 
                       placeholder="직접 입력하거나 생성하세요" required 
                       style="letter-spacing: 0.2em; text-transform: uppercase;" />
                <button type="button" class="btn btn-outline-primary" id="genCodeBtn">코드 생성</button>
                <button type="button" class="btn btn-primary" id="copyCodeBtn">복사</button>
              </div>
              <div class="form-text mt-2 text-danger" id="codeError" style="display:none;">
                <i data-lucide="alert-circle" class="me-1" style="width: 14px;"></i>코드는 반드시 8자리여야 합니다.
              </div>
            </div>

            <div class="mb-5">
              <label class="form-label fw-bold">그룹장 한마디</label>
              <textarea class="form-control" name="admin_comment" rows="3"></textarea>
            </div>

            <div class="d-grid gap-2">
              <button type="submit" id="submitBtn" class="btn btn-primary btn-lg py-3 shadow-sm fw-bold">그룹 생성하기</button>
              <a href="${pageContext.request.contextPath}/group/groups" class="btn btn-link text-muted mt-2 text-decoration-none">취소</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/resources/js/groupCreateForm.js"></script>
<script>lucide.createIcons();</script>
</body>
</html>