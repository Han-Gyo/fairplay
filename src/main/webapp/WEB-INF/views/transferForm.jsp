<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>리더 위임 후 탈퇴</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/transfer.css" />
</head>
<body>

<div class="container">
    <h2>👑 그룹장 권한을 위임하세요</h2>

    <form action="${pageContext.request.contextPath}/groupmember/transferAndLeave" method="post">
        <!-- 그룹 ID 전달 -->
        <input type="hidden" name="groupId" value="${group.id}" />

        <c:forEach var="member" items="${members}">
            <label class="radio-card">
                <input type="radio" name="newLeaderId" value="${member.memberId}" required />
                ${member.nickname} (${member.role})
            </label>
        </c:forEach>

        <button type="submit" class="btn-submit">리더 위임 후 탈퇴하기</button>
    </form>
</div>

</body>
</html>
