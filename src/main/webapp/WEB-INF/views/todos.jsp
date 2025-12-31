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
</head>
<body class="bg-light">
  <div class="container todo-page">
    <div class="d-flex justify-content-between align-items-end mb-4">
      <div>
        <h1 class="text-primary fw-bolder mb-0">🧹${group.name} 그룹의 할 일 리스트</h1>
      </div>
      <c:if test="${role eq 'LEADER'}">
        <form action="${pageContext.request.contextPath}/todos/create" method="get">
          <input type="hidden" name="groupId" value="${sessionScope.currentGroupId}">
          <button type="submit" class="btn btn-primary rounded-pill px-4 shadow-sm fw-bold">
            <i class="fas fa-plus-circle me-1"></i> 새 할 일 등록
          </button>
        </form>
      </c:if>
    </div>

    <div class="card border-0 shadow-sm mb-5 rounded-4">
      <div class="card-body p-4">
        <form method="get" action="${pageContext.request.contextPath}/todos">
          <label for="groupId" class="form-label fw-bold text-secondary small">그룹 선택</label>
          <div class="input-group">
            <span class="input-group-text bg-primary text-white border-primary"><i class="fas fa-users"></i></span>
            <select name="groupId" id="groupId" class="form-select border-primary" onchange="this.form.submit()">
              <c:forEach var="group" items="${joinedGroups}">
                <option value="${group.id}" ${group.id == groupId ? 'selected' : ''}>${group.name}</option>
              </c:forEach>
            </select>
          </div>
        </form>
      </div>
    </div>

    <div class="row g-5">
      <div class="col-lg-6">
        <h4 class="fw-bold mb-4 text-dark border-start border-4 border-info ps-3">📢 신청 가능한 할 일</h4>
        <div class="row g-3">
          <c:set var="index" value="1" />
          <c:forEach var="todo" items="${todoList}">
            <c:if test="${todo.status == '미신청'}">
              <div class="col-12">
                <div class="card todo-card border-0 shadow-sm h-100 rounded-4 overflow-hidden">
                  <div class="card-body p-4 d-flex justify-content-between align-items-center">
                    <div class="flex-grow-1">
                      <div class="d-flex align-items-center mb-2">
                        <span class="badge bg-info-light text-info me-2">No.${index}</span>
                        <span class="text-muted small"><i class="far fa-calendar-alt me-1"></i> <fmt:formatDate value="${todo.due_date}" pattern="MM-dd" /></span>
                      </div>
                      <h5 class="card-title fw-bold text-dark mb-1">${todo.title}</h5>
                      <p class="mb-0 text-muted small"><i class="fas fa-bolt text-warning me-1"></i> 난이도 점수: <strong>${todo.difficulty_point}점</strong></p>
                    </div>
                    <div class="action-area ms-3">
                      <form action="${pageContext.request.contextPath}/todos/assign" method="post" class="d-grid mb-2">
                        <input type="hidden" name="todo_id" value="${todo.id}" />
                        <button type="submit" class="btn btn-info btn-sm rounded-pill fw-bold text-white btn-fixed">신청</button>
                      </form>
                      <c:if test="${role eq 'LEADER'}">
                        <div class="d-flex gap-1 justify-content-center">
                          <button type="button" class="btn btn-outline-warning btn-xss rounded-circle" onclick="location.href='${pageContext.request.contextPath}/todos/update?id=${todo.id}'"><i class="fas fa-pen"></i></button>
                          <form action="${pageContext.request.contextPath}/todos/delete" method="post" class="d-inline">
                            <input type="hidden" name="id" value="${todo.id}" />
                            <button type="submit" class="btn btn-outline-danger btn-xss rounded-circle" onclick="return confirm('삭제할까요?')"><i class="fas fa-trash"></i></button>
                          </form>
                        </div>
                      </c:if>
                    </div>
                  </div>
                </div>
              </div>
              <c:set var="index" value="${index + 1}" />
            </c:if>
          </c:forEach>
        </div>
      </div>

      <div class="col-lg-6">
        <h4 class="fw-bold mb-4 text-dark border-start border-4 border-success ps-3">🏃 진행 중인 할 일</h4>
        <div class="row g-3">
          <c:set var="index" value="1" />
          <c:forEach var="todo" items="${todoList}">
            <c:if test="${todo.status == '신청완료' && !todo.completed}">
              <div class="col-12">
                <div class="card todo-card border-0 shadow-sm h-100 rounded-4 border-bottom border-4 border-success">
                  <div class="card-body p-4 d-flex justify-content-between align-items-center">
                    <div class="flex-grow-1">
                      <div class="mb-2">
                        <span class="badge bg-success-light text-success fw-bold"><i class="fas fa-user-check me-1"></i> ${memberMap[todo.assigned_to]}</span>
                      </div>
                      <h5 class="card-title fw-bold text-dark mb-1">${todo.title}</h5>
                      <p class="text-danger small mb-0 fw-bold"><i class="fas fa-clock me-1"></i> 마감일: <fmt:formatDate value="${todo.due_date}" pattern="yyyy-MM-dd" /></p>
                    </div>
                    <div class="action-area ms-3">
									  <c:if test="${todo.assigned_to == loginMemberId}">
									    <div class="d-flex align-items-center gap-2">
									      <button type="button" class="btn btn-success btn-sm rounded-pill fw-bold text-white btn-fixed shadow-sm" onclick="completeTodo(${todo.id}, ${todo.difficulty_point})">
									        완료
									      </button>
									
									      <form action="${pageContext.request.contextPath}/todos/unassign" method="post" class="m-0">
									        <input type="hidden" name="id" value="${todo.id}" />
									        <button type="submit" class="btn btn-outline-secondary btn-xs rounded-pill px-2" onclick="return confirm('포기하시겠습니까?')">
									          <i class="fas fa-times me-1"></i>포기
									        </button>
									      </form>
									    </div>
									  </c:if>
										</div>
	                </div>
               	</div>
              </div>
              <c:set var="index" value="${index + 1}" />
            </c:if>
          </c:forEach>
        </div>
      </div>
    </div>
  </div>

<script>
console.log("contextPath:", contextPath);
function completeTodo(todo_id, score) {
  const confirmResult = confirm("상세 기록을 남기시겠어요?\n(취소를 누르면 기본 기록만 생성되고 완료됩니다.)");

  if (confirmResult) {
      // [확인] 상세 등록 폼으로 이동
      window.location.href = contextPath + "/history/create?todo_id=" + todo_id + "&score=" + score;
  } else {
    // [취소] 기본 정보로 즉시 기록 생성 + 완료 처리
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
</script>
</body>
</html>