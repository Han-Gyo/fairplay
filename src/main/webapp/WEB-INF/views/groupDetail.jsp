<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>그룹 상세</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/group.css" />
</head>
<body class="group-body" data-context-path="${pageContext.request.contextPath}">
<div class="group-container">

  <h1 class="page-title">📌 ${group.name}</h1>

  <div class="card">
    <div class="grid grid-2">
      <div>
        <div class="section-title">그룹 정보</div>
        <div class="pills">
          <span class="pill">멤버 ${currentMemberCount} / ${group.maxMember}</span>
          <span class="pill">생성일 ${group.formattedCreatedAt}</span>
          <span class="pill"><c:choose><c:when test="${group.publicStatus}">공개</c:when><c:otherwise>비공개</c:otherwise></c:choose></span>
        </div>

        <div class="sep"></div>

        <div class="section-title">그룹 소개</div>
        <p style="margin:6px 0 0;">${empty group.description ? '설명이 없어요.' : group.description}</p>

        <div class="sep"></div>

        <c:if test="${not empty group.profile_img}">
		  <div class="section-title">대표 이미지</div>
		  <!-- 썸네일: 클릭하면 라이트박스 오픈 -->
		  <img
		    class="img-thumb"
		    src="${pageContext.request.contextPath}/upload/${group.profile_img}"
		    data-full="${pageContext.request.contextPath}/upload/${group.profile_img}"
		    alt="대표 이미지" />
		</c:if>

        
        <div class="sep"></div>

		<div class="section-title">그룹장 한마디</div>
		<p style="margin:6px 0 0;">
		  <c:choose>
		    <c:when test="${not empty group.admin_comment}">
		      <c:out value="${group.formattedAdminComment}" escapeXml="false"/>
		    </c:when>
		    <c:otherwise>
		      아직 작성된 한마디가 없어요.
		    </c:otherwise>
		  </c:choose>
		</p>
        
      </div>

      <div>
        <c:if test="${not empty loginMember && loginMember.id == group.leaderId}">
          <div class="section-title">초대 코드</div>
          <div class="inline">
            <input id="codeInput" class="input" value="${group.code}" readonly />
            <button type="button" class="btn btn-gray" id="copyCodeBtn">복사</button>
          </div>
          <div class="help">멤버가 이 코드를 입력하면 그룹에 합류할 수 있어요.</div>
          <div class="sep"></div>
        </c:if>

        <div class="section-title">빠른 작업</div>
        <div class="actions">
        
        <c:if test="${not empty loginMember and isMember}">
		  <div class="sep"></div>
		  <div class="actions">
		    <c:choose>
		      <!-- ✅ 리더: ‘리더 위임 후 탈퇴’만 허용 (개별 탈퇴 X) -->
		      <c:when test="${loginMember.id == group.leaderId}">
		        <a class="btn btn-danger"
		           href="${pageContext.request.contextPath}/groupmember/transferForm?groupId=${group.id}">
		          리더 위임 후 탈퇴
		        </a>
		      </c:when>
		
		      <!-- ✅ 일반 멤버: 본인 탈퇴 버튼 -->
		      <c:otherwise>
		        <form action="${pageContext.request.contextPath}/groupmember/delete" method="post"
		              onsubmit="return confirm('정말 탈퇴하시겠어요?');" style="display:inline;">
		          <input type="hidden" name="groupId" value="${group.id}" />
		          <input type="hidden" name="memberId" value="${loginMember.id}" />
		          <button type="submit" class="btn btn-danger">그룹 탈퇴</button>
		        </form>
		      </c:otherwise>
		    </c:choose>
		  </div>
		</c:if>
        
          <a class="btn btn-outline" href="${pageContext.request.contextPath}/group/groups">목록</a>

          <c:if test="${not empty loginMember && loginMember.id == group.leaderId}">
            <a class="btn btn-sky" href="${pageContext.request.contextPath}/group/edit?id=${group.id}">정보 수정</a>
            <a class="btn btn-danger" data-delete-id="${group.id}" href="${pageContext.request.contextPath}/group/delete?id=${group.id}">그룹 삭제</a>
          </c:if>

          <c:choose>
            <c:when test="${empty loginMember}">
              <a class="btn btn-outline" href="${pageContext.request.contextPath}/member/setRedirect?redirectURI=/group/detail?id=${group.id}">로그인 후 가입</a>
            </c:when>
            <c:when test="${isMember}">
              <button class="btn btn-gray" disabled>이미 가입됨</button>
            </c:when>
            <c:otherwise>
              <a class="btn btn-sky" href="${pageContext.request.contextPath}/groupmember/create?groupId=${group.id}">이 그룹 가입</a>
            </c:otherwise>
          </c:choose>

          <c:choose>
            <c:when test="${group.publicStatus}">
              <a class="btn btn-outline" href="${pageContext.request.contextPath}/groupmember/list?groupId=${group.id}">멤버 보기</a>
            </c:when>
            <c:otherwise>
              <c:if test="${not empty loginMember && isMember}">
                <a class="btn btn-outline" href="${pageContext.request.contextPath}/groupmember/list?groupId=${group.id}">멤버 보기</a>
              </c:if>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
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
