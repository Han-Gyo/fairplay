<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>기록 등록</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/historyCreate.css">
</head>
<body class="history-create-body">

  <!-- 폼 전체 박스 -->
  <div class="form-container">
    <h2 class="form-title">📝 집안일 수행 기록 등록</h2>

    <!-- 파일 업로드 시 enctype 필수 -->
    <form action="${pageContext.request.contextPath}/history/create" method="post" enctype="multipart/form-data">

      <!-- 할 일 선택 -->
      <div class="form-group">
        <label for="todo_id">할 일</label>
        <select name="todo_id" id="todo_id" required>
          <c:forEach var="todo" items="${todoList}">
            <option value="${todo.id}"
              <c:if test="${todo.id == selectedTodoId}">selected</c:if>>
              ${todo.title}
            </option>
          </c:forEach>
        </select>
      </div>

      <!-- 수행자 선택 -->
      <div class="form-group">
        <label for="member_id">수행자</label>
        <select name="member_id" id="member_id" required>
          <c:forEach var="member" items="${memberList}">
            <option value="${member.id}">${member.nickname}</option>
          </c:forEach>
        </select>
      </div>

      <!-- 완료 날짜 -->
      <div class="form-group">
        <label for="completed_at">완료 날짜</label>
        <input type="date" id="completed_at" name="completed_at" required>
      </div>

      <!-- 점수 입력 (1~5점) -->
      <div class="form-group">
        <label for="score">점수 (1~5)</label>
        <select name="score" id="score" required>
          <option value="">점수를 선택해주세요</option>
          <c:forEach begin="1" end="5" var="i">
            <option value="${i}">${i}</option>
          </c:forEach>
        </select>
      </div>

      <!-- 메모 -->
      <div class="form-group">
        <label for="memo">메모</label>
        <textarea id="memo" name="memo" rows="4" placeholder="상대가 수고한 포인트, 특이사항 등을 적어주세요 :)"></textarea>
      </div>

      <!-- 인증샷 업로드 -->
      <div class="form-group">
        <label for="photo">인증샷</label>
        <input type="file" id="photo" name="photo" accept="image/*">
        <p class="hint">* 이미지 파일만 업로드 가능</p>
      </div>

      <!-- 버튼들 -->
      <div class="form-btns">
        <button type="submit" class="btn-submit">등록</button>
        <a href="${pageContext.request.contextPath}/history/all" class="btn-cancel">취소</a>
      </div>
    </form>
  </div>

</body>
</html>
