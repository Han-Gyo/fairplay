<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그룹 멤버 목록</title>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #eef2f7;
            padding: 50px;
        }

        .table-box {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            padding: 30px;
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 12px 15px;
            text-align: center;
        }

        th {
            background-color: #007bff;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f4f6f9;
        }

        tr:hover {
            background-color: #d6e9f8;
        }

        .btn-back {
            display: block;
            margin: 30px auto 0;
            text-align: center;
            background-color: #6c757d;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
        }

        .btn-back:hover {
            background-color: #5a6268;
        }
    </style>
</head>
<body>

<div class="table-box">
    <h2>👥 그룹 멤버 목록</h2>


<c:choose>

    <c:when test="${isMember}">
        <table>
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
                        <td>${member.role}</td>
                        <td>${member.totalScore}</td>
                        <td>${member.monthlyScore}</td>
                        <td>${member.warningCount}</td>
                        
                        <td>
						    <c:if test="${loginMember.id == group.leaderId || loginMember.id == member.id}">
						        <a href="${pageContext.request.contextPath}/groupmember/edit?id=${member.id}">수정</a>
						    </c:if>
						</td>
						
                        <td>
                             <c:if test="${loginMember.id == group.leaderId && member.id != group.leaderId && loginMember.id != member.memberId}">
							    <form action="${pageContext.request.contextPath}/groupmember/delete" method="post" style="display:inline;">
							        <input type="hidden" name="groupId" value="${group.id}" />
							        <input type="hidden" name="memberId" value="${member.memberId}" />
							        <button type="submit" class="action-link delete" onclick="return confirm('정말 추방하시겠습니까?');">추방</button>
							    </form>
							</c:if>
					    </td>
					</tr>
                </c:forEach>
            </tbody>
        </table>
    </c:when>

    <c:when test="${group.publicStatus}">
        <table>
            <thead>
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


    <c:otherwise>
        <p>비공개 그룹의 멤버 목록은 가입자만 볼 수 있습니다.</p>
    </c:otherwise>
</c:choose>

    <form action="${pageContext.request.contextPath}/group/groups">
        <button type="submit" class="btn-back">그룹 목록으로 돌아가기</button>
    </form>
</div>

</body>
</html>