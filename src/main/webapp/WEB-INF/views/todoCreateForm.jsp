<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<% java.time.LocalDate today = java.time.LocalDate.now(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>To Do List</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/todoCreate.css">
</head>
<body class="todo-create-body">

  <div class="todo-form-container">
    <h2 class="todo-form-title">📝 새로운 할 일 추가</h2>

    <form class="todo-form" action="${pageContext.request.contextPath}/todos/create" method="post">
      <!-- 그룹ID: 세션에 있는 currentGroupId 사용 권장 -->
      <!-- <input type="hidden" name="group_id" value="${sessionScope.currentGroupId}" /> -->

		<!-- 그룹 선택 --> 
		<div class="form-group"> 
			<label for="group_id">그룹</label> 
			<select id="group_id" name="group_id"> 
				<c:forEach var="group" items="${joinedGroups}"> 
					<option value="${group.id}" <c:if test="${group.id == groupId}">selected</c:if>> ${group.name} </option> 
				</c:forEach> 
			</select> 
		</div>

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
            <option value="${member.memberId}">${member.nickname}</option>
          </c:forEach>
        </select>
        <div id="assignee-guide" style="color: #ff4d4f; font-size: 12px; display: none; margin-top: 5px;">
			  	완료 상태로 변경하려면 담당자 지정이 필수예요!
				</div>
      </div>

      <!-- 2열 영역: 마감일/난이도 -->
      <div class="form-row">
        <div class="form-group">
          <label for="due_date">마감일</label>
          <input type="date" id="due_date" name="due_date" value="<%= today %>" required>
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

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
  // 요소 미리 찾아두기
  const $groupSelect = $("#group_id");
  const $assigneeSelect = $("#assigned_to");
  const $completedSelect = $("#completed");
  const $guide = $("#assignee-guide");

  // 1. [검증 함수] 완료인데 담당자 없는지 체크
  function checkValidation() {
    const isCompleted = $completedSelect.val() === "true";
    const hasAssignee = $assigneeSelect.val() !== "";

    if (isCompleted && !hasAssignee) {
      $guide.show(); // 가이드 표시
      $assigneeSelect.css("border", "2px solid #ff4d4f");
      return false;
    } else {
      $guide.hide(); // 가이드 숨김
      $assigneeSelect.css("border", "");
      return true;
    }
  }

  // 2. 실시간 체크 (값 바뀔 때마다 실행)
  $completedSelect.on("change", checkValidation);
  $assigneeSelect.on("change", checkValidation);

  // 3. 그룹 변경 시 멤버 로드 (기존 로직 + 체크 추가)
  $groupSelect.on("change", function() {
    var groupId = $(this).val();
    $.ajax({
      url: "${pageContext.request.contextPath}/todos/members",
      type: "GET",
      data: { groupId: groupId },
      success: function(members) {
        $assigneeSelect.empty();
        $assigneeSelect.append('<option value="">-- 담당자 선택 안 함 --</option>');
        $.each(members, function(i, member) {
          $assigneeSelect.append('<option value="' + member.memberId + '">' + member.nickname + '</option>');
        });
        checkValidation(); // 멤버 새로 불러온 후에도 검증 상태 업데이트
      },
      error: function() {
        alert("멤버 목록을 불러오지 못했습니다.");
      }
    });
  });

  // 4. 폼 제출 시 최종 방어
  $(".todo-form").on("submit", function(e) {
    if (!checkValidation()) {
      e.preventDefault();
      alert("담당자를 지정해야 '완료'로 수정할 수 있어요!");
      $assigneeSelect.focus();
      return false;
    }
  });

  // 5. 페이지 로드 시 초기 상태 체크
  $(document).ready(function() {
    checkValidation();
  });
</script>

</html>
