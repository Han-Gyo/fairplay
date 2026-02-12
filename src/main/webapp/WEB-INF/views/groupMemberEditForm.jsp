<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<html>
<head>
    <title>그룹에 가입된 멤버 수정</title>
    <link href="<c:url value='/resources/css/bootstrap.min.css' />" rel="stylesheet">
    <style>
        body {
            font-family: 'Pretendard', sans-serif;
            background: #f8f9fa;
            padding: 30px;
        }

        .form-box {
            max-width: 600px;
            margin: 0 auto;
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            padding: 30px;
        }

        h2 {
            margin-bottom: 20px;
            text-align: center;
        }

        .form-group {
            margin-bottom: 15px;
        }

        label {
            font-weight: bold;
        }

        .btn-save {
            width: 100%;
            margin-top: 20px;
        }

        .info-text {
            font-size: 13px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
<div class="form-box">
    <h2>👥 그룹 멤버 수정</h2>

    <form action="${pageContext.request.contextPath}/groupmember/update" method="post">
        <!-- 그룹멤버 고유 ID (PK) -->
        <input type="hidden" name="id" value="${groupMember.id}" />
        <!-- 그룹 ID 유지 (리스트 복귀용) -->
        <input type="hidden" name="groupId" value="${groupMember.groupId}" />
        <!-- 멤버 ID 유지 (수정 시 필수) -->
        <input type="hidden" name="memberId" value="${groupMember.memberId}" />

        <div class="form-group">
            <label>역할 (Role)</label>
            <!-- 리더 본인일 경우 Role 변경 불가 -->
            <c:choose>
                <c:when test="${isSelfLeader}">
                    <input type="text" class="form-control" value="LEADER" readonly />
                    <p class="info-text">그룹장은 본인 페이지에서 역할을 변경할 수 없습니다.<br>
                    다른 멤버의 수정 페이지에서 Role을 LEADER로 변경하면 리더 권한이 위임됩니다.</p>
                </c:when>
                <c:otherwise>
                    <select name="role" class="form-control">
                        <option value="LEADER" ${groupMember.role == 'LEADER' ? 'selected' : ''}>LEADER</option>
                        <option value="MEMBER" ${groupMember.role == 'MEMBER' ? 'selected' : ''}>MEMBER</option>
                    </select>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- 경고 횟수만 수정 가능 -->
        <div class="form-group">
            <label>경고 횟수 (warning_count)</label>
            <input type="number" name="warningCount" class="form-control" value="${groupMember.warningCount}" />
        </div>

        <button type="submit" class="btn btn-primary btn-save">수정 완료</button>
    </form>
</div>
</body>
</html>