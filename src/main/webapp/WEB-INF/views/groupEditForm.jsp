<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>그룹 수정</title>
    <style>/* ... 기존 스타일 그대로 유지 ... */</style>
</head>
<body>
<div class="form-box">
    <h2>📝 그룹 수정</h2>
    <form action="${pageContext.request.contextPath}/group/update" method="post" enctype="multipart/form-data">
        <input type="hidden" name="id" value="${group.id}" />

        <label>그룹 이름</label>
        <input type="text" name="name" value="${group.name}" required />

        <label>설명</label>
        <textarea name="description" rows="3">${group.description}</textarea>

        <label>공개 여부</label>
        <div class="radio-group">
		    <label>
			    <input type="radio" name="publicStatus" value="true"
			           <c:if test="${group.publicStatus}">checked</c:if>> 공개
			</label>
			<label>
			    <input type="radio" name="publicStatus" value="false"
			           <c:if test="${!group.publicStatus}">checked</c:if>> 비공개
			</label>
		</div>

		<label for="maxMember">최대 인원 수</label>
		<input type="number" name="maxMember" id="maxMember" value="${group.maxMember}" min="1" required />

        <label>초대 코드</label>
        <input type="text" name="code" value="${group.code}" required maxlength="8" />

        <label>프로필 이미지</label>
        <input type="file" name="file" />

        <label for="admin_comment">그룹장 한마디</label>
		<textarea name="admin_comment" id="admin_comment" rows="4" cols="50" required>${group.admin_comment}</textarea>

        <div class="btn-group">
            <input type="submit" class="btn btn-save" value="저장" />
            <a href="${pageContext.request.contextPath}/group/detail?id=${group.id}" class="btn btn-cancel">취소</a>
        </div>
    </form>
</div>
</body>
</html>