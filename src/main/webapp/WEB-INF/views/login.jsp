<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
</head>
<body>
	<h2>🔐 로그인</h2>

	<!-- 🔴 로그인 실패 메시지 출력 영역 -->
	<c:if test="${not empty loginError}">
	    <p style="color: red;">${loginError}</p>
	</c:if>

	<form action="${pageContext.request.contextPath}/member/login" method="post">
	    <label>아이디 :</label><br>
	    <input type="text" name="user_id"><br><br>
	
	    <label>비밀번호 :</label><br>
	    <input type="password" name="password"><br><br>
	
	    <button type="submit">로그인</button>
	</form>
</body>
</html>