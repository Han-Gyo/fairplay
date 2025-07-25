<%@ page contentType="text/html; charset=UTF-8" %>

<html>
<head>
    <title>회원가입</title>
    <!-- 외부 CSS 연결 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberCreateForm.css">
</head>
<body>

<h2>회원가입</h2>

<form id="signUpForm" method="post" action="${pageContext.request.contextPath}/member/create">
    <label for="user_id">아이디</label>
    <input type="text" id="user_id" name="user_id" required />
    <input type="hidden" id="contextPath" value="${pageContext.request.contextPath}" />
	<button type="button" onclick="checkId()">중복확인</button>
	<div id="idError"></div>

    <label for="password">비밀번호</label>
    <input type="password" id="password" name="password" required />

    <label for="passwordCheck">비밀번호 확인</label>
    <input type="password" id="passwordCheck" required />
    <div id="pwError" class="error"></div>

    <label for="real_name">실명</label>
    <input type="text" name="real_name" required />

    <label for="nickname">닉네임</label>
    <input type="text" name="nickname" required />

    <label for="email">이메일</label>
    <input type="email" id="email" name="email" required />
    <button type="button" class="inline-btn" onclick="sendCode()">인증번호 전송</button>

    <label for="emailCode">인증번호 입력</label>
    <input type="text" id="emailCode" />
    <button type="button" class="inline-btn" onclick="verifyCode()">확인</button>
    <div id="emailMsg" class="error"></div>

    <label for="address">주소</label>
    <input type="text" name="address" />

    <label for="phone">휴대폰 번호</label>
    <input type="text" name="phone" />

    <label for="status">계정 상태</label>
    <select name="status">
        <option value="ACTIVE">활성</option>
        <option value="INACTIVE">휴면</option>
    </select>

    <button type="submit" class="submit-btn">가입하기</button>
</form>


<!-- 외부 JS 연결 -->
<script src="${pageContext.request.contextPath}/resources/js/memberCreateForm.js" defer></script>
</body>
</html>
