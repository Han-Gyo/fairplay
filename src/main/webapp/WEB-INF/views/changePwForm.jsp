<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="${pageContext.request.contextPath}/mypage/changePw" method="post">
    <input type="password" name="currentPassword" placeholder="현재 비밀번호" required />
    <input type="password" name="newPassword" placeholder="새 비밀번호" required />
    <input type="password" name="confirmPassword" placeholder="새 비밀번호 확인" required />
    <button type="submit">비밀번호 변경</button>
</form>
</body>
</html>