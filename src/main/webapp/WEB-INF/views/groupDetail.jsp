<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>그룹 상세 보기</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f4f6f9;
            padding: 50px;
        }

        .detail-box {
            max-width: 600px;
            margin: 0 auto;
            background-color: #fff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }

        .row {
            margin-bottom: 18px;
        }

        .label {
            font-weight: bold;
            display: inline-block;
            width: 130px;
            color: #555;
        }

        .value {
            display: inline-block;
            color: #222;
        }

        .btn-group {
            text-align: center;
            margin-top: 30px;
        }

        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            margin: 0 10px;
        }

        .btn-list {
            background-color: #6c757d;
            color: white;
        }

        .btn-edit {
            background-color: #007bff;
            color: white;
        }
    </style>
</head>
<body>

<div class="detail-box">
    <h2>📄 그룹 상세 보기</h2>

    <div class="row"><span class="label">그룹 이름:</span> <span class="value">${group.name}</span></div>
    <div class="row"><span class="label">설명:</span> <span class="value">${group.description}</span></div>
    <div class="row"><span class="label">공개 여부:</span> 
        <span class="value">
            <c:choose>
			  <c:when test="${group.publicStatus eq 'true'}">공개</c:when>
			  <c:otherwise>비공개</c:otherwise>
			</c:choose>
        </span>
    </div>
    <div class="row"><span class="label">초대 코드:</span> <span class="value">${group.code}</span></div>
    <div class="row"><span class="label">대표 이미지:</span> 
        <span class="value">
            <c:if test="${not empty group.profile_img}">
                <img src="/upload/${group.profile_img}" alt="프로필 이미지" width="100" />
            </c:if>
            <c:if test="${empty group.profile_img}">
                없음
            </c:if>
        </span>
    </div>
    <div class="row"><span class="label">관리자 한마디:</span> <span class="value">${group.admin_comment}</span></div>
    <div class="row"><span class="label">생성일:</span> <span class="value">${group.created_at}</span></div>

    <div class="btn-group">
        <a href="${pageContext.request.contextPath}/group/groups"><button class="btn btn-list">목록으로</button></a>
        <a href="${pageContext.request.contextPath}/group/edit?id=${group.id}"><button class="btn btn-edit">수정</button></a>
    </div>
</div>

</body>
</html>
