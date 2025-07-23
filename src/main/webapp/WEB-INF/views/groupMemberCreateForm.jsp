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
    <h2>👥 그룹 가입</h2>

    <!-- 에러 메시지 출력 -->
    <c:if test="${not empty msg}">
        <div class="error-message">${msg}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/groupmember/create" method="post">
	    <!-- 그룹 ID를 히든으로 넘김 -->
	    <input type="hidden" name="groupId" value="${group.id}" />
	
	    <!-- ✅ 공개/비공개 상관없이 무조건 초대코드 입력 -->
	    <label for="inviteCode">초대코드</label>
	    <input type="text" id="inviteCode" name="inviteCode" required placeholder="초대코드를 입력하세요" />
	
	    <button type="submit">가입하기</button>
	</form>
</div>

</body>
</html>
