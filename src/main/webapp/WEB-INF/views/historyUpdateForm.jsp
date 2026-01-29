<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>기록 수정</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/historyUpdate.css">
</head>
<body class="history-update-body">

  <div class="history-form-container">
    <h2 class="history-form-title">✏️ 집안일 기록 수정</h2>

    <form action="${pageContext.request.contextPath}/history/update" method="post" enctype="multipart/form-data">
      
      <input type="hidden" name="id" value="${history.id}" />
      <input type="hidden" name="todo_id" value="${history.todo.id}">
      <input type="hidden" name="member_id" value="${history.member.id}">

      <div class="form-group">
        <label>할 일</label>
        <select name="todo_id" required disabled> 
          <option>${history.todo.title}</option> 
        </select>
      </div>

      <div class="form-group">
        <label>담당자</label>
        <select name="member_id" required disabled>
          <option>${history.member.nickname}</option>
        </select>
      </div>

      <div class="form-row">
        <div class="form-group">
          <fmt:formatDate value="${history.completed_at}" pattern="yyyy-MM-dd" var="completedDate" />
          <label>완료 날짜</label> 
          <input type="date" name="completed_at" value="${completedDate}" required />
        </div>

        <div class="form-group">
          <label>점수 (1~5)</label>
          <select name="score">
            <c:forEach begin="1" end="5" var="i">
              <option value="${i}" <c:if test="${history.score == i}">selected</c:if>>${i}</option>
            </c:forEach>
          </select>
        </div>
      </div>

      <div class="form-group">
        <label>메모</label>
        <textarea name="memo" rows="4">${history.memo}</textarea>
      </div>

      <div class="form-group">
        <label>인증샷 업로드</label>
        <input type="file" name="photo" accept="image/*" />
      </div>

      <div class="form-btns">
        <button type="submit" class="btn-submit">수정 완료</button>
        <a href="javascript:history.back();" class="btn-cancel" style="text-decoration: none; display: flex; align-items: center; justify-content: center;">취소</a>
      </div>
    </form>
  </div>

</body>
</html>