<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>가계부 목록</title>
</head>
<body>

<h1>💸 가계부 전체 목록</h1>

<!-- 등록 버튼 -->
<a href="${pageContext.request.contextPath}/wallet/create">+ 새 항목 등록</a>

<!-- 항목 리스트 테이블 -->
<table border="1" cellpadding="8" cellspacing="0">
    <thead>
        <tr>
            <th>ID</th>
            <th>품목명</th>
            <th>카테고리</th>
            <th>가격</th>
            <th>수량</th>
            <th>단위</th>
            <th>단가(1개당)</th>
            <th>구매처</th>
            <th>유형</th>
            <th>구매일</th>
            <th>메모</th>
            <th>관리</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="item" items="${walletList}">
            <tr>
                <td>${item.id}</td>
                <td>${item.item_name}</td>
                <td>${item.category}</td>
                <td>${item.price}</td>
                <td>${item.quantity}</td>
                <td>${item.unit}</td>
                <td>
                    <c:if test="${item.unit_count != 0}">
                        <fmt:formatNumber value="${item.price / item.unit_count}" pattern="#,###"/>
                    </c:if>
                </td>
                <td>${item.store}</td>
                <td>${item.type}</td>
                <td>${item.purchase_date}</td>
                <td>${item.memo}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/wallet/edit?id=${item.id}">✏️수정</a>
                    <a href="${pageContext.request.contextPath}/wallet/delete?id=${item.id}&member_id=${member_id}" onclick="return confirm('정말 삭제할까요?');">🗑️삭제</a>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<!-- 단가 비교 검색 -->
<form action="${pageContext.request.contextPath}/wallet/compare" method="get">
    <input type="hidden" name="member_id" value="${member_id}" />
    <input type="text" name="item_name" placeholder="비교할 품목명 입력" required/>
    <button type="submit">📊 단가 비교</button>
</form>

</body>
</html>
