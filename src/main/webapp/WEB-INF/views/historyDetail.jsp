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
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/history-detail.css" />
</head>
<body>

  <div class="post-container">
    <!-- 게시글 헤더 -->
    <header class="post-header">
      <h2 class="post-title">${history.todo.title}</h2>
      <div class="post-meta">
        <span><b>수행자</b> ${history.member.nickname}</span>
        <span><b>완료일</b> <fmt:formatDate value="${history.completed_at}" pattern="yyyy-MM-dd" /></span>
        <span><b>점수</b> ${history.score}점</span>
      </div>
    </header>

    <!-- 게시글 본문 -->
    <article class="post-content">
      <c:if test="${not empty history.photo}">
        <div class="post-photo">
          <img src="${pageContext.request.contextPath}/upload/${history.photo}" alt="인증사진" />
        </div>
      </c:if>

      <div class="memo-box">
        <strong>메모</strong>
        <p style="margin-top: 10px; color: #4b5563;">
          <c:choose>
            <c:when test="${not empty history.memo}">${history.memo}</c:when>
            <c:otherwise>남겨진 메모가 없습니다.</c:otherwise>
          </c:choose>
        </p>
      </div>
    </article>

    <!-- 댓글 영역 -->
    <section class="comment-section">
      <h3 class="comment-section-title">댓글</h3>

      <!-- 댓글 목록 -->
      <div class="comment-list">
        <c:forEach var="comment" items="${commentList}">
          <div class="comment-item" data-comment-id="${comment.id}">
            <div class="comment-user-info">
              <div>
                <strong>${comment.nickname}</strong>
                <small><fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm" /></small>
              </div>

              <c:if test="${loginMember.id == comment.memberId || loginMember.role == 'ADMIN'}">
                <span class="material-icons menu-toggle" onclick="toggleMenu(this)">more_vert</span>
                <div class="comment-menu" style="display:none;">
                  <button onclick="startEdit(this)">수정</button>
                  <form action="${pageContext.request.contextPath}/history/comments/delete" method="post" onsubmit="return confirm('댓글을 삭제할까요?')" style="margin:0;">
                    <input type="hidden" name="id" value="${comment.id}" />
                    <input type="hidden" name="history_id" value="${history.id}" />
                    <button type="submit">삭제</button>
                  </form>
                </div>
              </c:if>
            </div>
            <div class="comment-content">
              <p class="comment-text">${comment.content}</p>
            </div>
          </div>
        </c:forEach>
      </div>

      <!-- 댓글 작성 폼 -->
      <div class="comment-input-box">
        <form action="${pageContext.request.contextPath}/history/comments/add" method="post" style="overflow:hidden;">
          <input type="hidden" name="history_id" value="${history.id}" />
          <textarea name="content" rows="3" placeholder="댓글을 입력하세요" required></textarea>
          <button type="submit" class="btn-submit">댓글 등록</button>
        </form>
      </div>
    </section>

    <!-- 하단 링크 -->
    <footer class="footer-links">
      <a href="${pageContext.request.contextPath}/history/all">← 목록으로 돌아가기</a>
    </footer>
  </div>

  <script>
    function toggleMenu(btn) {
      const menu = $(btn).next('.comment-menu');
      $('.comment-menu').not(menu).hide();
      menu.toggle();
    }

    $(document).on("click", function(e) {
      if (!$(e.target).closest(".menu-toggle").length) {
        $(".comment-menu").hide();
      }
    });

    function startEdit(btn) {
      const item = btn.closest(".comment-item");
      const contentDiv = item.querySelector(".comment-content");
      const original = contentDiv.innerText.trim();

      contentDiv.innerHTML = `
        <textarea class="edit-area" rows="2" style="margin-top:10px;">\${original}</textarea>
        <div style="display:flex; gap:8px; margin-top:8px; justify-content: flex-end;">
          <button class="btn-submit" style="float:none; padding:6px 16px; font-size:13px;" onclick="submitEdit(\${item.dataset.commentId}, this)">수정</button>
          <button class="btn-submit" style="float:none; padding:6px 16px; font-size:13px; background:#adb5bd;" onclick="cancelEdit(this)">취소</button>
        </div>
      `;
      $(item).find(".comment-menu").hide();
    }

    function cancelEdit(btn) {
      const item = btn.closest(".comment-item");
      const original = item.querySelector(".edit-area").defaultValue;
      item.querySelector(".comment-content").innerHTML = `<p class="comment-text">\${original}</p>`;
    }

    function submitEdit(commentId, btn) {
      const item = btn.closest(".comment-item");
      const content = item.querySelector(".edit-area").value;

      if (!content.trim()) {
        alert("내용을 입력해줘야 수정할 수 있어!");
        return;
      }

      $.post("${pageContext.request.contextPath}/history/comments/update", {
        id: commentId,
        content: content
      }, function (res) {
        if (res === "success") {
          item.querySelector(".comment-content").innerHTML = `<p class="comment-text">\${content}</p>`;
        } else {
          alert("수정 실패");
        }
      });
    }
  </script>
</body>
</html>