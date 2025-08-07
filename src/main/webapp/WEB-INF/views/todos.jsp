<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>To Do List</title>
<style>
	a {
		color : black;
		text-decoration : none;
	}
	a:hover {
		color : pink;
	}
</style>
</head>
<body>
	<h1><a href="${pageContext.request.contextPath}/">🧹 할 일 리스트</a></h1>

<c:if test="${not empty msg}">
  <script>
    alert("${msg}");
  </script>
</c:if>
	
<c:if test="${role eq 'LEADER'}">
  <form action="${pageContext.request.contextPath}/todos/create" method="get" style="display:inline;">
    <input type="hidden" name="groupId" value="${group.id}">
    <button type="submit">➕ 새 할 일 등록</button>
  </form>
</c:if>

<div style="display: flex; justify-content: space-between; gap: 30px; margin-top: 20px;">
  
  <!-- ✅ 왼쪽: 미신청 할 일 -->
  <div style="flex: 1;">
    <h2>🧹 아직 아무도 신청 안 한 할 일</h2>
    <table>
      <thead>
        <tr>
          <th>#</th><th>제목</th><th>담당자</th><th>마감일</th><th>난이도</th><th>상태</th><th>신청</th>
        </tr>
      </thead>
      <tbody>
      	<c:set var="index" value="1" />
        <c:forEach var="todo" items="${todoList}" >
          <c:if test="${todo.status == '미신청'}">
            <tr>
              <td>${index}</td>
              <td>${todo.title}</td>
              <td>${memberMap[todo.assigned_to]}</td>
              <td><fmt:formatDate value="${todo.due_date}" pattern="yyyy-MM-dd" /></td>
              <td>${todo.difficulty_point}</td>
              <td>⏳ 미완료</td>
              <td>
                <form action="${pageContext.request.contextPath}/todos/assign" method="post">
                  <input type="hidden" name="todo_id" value="${todo.id}" />
                  <button type="submit">🙋 내가 할게요!</button>
                </form>
              </td>
            </tr>
            <c:set var="index" value="${index + 1}" />
          </c:if>
        </c:forEach>
      </tbody>
    </table>
  </div>

  <!-- ✅ 오른쪽: 내가 맡은 진행중 할 일 -->
  <div style="flex: 1;">
    <h2>🚧 진행중인 할 일</h2>
    <table>
      <thead>
        <tr>
          <th>#</th><th>제목</th><th>담당자</th><th>마감일</th><th>난이도</th><th>상태</th><th>완료</th>
        </tr>
      </thead>
      <tbody>
      <c:set var="index" value="1" />
        <c:forEach var="todo" items="${todoList}">
          <c:if test="${todo.status == '신청완료' && todo.assigned_to == loginMemberId && !todo.completed}">
            <tr>
            	<td>${index}</td>
              <td>${todo.title}</td>
              <td>${memberMap[todo.assigned_to]}</td>
              <td><fmt:formatDate value="${todo.due_date}" pattern="yyyy-MM-dd" /></td>
              <td>${todo.difficulty_point}</td>
              <td>🚧 진행중</td>
              <td>
              	<!-- 포기하기 버튼 -->
							  <form action="${pageContext.request.contextPath}/todos/unassign" method="post" style="margin-top:5px; display:inline;">
							    <input type="hidden" name="id" value="${todo.id}" />
							    <button type="submit" onclick="return confirm('이 할 일을 포기하고 공용 리스트로 돌릴까요?')">🚫 포기하기</button>
							  </form>
              	<form action="${pageContext.request.contextPath}/todos/complete" method="post" style="display:inline;">
                	<input type="hidden" name="id" value="${todo.id}" />
                	<button type="button" onclick="completeTodo(${todo.id})">✔ 완료하기</button>
              	</form>
              </td>
            </tr>
            <c:set var="index" value="${index + 1}" />
          </c:if>
        </c:forEach>
      </tbody>
    </table>
  </div>

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