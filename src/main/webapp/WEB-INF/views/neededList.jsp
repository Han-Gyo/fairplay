<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>필요 물품 목록</title>

    <!-- CSS 연결 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/neededList.css">

    <!-- JS 연결 -->
    <script defer src="${pageContext.request.contextPath}/resources/js/neededList.js"></script>
</head>
<body>

<div class="needed-container">
    <h2>📦 필요 물품 목록</h2>

    <!-- 등록 버튼 -->
    <div class="add-btn-wrap">
        <a href="${pageContext.request.contextPath}/needed/add?groupId=${groupId}" class="btn-add">+ 새 물품 추가</a>
    </div>

    <!-- 목록 테이블 -->
    <table class="needed-table">
        <thead>
            <tr>
                <th>물품명</th>
                <th>수량</th>
                <th>구매</th>
                <th>작성자</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${items}">
                <tr class="${item.purchased ? 'done' : ''}">
                    <td>${item.itemName}</td>
                    <td>${item.quantity}</td>
                    <td>
                        <input type="checkbox"
                               class="purchase-check"
                               data-id="${item.id}"
                               ${item.purchased ? 'checked' : ''} />
                    </td>
                    <td>${item.writerNickname}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/needed/edit?id=${item.id}" class="btn-small">수정</a>
                        <form action="${pageContext.request.contextPath}/needed/delete" method="post" style="display:inline;">
                            <input type="hidden" name="id" value="${item.id}" />
                            <input type="hidden" name="groupId" value="${groupId}" />
                            <button type="submit" class="btn-small red">삭제</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>
