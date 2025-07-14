<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수정하기</title>
</head>
<body>
<h2>할 일 수정하기</h2>
<form action="${pageContext.request.contextPath}/todos/create" method="post">
  <input type="hidden" name="group_id" value="1" />
  <div>
    <label for="title">제목:</label><br>
    <input type="text" id="title" name="title" required />
  </div>
  

  <div>
    <label for="assigned_to">담당자:</label><br>
    <input type="text" id="assigned_to" name="assigned_to" required />
  </div>
  

  <div>
    <label for="due_date">마감일:</label><br>
    <input type="date" id="due_date" name="due_date" />
  </div>
  

  <div>
    <label for="difficulty_point">난이도:</label><br>
    <select id="difficulty_point" name="difficulty_point">
      <option value="1">1</option>
      <option value="2">2</option>
      <option value="3">3</option>
      <option value="4">4</option>
      <option value="5">5</option>
    </select>
  </div>
  

  <div>
    <label for="complete">상태:</label><br>
    <select id="complete" name="complete">
      <option value="미완료">미완료</option>
      <option value="완료">완료</option>
    </select>
  </div>
  

  <button type="submit">✅ 할 일 등록</button>
</form>
</body>
</html>