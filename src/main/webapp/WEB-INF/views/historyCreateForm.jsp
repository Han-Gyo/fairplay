<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<% java.time.LocalDate today = java.time.LocalDate.now(); %>
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
			  <select name="todo_id" id="todo_id" required onchange="updateScore(this)">
			    <c:forEach var="todo" items="${todoList}">
			      <option value="${todo.id}" 
			              data-score="${todo.difficulty_point}" 
			              <c:if test="${todo.id == selectedTodoId}">selected</c:if>>
			        ${todo.title}
			      </option>
			    </c:forEach>
			  </select>
			</div>

      <!-- 담당자 선택 -->
      <div class="form-group">
        <label for="member_id">담당자</label>
        <select name="member_id" id="member_id" required>
          <option value="${loginMember.id}">${loginMember.nickname}</option>
        </select>
      </div>

      <!-- 완료 날짜 -->
      <div class="form-group">
        <label for="completed_at">완료 날짜</label>
        <input type="date" id="completed_at" name="completed_at" value="<%= today %>" required>
      </div>

      <!-- 점수 입력 (1~5점) -->
      <div class="form-group">
			  <label for="score">점수 (1~5)</label>
			  <select name="score" id="score" required>
			    <option value="">점수를 선택해주세요</option>
			    <c:forEach begin="1" end="5" var="i">
			      <option value="${i}" <c:if test="${i == score}">selected</c:if>>${i}</option>
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

<script>
function updateScore(selectElement) {
// 선택된 할 일의 data-score 값을 가져옴
const selectedOption = selectElement.options[selectElement.selectedIndex];
const score = selectedOption.getAttribute('data-score');

// 점수 셀렉트 박스(id="score")의 값을 해당 점수로 변경
if(score) {
    document.getElementById('score').value = score;
}
}

// 페이지 로드 시에도 한 번 실행해서 초기값 세팅
window.onload = function() {
	const todoSelect = document.getElementById('todo_id');
	if(todoSelect.value) {
	    updateScore(todoSelect);
	}
};
</script>

</html>
