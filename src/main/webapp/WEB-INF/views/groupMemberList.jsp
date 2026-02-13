<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그룹 멤버 목록</title>
    <style>
        /* 민티 테마의 배경색과 어울리는 부드러운 배경 설정 */
        body {
            background-color: #f9f9f9;
        }
        /* 컨테이너 상단 여백 및 최대 너비 조정 */
        .main-container {
            margin-top: 50px;
            margin-bottom: 50px;
        }
        /* 테이블 헤더의 텍스트 중앙 정렬 및 배경색 강조 */
        .table thead th {
            text-align: center;
            background-color: #78C2AD; /* Minty Primary Color */
            color: white;
            border: none;
        }
        /* 테이블 데이터 중앙 정렬 */
        .table tbody td {
            text-align: center;
            vertical-align: middle;
        }
        /* 카드 컴포넌트로 테이블 감싸기 */
        .card {
            border-radius: 15px;
            overflow: hidden;
            border: none;
        }
    </style>
</head>
<body>

<div class="container main-container">
    <div class="card shadow-sm">
        <div class="card-body p-4">
            <h2 class="text-center mb-4 text-primary">그룹 멤버 목록</h2>

            <c:choose>
                <%-- 멤버인 경우 모든 데이터(총점, 월간점, 경고 등) 출력 --%>
                <c:when test="${isMember}">
                    <div class="table-responsive">
                        <table class="table table-hover border-light">
                            <thead>
                                <tr>
                                    <th>닉네임</th>
                                    <th>실명</th>
                                    <th>역할</th>
                                    <th>총 점수</th>
                                    <th>월간 점수</th>
                                    <th>경고 횟수</th>
                                    <th>관리</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="member" items="${groupMembers}">
                                    <tr>
                                        <td>${member.nickname}</td>
                                        <td>${member.realName}</td>
                                        <td>
                                            <span class="badge ${member.role == 'LEADER' ? 'bg-primary' : 'bg-info'}">
                                                ${member.role}
                                            </span>
                                        </td>
                                        <td class="fw-bold text-dark">${member.totalScore}</td>
                                        <td>${member.monthlyScore}</td>
                                        <td class="text-danger">${member.warningCount}</td>
                                        <td>
                                            <div class="d-flex justify-content-center gap-2">
                                                <%-- 수정 버튼 --%>
                                                <c:if test="${loginMember.id == group.leaderId || loginMember.id == member.id}">
                                                    <a href="${pageContext.request.contextPath}/groupmember/edit?id=${member.id}" 
                                                       class="btn btn-sm btn-outline-primary">수정</a>
                                                </c:if>

                                                <%-- 추방 버튼 --%>
                                                <c:if test="${loginMember.id == group.leaderId && member.id != group.leaderId && loginMember.id != member.memberId}">
                                                    <form action="${pageContext.request.contextPath}/groupmember/delete" method="post" class="m-0">
                                                        <input type="hidden" name="groupId" value="${group.id}" />
                                                        <input type="hidden" name="memberId" value="${member.memberId}" />
                                                        <button type="submit" class="btn btn-sm btn-danger text-white" 
                                                                onclick="return confirm('정말 추방하시겠습니까?');">추방</button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>

                <%-- 멤버가 아니지만 공개 그룹인 경우 --%>
                <c:when test="${group.publicStatus}">
                    <table class="table table-hover">
                        <thead class="table-primary text-white">
                            <tr>
                                <th>닉네임</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="member" items="${groupMembers}">
                                <tr>
                                    <td>${member.nickname}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>

                <%-- 비공개 그룹인 경우 --%>
                <c:otherwise>
                    <div class="alert alert-dismissible alert-light text-center border mt-3">
                        <p class="mb-0 text-muted">비공개 그룹의 멤버 목록은 가입자만 볼 수 있습니다.</p>
                    </div>
                </c:otherwise>
            </c:choose>

            <%-- 돌아가기 버튼 --%>
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/group/groups" class="btn btn-secondary px-4">
                    그룹 목록으로 돌아가기
                </a>
            </div>
        </div>
    </div>
</div>

</body>
</html>