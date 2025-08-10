<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>To Do List</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/todoCreate.css">
</head>
<body class="todo-create-body">

  <div class="todo-form-container">
    <h2 class="todo-form-title">📝 새로운 할 일 추가</h2>

    <form class="todo-form" action="${pageContext.request.contextPath}/todos/create" method="post">
      <!-- 그룹ID: 세션에 있는 currentGroupId 사용 권장 -->
      <input type="hidden" name="group_id" value="${sessionScope.currentGroupId}" />

      <!-- 제목 -->
      <div class="form-group">
        <label for="title">제목</label>
        <input type="text" id="title" name="title" required placeholder="예: 화장실 청소, 분리수거">
      </div>

      <!-- 담당자 -->
      <div class="form-group">
        <label for="assigned_to">담당자</label>
        <select id="assigned_to" name="assigned_to">
          <option value="">-- 담당자 선택 안 함 --</option>
          <c:forEach var="member" items="${memberList}">
            <option value="${member.id}">${member.nickname}</option>
          </c:forEach>
        </select>
      </div>

      <!-- 2열 영역: 마감일/난이도 -->
      <div class="form-row">
        <div class="form-group">
          <label for="due_date">마감일</label>
          <input type="date" id="due_date" name="due_date">
        </div>

        <div class="form-group">
          <label for="difficulty_point">난이도 (1~5)</label>
          <select id="difficulty_point" name="difficulty_point">
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3" selected>3</option>
            <option value="4">4</option>
            <option value="5">5</option>
          </select>
        </div>
      </div>

      <!-- 완료 여부: 신규 생성은 기본 '미완료' 고정 추천 -->
      <div class="form-group">
        <label for="completed">완료 여부</label>
        <select id="completed" name="completed">
          <option value="false" selected>미완료</option>
          <option value="true">완료</option>
        </select>
        <p class="hint">* 새로 만드는 할 일은 보통 '미완료'로 두는 걸 추천!</p>
      </div>

      <!-- 버튼 -->
      <div class="form-btns">
        <button type="submit" class="btn-submit">등록</button>
        <a href="${pageContext.request.contextPath}/todos" class="btn-cancel">뒤로가기</a>
      </div>
    </form>
  </div>

</body>
</html>
