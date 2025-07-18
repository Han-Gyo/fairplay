<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>To Do List</title>
</head>
<body>
	<h1>🧹오늘의 할 일 리스트</h1>

  <table>
    <thead>
      <tr>
        <th>#</th>
        <th>제목</th>
        <th>담당자</th>
        <th>마감일</th>
        <th>난이도</th>
        <th>상태</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="todo" items="${todoList}" varStatus="loop">
        <tr>
          <td>${loop.index + 1}</td>
          <td>${todo.title}</td>
          <td>${memberMap[todo.assigned_to]}</td>
          <td><fmt:formatDate value="${todo.due_date}" pattern="yyyy-MM-dd" /></td>
          <td>${todo.difficulty_point}</td>
          <td>
            <c:choose>
              <c:when test="${todo.completed}">
                <span class="done">✔ 완료</span>
              </c:when>
              <c:otherwise>
                <span class="not-done">⏳ 미완료</span>
              </c:otherwise>
            </c:choose>
          <td>
            <!-- 완료 버튼 -->
            <button type="button" onclick="completeTodo(${todo.id})">완료</button>
            

            <!-- 수정 버튼 -->
            <form action="${pageContext.request.contextPath}/todos/update" method="get" style="display:inline;">
              <input type="hidden" name="id" value="${todo.id}" />
              <button type="submit">수정</button>
            </form>

            <!-- 삭제 버튼 -->
            <form action="${pageContext.request.contextPath}/todos/delete" method="post" style="display:inline;">
              <input type="hidden" name="id" value="${todo.id}" />
              <button type="submit">삭제</button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <div>
    <a href="${pageContext.request.contextPath}/todos/create">
      <button>➕ 새 할 일 등록</button>
    </a>
  </div>
</body>

<script>
const contextPath = "${pageContext.request.contextPath}";
console.log("🔥 contextPath:", contextPath);
function completeTodo(todo_id) {
		console.log("✅ 전달된 todo_id:", todo_id);
    const confirmResult = confirm("기록도 같이 남기시겠어요?");

    if (confirmResult) {
        // ✅ 확인 누르면 historyCreate 페이지로 이동 (todoId 쿼리로 넘김)
    	window.location.href = contextPath + "/history/create?todo_id=" + todo_id;
    } else {
        // 할 일 완료 처리
        fetch("/fairplay/todos/complete?id=" + todo_id, {
            method: "POST"
        })
        .then(response => {
            if (!response.ok) {
                throw new Error("서버 응답 오류");
            }
            alert("ToDo가 완료 처리되었습니다.");
            location.reload();
        })
        .catch(error => {
            alert("오류 발생: " + error.message);
        });
    }
}
</script>
</html>