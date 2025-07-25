<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<html>
<head>
    <title>회원가입</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
        }
        form {
            width: 400px;
            margin: 0 auto;
        }
        label {
            display: block;
            margin-top: 15px;
        }
        input, select {
            width: 100%;
            padding: 8px;
            box-sizing: border-box;
        }
        .submit-btn {
            margin-top: 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px;
            cursor: pointer;
        }
        .submit-btn:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

<h2>회원가입</h2>

<form method="post" action="${pageContext.request.contextPath}/member/create">
    <label for="user_id">아이디</label>
    <input type="text" name="user_id" />

    <label for="password">비밀번호</label>
    <input type="password" name="password" />
    
    <label for="real_name">실명</label>
    <input type="text" name="real_name" />

    <label for="nickname">닉네임</label>
    <input type="text" name="nickname" />

    <label for="email">이메일</label>
    <input type="email" name="email" />

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

</body>
</html>
