<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>그룹 만들기</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group.css" />
</head>
<body class="group-body" data-context-path="${pageContext.request.contextPath}">
<div class="group-container">

  <h1 class="page-title">✨ 새 그룹 만들기</h1>

  <div class="card">
    <form class="form" method="post" action="${pageContext.request.contextPath}/group/create" enctype="multipart/form-data">
      <div class="form-row">
        <label class="label">그룹 이름</label>
        <input class="input" type="text" name="name" placeholder="그룹 이름" required />
      </div>

      <div class="form-row">
        <label class="label">초대 코드</label>
        <div class="inline" style="width:100%;">
          <input id="codeInput" class="input" type="password" name="code" maxlength="8" placeholder="8자리" />
          <button type="button" class="btn btn-outline" id="genCodeBtn">생성</button>
          <button type="button" class="btn btn-gray" id="copyCodeBtn">복사</button>
        </div>
        <div class="help">항상 마스킹됩니다. 복사 버튼으로 공유하세요.</div>
      </div>

      <div class="form-row">
        <label class="label">설명(선택)</label>
        <textarea class="textarea" name="description" placeholder="그룹 소개를 적어주세요."></textarea>
      </div>

      <div class="form-row">
        <label class="label">최대 인원</label>
        <input class="input" type="number" name="maxMember" value="10" min="1" />
      </div>

      <div class="form-row">
        <label class="label">공개 여부</label>
        <div class="inline">
          <label class="inline"><input type="radio" name="publicStatus" value="true" checked /> 공개</label>
          <label class="inline"><input type="radio" name="publicStatus" value="false" /> 비공개</label>
        </div>
      </div>

      <!-- ✅ 대표 이미지 + 미리보기 -->
      <div class="form-row">
        <label class="label">대표 이미지</label>
        <div class="inline" style="width:100%;">
          <input class="input" type="file" name="file" id="groupImageInput" accept="image/*" />
          <button type="button" class="btn btn-gray" id="clearImageBtn" style="display:none;">선택 해제</button>
        </div>
        <div class="help">이미지 선택 시 아래에 미리보기가 표시됩니다.</div>
        <div class="img-preview-wrap">
          <img id="groupImagePreview" class="img-preview" alt="미리보기" style="display:none;" />
        </div>
      </div>

      <div class="form-row">
        <label class="label">관리자 한마디</label>
        <textarea class="textarea" name="admin_comment" rows="4" placeholder="팀원에게 한마디!"></textarea>
      </div>

      <div class="sep"></div>

      <div class="inline" style="justify-content:flex-end;">
        <a class="btn btn-gray" href="${pageContext.request.contextPath}/group/groups">취소</a>
        <button type="submit" class="btn btn-sky">생성하기</button>
      </div>
    </form>
  </div>

</div>
<script src="${pageContext.request.contextPath}/resources/js/group.js"></script>
</body>
</html>
