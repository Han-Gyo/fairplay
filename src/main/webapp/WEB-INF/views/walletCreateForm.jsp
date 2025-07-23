<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>지출 항목 등록/수정</title>
</head>
<body>

<h1>${wallet.id == 0 ? "➕ 새 항목 등록" : "✏️ 항목 수정"}</h1>

<form action="${pageContext.request.contextPath}${wallet.id == 0 ? '/wallet/save' : '/wallet/update'}" method="post">
    
    <!-- 숨겨진 ID와 memberId 전달 -->
    <input type="hidden" name="id" value="${wallet.id}" />
    <input type="hidden" name="member_id" value="${member_id}" />

    <div>
        <label>품목명:</label>
        <input type="text" name="item_name" value="${wallet.item_name}" required />
    </div>

    <div>
        <label>카테고리:</label>
        <input type="text" name="category" value="${wallet.category}" />
    </div>

    <div>
        <label>가격:</label>
        <input type="number" name="price" value="${wallet.price}" required />
    </div>

    <div>
        <label>수량:</label>
        <input type="number" name="quantity" value="${wallet.quantity}" min="1" />
    </div>

    <div>
        <label>단위:</label>
        <input type="text" name="unit" value="${wallet.unit}" />
    </div>

    <div>
        <label>단위당 개수:</label>
        <input type="number" name="unit_count" value="${wallet.unit_count}" />
    </div>

    <div>
        <label>구매처:</label>
        <input type="text" name="store" value="${wallet.store}" />
    </div>

    <div>
        <label>유형:</label>
        <select name="type">
            <option value="지출" ${wallet.type == '지출' ? 'selected' : ''}>지출</option>
            <option value="수입" ${wallet.type == '수입' ? 'selected' : ''}>수입</option>
        </select>
    </div>

    <div>
        <label>구매일:</label>
        <input type="date" name="purchase_date"
       value="${wallet.purchase_date != null ? wallet.purchase_date : ''}" required />
    </div>

    <div>
        <label>메모:</label>
        <textarea name="memo">${wallet.memo}</textarea>
    </div>

    <div>
        <button type="submit">${wallet.id == 0 ? "등록" : "수정 완료"}</button>
        <a href="${pageContext.request.contextPath}/wallet">뒤로가기</a>
    </div>

</form>

</body>
</html>
