<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/WEB-INF/views/nav.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>그룹 멤버 수정</title>
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <!-- 부트스트랩 카드 컴포넌트로 폼을 감싸 디자인 개선 -->
            <div class="card shadow-sm border-0" style="border-radius: 1rem;">
                <div class="card-body p-4 p-md-5">
                    
                    <h2 class="text-center mb-4 text-primary">그룹 멤버 수정</h2>

                    <form action="${pageContext.request.contextPath}/groupmember/update" method="post">
                        <!-- 수정 시 필요한 PK 및 참조 ID (Hidden) -->
                        <input type="hidden" name="id" value="${groupMember.id}" />
                        <input type="hidden" name="groupId" value="${groupMember.groupId}" />
                        <input type="hidden" name="memberId" value="${groupMember.memberId}" />

                        <!-- 역할 선택 영역 -->
                        <div class="form-group mb-3">
                            <label class="form-label fw-bold text-dark">역할 (Role)</label>
                            
                            <c:choose>
                                <%-- 리더 본인일 경우 역할 변경 차단 --%>
                                <c:when test="${isSelfLeader}">
                                    <input type="text" class="form-control bg-light" value="LEADER" readonly />
                                    <div class="form-text mt-2 text-muted">
                                        <small>
                                            그룹장은 본인 페이지에서 역할을 변경할 수 없습니다.<br>
                                            다른 멤버를 LEADER로 지정하면 관리 권한이 위임됩니다.
                                        </small>
                                    </div>
                                </c:when>
                                <%-- 그 외의 경우 역할 선택 가능 --%>
                                <c:otherwise>
                                    <select name="role" class="form-select">
                                        <option value="LEADER" ${groupMember.role == 'LEADER' ? 'selected' : ''}>LEADER</option>
                                        <option value="MEMBER" ${groupMember.role == 'MEMBER' ? 'selected' : ''}>MEMBER</option>
                                    </select>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- 경고 횟수 수정 영역 -->
                        <div class="form-group mb-4">
                            <label class="form-label fw-bold text-dark">경고 횟수</label>
                            <input type="number" name="warningCount" class="form-control" 
                                   value="${groupMember.warningCount}" min="0" />
                        </div>

                        <!-- 제출 및 취소 버튼 -->
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary btn-lg text-white">수정 완료</button>
                            <a href="${pageContext.request.contextPath}/groupmember/list?groupId=${groupMember.groupId}" 
                               class="btn btn-link text-decoration-none text-muted">취소하고 돌아가기</a>
                        </div>
                    </form>
                    
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>