<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

<title>히스토리 상세 보기</title>
</head>
<body>

<h2>📄 히스토리 상세</h2>

<p><strong>할 일 : </strong> ${history.todo.title}</p>
<p><strong>수행자 : </strong> ${history.member.nickname}</p>
<p><strong>완료일 : </strong> <fmt:formatDate value="${history.completed_at}" pattern="yyyy-MM-dd HH:mm:ss" /></p>
<p><strong>점수 : </strong> ${history.score}</p>
<p><strong>메모 : </strong> ${history.memo}</p>
<!-- 인증사진 -->
<c:if test="${not empty history.photo}">
    <p><strong>인증사진</strong></p>
    <img src="${pageContext.request.contextPath}/upload/${history.photo}" alt="인증사진" width="300"/>
</c:if>

<hr>
<h3>💬 댓글</h3>

<!-- 🔄 댓글 목록 -->
<c:forEach var="comment" items="${commentList}">
  <div class="comment-wrapper" data-comment-id="${comment.id}" style="position: relative; border:1px solid #ccc; padding:10px; margin-bottom:10px;">
    <div class="comment-header">
      <strong>${comment.nickname}</strong>
      <small>
        (<fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" />)
      </small>

      <c:if test="${loginMember.id == comment.memberId || loginMember.role == 'ADMIN'}">
        <!-- ⋮ 더보기 버튼 -->
        <span class="material-icons menu-toggle" onclick="toggleMenu(this)" style="float: right; cursor: pointer;">more_vert</span>
				
        <!-- 드롭다운 메뉴 -->
        <div class="comment-menu" style="display:none; position:absolute; right:10px; top:30px; background:#fff; border:1px solid #ddd; border-radius:4px; z-index:999; padding:5px;">
          <button onclick="startEdit(this)">수정</button><br/>
          <form action="${pageContext.request.contextPath}/history/comments/delete" method="post" onsubmit="return confirm('댓글을 삭제할까요?')" style="display:inline;">
            <input type="hidden" name="id" value="${comment.id}" />
            <input type="hidden" name="history_id" value="${history.id}" />
            <button type="submit">삭제</button>
          </form>
        </div>
      </c:if>
    </div>

    <!-- 댓글 본문 -->
    <div class="comment-content">
      <p>${comment.content}</p>
    </div>
  </div>
</c:forEach>


<!-- ✏️ 댓글 작성 폼 -->
<form action="${pageContext.request.contextPath}/history/comments/add" method="post">
    <input type="hidden" name="history_id" value="${history.id}" />
    <textarea name="content" rows="3" cols="50" placeholder="댓글을 입력하세요" required></textarea><br><br>
    <button type="submit">➕ 댓글 작성</button>
</form>

<br>
<a href="${pageContext.request.contextPath}/history/all">← 전체 히스토리로 돌아가기</a>

</body>

<script>
  function toggleMenu(btn) {
    const menu = btn.nextElementSibling;
    menu.style.display = menu.style.display === 'none' ? 'block' : 'none';
  }

  function startEdit(btn) {
    const wrapper = btn.closest(".comment-wrapper");
    const contentDiv = wrapper.querySelector(".comment-content");
    const original = contentDiv.innerText.trim();

    contentDiv.innerHTML = `
      <textarea class="edit-area" rows="3" cols="50">\${original}</textarea><br/>
      <button onclick="submitEdit(\${wrapper.dataset.commentId}, this)">등록</button>
      <button onclick="cancelEdit(this)">취소</button>
    `;

    wrapper.querySelector(".comment-menu").style.display = 'none';
  }

  function cancelEdit(btn) {
    const wrapper = btn.closest(".comment-wrapper");
    const original = wrapper.querySelector(".edit-area").defaultValue;
    wrapper.querySelector(".comment-content").innerHTML = `<p>\${original}</p>`;
  }

  function submitEdit(commentId, btn) {
    const wrapper = btn.closest(".comment-wrapper");
    const content = wrapper.querySelector(".edit-area").value;

    if (!content.trim()) {
      alert("내용을 입력해줘야 수정할 수 있어!");
      return;
    }

    $.post("${pageContext.request.contextPath}/history/comments/update", {
      id: commentId,
      content: content
    }, function (res) {
      if (res === "success") {
        wrapper.querySelector(".comment-content").innerHTML = `<p>\${content}</p>`;
      } else {
        alert("수정 실패 😢");
      }
    });
  }
</script>