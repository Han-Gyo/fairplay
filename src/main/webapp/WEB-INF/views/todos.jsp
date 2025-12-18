<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>To Do List</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/todos.css">
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
	<h1>🧹 할 일 리스트</h1>

<form method="get" action="${pageContext.request.contextPath}/todos" class="group-select-form">
  <select name="groupId" id="groupId" onchange="this.form.submit()">
    <c:forEach var="group" items="${joinedGroups}">
      <option value="${group.id}" ${group.id == groupId ? 'selected' : ''}>${group.name}</option>
    </c:forEach>
  </select>
</form>
	
<c:if test="${role eq 'LEADER'}">
  <form action="${pageContext.request.contextPath}/todos/create" method="get" style="display:inline;">
    <input type="hidden" name="groupId" value="${sessionScope.currentGroupId}">
    <button type="submit">➕ 새 할 일 등록</button>
  </form>
</c:if>

<div style="display: flex; justify-content: space-between; gap: 30px; margin-top: 20px;">
  
  <!-- 왼쪽: 미신청 할 일 -->
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
				      <td>미지정</td> <td><fmt:formatDate value="${todo.due_date}" pattern="yyyy-MM-dd" /></td>
				      <td>${todo.difficulty_point}</td>
				      <td>⏳ 미완료</td>
				      <td>
				        <form action="${pageContext.request.contextPath}/todos/assign" method="post" style="display:inline;">
				          <input type="hidden" name="todo_id" value="${todo.id}" />
				          <button type="submit">🙋 내가 할게요!</button>
				        </form>
				
				        <c:if test="${role eq 'LEADER'}">
				          <div style="margin-top: 5px;">
				            <button type="button" onclick="location.href='${pageContext.request.contextPath}/todos/update?id=${todo.id}'" style="background-color: #ffca28;">✏ 수정</button>
				            <form action="${pageContext.request.contextPath}/todos/delete" method="post" style="display:inline;">
				              <input type="hidden" name="id" value="${todo.id}" />
				              <button type="submit" onclick="return confirm('진짜 삭제하시겠습니까?')" style="background-color: #ff5252; color: white;">🗑 삭제</button>
				            </form>
				          </div>
				        </c:if>
				      </td>
				    </tr>
				    <c:set var="index" value="${index + 1}" />
				  </c:if>
				</c:forEach>
      </tbody>
    </table>
  </div>

  <!-- 오른쪽: 내가 맡은 진행중 할 일 -->
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
			 		<!-- 전체 그룹원이 볼 수 있는 진행 중인 할 일만 출력 -->
				  <c:if test="${todo.status == '신청완료' && !todo.completed}">
				    <tr>
				      <td>${index}</td>
				      <td>${todo.title}</td>
				      <td>${memberMap[todo.assigned_to]}</td>
				      <td><fmt:formatDate value="${todo.due_date}" pattern="yyyy-MM-dd" /></td>
				      <td>${todo.difficulty_point}</td>
				      <td>🚧 진행중</td>
				      <td>
				        <!-- 본인이 담당자일 때만 포기/완료 버튼 노출 -->
				        <c:if test="${todo.assigned_to == loginMemberId}">
				          <!-- 포기하기 -->
				          <form action="${pageContext.request.contextPath}/todos/unassign" method="post" style="margin-top:5px; display:inline;">
				            <input type="hidden" name="id" value="${todo.id}" />
				            <button type="submit" onclick="return confirm('이 할 일을 포기하고 공용 리스트로 돌릴까요?')">🚫 포기하기</button>
				          </form>
				          <!-- 완료하기 -->
									<button type="button" onclick="completeTodo(${todo.id}, ${todo.difficulty_point})" style="display:inline;">
									  ✔ 완료하기
									</button>

				        </c:if>
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
console.log("contextPath:", contextPath);
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