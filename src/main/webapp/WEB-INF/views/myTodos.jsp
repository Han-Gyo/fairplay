<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>내가 맡은 할 일</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/myTodos.css">
</head>
<body class="mytodos-body">
  <div class="mytodos-container">
    <h2 class="page-title">📌 내가 맡은 할 일 목록</h2>

    <div class="table-card">
      <div class="table-responsive">
        <table class="mytodos-table">
    <thead>
      <tr>
        <th>제목</th>
        <th>마감일</th>
        <th>완료 여부</th>
        <th>난이도</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="todo" items="${myTodoList}">
        <tr>
          <td>${todo.title}</td>
          <td><fmt:formatDate value="${todo.due_date}" pattern="yyyy-MM-dd"/></td>
          <td>
					  <c:choose>
					    <c:when test="${todo.completed}">
					      <span class="status-badge done">✅ 완료</span>
					    </c:when>
					    <c:otherwise>
					      <span class="status-badge pending">❌ 미완료</span>
					    </c:otherwise>
					  </c:choose>
					</td>
          <td>${todo.difficulty_point}</td>
          <td>
					  <c:choose>
					    <c:when test="${not todo.completed}">
					      <!-- 미완료일 때만 아래 버튼들 보여주기 -->
					      
					      <!-- 포기 버튼 -->
					      <form action="${pageContext.request.contextPath}/todos/unassign" method="post" style="display:inline;">
					        <input type="hidden" name="id" value="${todo.id}" />
					        <button type="submit" onclick="return confirm('이 할 일을 포기하고 공용 리스트로 돌릴까요?')">포기하기</button>
					      </form>
					
					      <!-- 완료 버튼 -->
								<button type="button" onclick="completeTodo(${todo.id}, ${todo.difficulty_point})">완료</button>
					
					      <!-- 수정 버튼 -->
					      <form action="${pageContext.request.contextPath}/todos/update" method="get" style="display:inline;">
					        <input type="hidden" name="id" value="${todo.id}" />
					        <button type="submit">수정</button>
					      </form>
					    </c:when>
					  </c:choose>
					</td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
	</div>
</div>

  <br>
  <a class="back-link" href="${pageContext.request.contextPath}/todos">← 돌아가기</a>
</div>
</body>

<script>
function completeTodo(todo_id, score) {
    const confirmResult = confirm("상세 기록을 남기시겠어요?\n(취소를 누르면 기본 기록만 생성되고 완료됩니다.)");

    if (confirmResult) {
        // [확인] 상세 등록 폼으로 이동
        window.location.href = contextPath + "/history/create?todo_id=" + todo_id + "&score=" + score;
    } else {
        // [취소] 기본 정보로 즉시 기록 생성 + 완료 처리
        if(confirm("기본 기록으로 즉시 완료하시겠습니까?")) {
            // 새로 만들 서버 경로로 요청 보냄
            fetch(contextPath + "/history/create-basic?todo_id=" + todo_id + "&score=" + score, {
                method: "POST"
            })
            .then(response => {
                if (response.ok) {
                    alert("기본 기록 등록 및 완료 처리가 되었습니다.");
                    location.reload();
                } else {
                    alert("처리에 실패했습니다.");
                }
            })
            .catch(error => alert("오류 발생: " + error.message));
        }
    }
}
</script>
</html>
