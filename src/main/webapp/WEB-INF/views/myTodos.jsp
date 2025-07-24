<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>내가 맡은 할 일</title>
  <style>
    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 20px;
    }
    th, td {
      padding: 10px;
      border: 1px solid #ccc;
      text-align: center;
    }
    button {
      padding: 5px 10px;
    }
  </style>
</head>
<body>
  <h2>📌 내가 맡은 할 일 목록</h2>

  <table>
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
              <c:when test="${todo.completed}">✅ 완료</c:when>
              <c:otherwise>❌ 미완료</c:otherwise>
            </c:choose>
          </td>
          <td>${todo.difficulty_point}</td>
          <td>
					  <c:choose>
					    <c:when test="${not todo.completed}">
					      <!-- ✅ 미완료일 때만 아래 버튼들 보여주기 -->
					      
					      <!-- 포기 버튼 -->
					      <form action="${pageContext.request.contextPath}/todos/unassign" method="post" style="display:inline;">
					        <input type="hidden" name="id" value="${todo.id}" />
					        <button type="submit" onclick="return confirm('이 할 일을 포기하고 공용 리스트로 돌릴까요?')">포기하기</button>
					      </form>
					
					      <!-- 완료 버튼 -->
					      <form action="${pageContext.request.contextPath}/todos/myTodos" method="post" style="display:inline;">
              <input type="hidden" name="id" value="${todo.id}" />
              <button type="submit">완료</button>
            </form>
					
					      <!-- 수정 버튼 -->
					      <form action="${pageContext.request.contextPath}/todos/update" method="get" style="display:inline;">
					        <input type="hidden" name="id" value="${todo.id}" />
					        <button type="submit">수정</button>
					      </form>
					
					      <!-- 삭제 버튼 -->
					      <form action="${pageContext.request.contextPath}/todos/delete" method="post" style="display:inline;">
					        <input type="hidden" name="id" value="${todo.id}" />
					        <button type="submit" onclick="return confirm('정말 삭제할까요?')">삭제</button>
					      </form>
					
					    </c:when>
					    <c:otherwise>
					      <!-- ✅ 완료된 항목은 포기/삭제 불가 -->
					      <span style="color:gray;">✅ 완료된 항목은 수정 불가</span>
					    </c:otherwise>
					  </c:choose>
					</td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <br>
  <a href="${pageContext.request.contextPath}/todos">← 돌아가기</a>
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
