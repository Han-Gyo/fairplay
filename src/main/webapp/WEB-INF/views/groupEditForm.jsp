<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>그룹 수정</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group.css" />
</head>
<body class="group-body" data-context-path="${pageContext.request.contextPath}">
<div class="group-container">

  <h1 class="page-title">🛠 그룹 정보 수정</h1>

  <div class="card">
    <form class="form" method="post" action="${pageContext.request.contextPath}/group/update" enctype="multipart/form-data">
      <input type="hidden" name="id" value="${group.id}" />

      <div class="form-row">
        <label class="label">그룹 이름</label>
        <input class="input" type="text" name="name" value="${group.name}" required />
      </div>

      <div class="form-row">
        <label class="label">설명</label>
        <textarea class="textarea" name="description">${group.description}</textarea>
      </div>

      <div class="form-row">
        <label class="label">공개 여부</label>
        <div class="inline">
          <label class="inline"><input type="radio" name="publicStatus" value="true" <c:if test="${group.publicStatus}">checked</c:if> /> 공개</label>
          <label class="inline"><input type="radio" name="publicStatus" value="false" <c:if test="${!group.publicStatus}">checked</c:if> /> 비공개</label>
        </div>
      </div>

      <div class="form-row">
        <label class="label">최대 인원</label>
        <input class="input" type="number" name="maxMember" value="${group.maxMember}" min="1" />
      </div>

      <div class="form-row">
        <label class="label">초대 코드</label>
        <div class="inline" style="width:100%;">
          <input id="codeInput" class="input" type="password" name="code" maxlength="8" value="${group.code}" />
          <button type="button" class="btn btn-outline" id="genCodeBtn">재생성</button>
          <button type="button" class="btn btn-gray" id="copyCodeBtn">복사</button>
        </div>
      </div>

      <!-- ✅ 대표 이미지 + 미리보기 (기존 이미지가 있으면 초기에 보여줌) -->
		<div class="form-row">
		  <label class="label">대표 이미지</label>
		  <div class="inline" style="width:100%;">
		    <input class="input" type="file" name="file" id="groupImageInput" accept="image/*" />
		    <button type="button" class="btn btn-gray" id="clearImageBtn" style="display:none;">선택 해제</button>
		  </div>
		
		  <div class="img-preview-wrap">
		    <c:choose>
		      <c:when test="${not empty group.profile_img}">
		        <!-- ✅ 클릭 확대를 위해 img-thumb + data-full 추가 -->
		        <img id="groupImagePreview"
		             class="img-preview img-thumb"
		             src="${pageContext.request.contextPath}/upload/${group.profile_img}"
		             data-full="${pageContext.request.contextPath}/upload/${group.profile_img}"
		             alt="미리보기" />
		        <script>
		          // 초기에도 '선택 해제' 버튼 노출
		          window.addEventListener('DOMContentLoaded', function(){
		            var b = document.getElementById('clearImageBtn');
		            if (b) b.style.display = 'inline-block';
		          });
		        </script>
		      </c:when>
		      <c:otherwise>
		        <img id="groupImagePreview" class="img-preview" alt="미리보기" style="display:none;" />
		      </c:otherwise>
		    </c:choose>
		    <div class="help">새 이미지를 선택하면 미리보기로 교체됩니다. 이미지를 클릭하면 크게 볼 수 있어요.</div>
		  </div>
		</div>


      <div class="form-row">
        <label class="label">그룹장 한마디</label>
        <textarea class="textarea" name="admin_comment" rows="4">${group.admin_comment}</textarea>
      </div>

      <div class="sep"></div>

      <div class="inline" style="justify-content:flex-end;">
        <a class="btn btn-gray" href="${pageContext.request.contextPath}/group/detail?id=${group.id}">취소</a>
        <button type="submit" class="btn btn-sky">저장</button>
      </div>
    </form>
  </div>

</div>

<!-- Lightbox -->
<div id="imgLightbox" class="lightbox" aria-hidden="true">
  <button class="lightbox-close" aria-label="닫기">×</button>
  <img id="lightboxImg" alt="확대 이미지" />
</div>

<script src="${pageContext.request.contextPath}/resources/js/group.js"></script>
</body>
</html>
