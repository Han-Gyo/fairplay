<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>리더 위임 및 탈퇴</title>
    <!-- Bootswatch Minty Theme -->
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.0/dist/minty/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { background-color: #fcfcfc; }
        .container { max-width: 500px; margin-top: 50px; margin-bottom: 50px; }
        .card { border: none; border-radius: 12px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08); }
        .card-header { background-color: #78c2ad; color: white; border-radius: 12px 12px 0 0 !important; font-weight: bold; border-bottom: none; }
        
        /* 멤버 선택 카드 스타일 */
        .member-option-label {
            display: block;
            cursor: pointer;
            margin-bottom: 12px;
        }

        .member-card {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 15px;
            transition: all 0.2s ease-in-out;
            position: relative;
        }

        .member-card:hover {
            border-color: #78c2ad;
            background-color: #f8fffb;
        }

        /* 라디오 버튼이 체크되었을 때의 스타일 (인접 형제 선택자 사용) */
        input[type="radio"]:checked + .member-card {
            border-color: #78c2ad;
            background-color: #eaffe9;
            box-shadow: 0 2px 8px rgba(120, 194, 173, 0.2);
        }

        /* 체크 표시 아이콘 제어 */
        .check-icon {
            display: none;
            color: #78c2ad;
            font-size: 1.2rem;
        }

        input[type="radio"]:checked + .member-card .check-icon {
            display: block;
        }

        .btn-submit { font-weight: 600; padding: 12px; border-radius: 8px; }
    </style>
</head>
<body>

<div class="container">
    <div class="card">
        <div class="card-header text-center py-3">
            <h5 class="mb-0 text-white">그룹장 권한 위임</h5>
        </div>
        <div class="card-body p-4">
            
            <c:if test="${not empty members}">
                <div class="text-center mb-4">
                    <p class="text-muted small">새로운 리더를 선택해야 탈퇴가 가능합니다.</p>
                </div>

                <form action="${pageContext.request.contextPath}/groupmember/transferAndLeave" method="post">
                    <input type="hidden" name="groupId" value="${group.id}" />

                    <div class="member-list-container">
                        <c:forEach var="member" items="${members}">
                            <label class="member-option-label">
                                <!-- 라디오 버튼은 숨기고 커스텀 카드로 대체 -->
                                <input type="radio" name="newLeaderId" value="${member.memberId}" required style="display:none;">
                                <div class="member-card d-flex justify-content-between align-items-center">
                                    <div>
                                        <div class="fw-bold text-dark">${member.nickname}</div>
                                        <div class="text-muted small">현재 역할: ${member.role}</div>
                                    </div>
                                    <div class="check-icon">
                                        <i class="bi bi-check-circle-fill"></i>
                                    </div>
                                </div>
                            </label>
                        </c:forEach>
                    </div>

                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-primary btn-submit">
                            리더 위임 후 탈퇴하기
                        </button>
                        <a href="${pageContext.request.contextPath}/group/detail?id=${group.id}" class="btn btn-link text-decoration-none text-muted">취소</a>
                    </div>
                </form>
            </c:if>

            <c:if test="${empty members}">
                <div class="text-center py-4">
                    <div class="mb-3">
                        <i class="bi bi-person-x-fill text-warning" style="font-size: 3rem;"></i>
                    </div>
                    <h6>그룹에 남은 멤버가 없습니다.</h6>
                    <p class="text-muted small">혼자 계신 경우 탈퇴 시 그룹이 삭제됩니다.</p>
                </div>

                <form action="${pageContext.request.contextPath}/groupmember/leave" method="post">
                    <input type="hidden" name="groupId" value="${group.id}" />
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-danger btn-submit">그룹 삭제 및 탈퇴</button>
                        <a href="${pageContext.request.contextPath}/group/detail?id=${group.id}" class="btn btn-link text-decoration-none text-muted">취소</a>
                    </div>
                </form>
            </c:if>

        </div>
    </div>
</div>

<script>
    /* 별도의 JS 없이 CSS의 :checked 선택자만으로 처리 가능하도록 구조를 수정했습니다. 
       라디오 버튼이 클릭되면 바로 뒤에 오는 .member-card의 스타일이 바뀝니다.
    */
</script>

</body>
</html>