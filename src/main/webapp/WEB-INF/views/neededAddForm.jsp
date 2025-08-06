<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>필요 물품 등록</title>

    <!-- CSS 연결 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/neededAddForm.css">

    <!-- JS 연결 -->
    <script defer src="${pageContext.request.contextPath}/resources/js/neededAddForm.js"></script>
</head>
<body>

<div class="add-form-container">
    <h2>📝 새 물품 등록</h2>

    <form action="${pageContext.request.contextPath}/needed/add" method="post">
        <!-- 그룹 ID는 hidden으로 넘김 -->
        <input type="hidden" name="groupId" value="${item.groupId}" />

        <div class="form-group">
            <label for="itemName">물품 이름</label>
            <input type="text" id="itemName" name="itemName" required />
        </div>

        <div class="form-group">
            <label for="quantity">수량</label>
            <input type="number" id="quantity" name="quantity" min="1" value="1" required />
        </div>

        <div class="form-btns">
            <button type="submit" class="btn-submit">등록</button>
            <a href="${pageContext.request.contextPath}/needed/list?groupId=${item.groupId}" class="btn-cancel">취소</a>
        </div>
    </form>
</div>

</body>
</html>
