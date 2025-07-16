<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>그룹 멤버 등록</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f4f6f9;
            padding: 50px;
        }

        .form-box {
            max-width: 500px;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        label {
            font-weight: bold;
            margin-top: 15px;
            display: block;
        }

        input {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        .btn-submit {
            margin-top: 30px;
            width: 100%;
            padding: 12px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        .btn-submit:hover {
            background-color: #218838;
        }

        .error-message {
            color: red;
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<div class="form-box">
    <h2>👥 그룹 멤버 등록</h2>

    <!-- 에러 메시지 출력 -->
    <c:if test="${not empty error}">
        <div class="error-message">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/groupmember/create" method="post">
        <label for="groupId">그룹 ID</label>
        <input type="number" id="groupId" name="groupId" required />

        <label for="memberId">회원 ID</label>
        <input type="number" id="memberId" name="memberId" required />

        <label for="code">초대 코드</label>
        <input type="text" id="code" name="code" required placeholder="초대 코드를 입력하세요" />

        <button type="submit" class="btn-submit">가입하기</button>
    </form>
</div>

</body>
</html>
