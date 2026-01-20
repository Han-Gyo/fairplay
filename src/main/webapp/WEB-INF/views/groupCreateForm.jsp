<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>그룹 만들기</title>
  <!-- Bootstrap + Bootswatch Minty -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/groupCreateForm.css" />
</head>
<body class="group-body" data-context-path="${pageContext.request.contextPath}">
<div class="container mt-5">
  <h1 class="page-title text-center mb-4">새 그룹 만들기</h1>

  <div class="card shadow-lg">
    <div class="card-body">
      <form id="groupForm" class="form" method="post" action="${pageContext.request.contextPath}/group/create" enctype="multipart/form-data">
        
        <!-- 그룹 이름 -->
        <div class="mb-3">
          <label class="form-label fw-bold">그룹 이름</label>
          <input class="form-control" type="text" name="name" placeholder="그룹 이름" required />
        </div>

        <!-- 초대 코드 -->
        <div class="mb-3">
          <label class="form-label fw-bold">초대 코드</label>
          <div class="d-flex gap-2">
            <input id="codeInput" class="form-control" type="password" name="code" maxlength="8" placeholder="8자리" required />
            <button type="button" class="btn btn-success" id="genCodeBtn">생성</button>
            <button type="button" class="btn btn-outline-secondary" id="copyCodeBtn">복사</button>
          </div>
          <div class="form-text">항상 마스킹됩니다. 복사 버튼으로 공유하세요.</div>
        </div>

        <!-- 설명 -->
        <div class="mb-3">
          <label class="form-label fw-bold">설명(선택)</label>
          <textarea class="form-control" name="description" placeholder="그룹 소개를 적어주세요."></textarea>
        </div>

        <!-- 최대 인원 -->
        <div class="mb-3">
          <label class="form-label fw-bold">최대 인원</label>
          <input class="form-control" type="number" name="maxMember" value="4" min="1" />
        </div>

        <!-- 공개 여부 -->
        <div class="mb-3">
          <label class="form-label fw-bold">공개 여부</label>
          <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="publicStatus" value="true" checked />
            <label class="form-check-label">공개</label>
          </div>
          <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="publicStatus" value="false" />
            <label class="form-check-label">비공개</label>
          </div>
        </div>

        <!-- 대표 이미지 -->
        <div class="mb-3">
          <label class="form-label fw-bold">대표 이미지</label>
          <div class="d-flex gap-2 align-items-center">
            <!-- 실제 input은 숨기고 label을 버튼처럼 -->
            <input type="file" name="file" id="groupImageInput" accept="image/*" style="display:none;" />
            <label for="groupImageInput" class="btn btn-outline-secondary">파일 선택</label>
            <button type="button" class="btn btn-outline-secondary" id="clearImageBtn" style="display:none;">선택 해제</button>
          </div>
          <div class="form-text">이미지 선택 시 아래에 미리보기가 표시됩니다.</div>
          <div class="img-preview-wrap mt-2">
            <img id="groupImagePreview" class="img-preview img-thumbnail" alt="미리보기" style="display:none;" />
          </div>
        </div>

        <!-- 관리자 한마디 -->
        <div class="mb-3">
          <label class="form-label fw-bold">관리자 한마디</label>
          <textarea class="form-control" name="admin_comment" rows="4" placeholder="팀원에게 한마디!"></textarea>
        </div>

        <!-- 버튼 -->
        <div class="d-flex justify-content-end gap-2">
          <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/group/groups">취소</a>
          <button type="submit" class="btn btn-success">생성하기</button>
        </div>
      </form>
    </div>
  </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/groupCreateForm.js"></script>
</body>
</html>