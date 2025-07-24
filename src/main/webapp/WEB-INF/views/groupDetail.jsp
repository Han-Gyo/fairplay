<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
			  <c:when test="${group.publicStatus}">공개</c:when>
			  <c:otherwise>비공개</c:otherwise>
			</c:choose>

        </span>
    </div>
    
	<!-- ✅ 초대코드 마스킹 + 복사 기능 (그룹장만 노출) -->
	<c:if test="${loginMember.id == group.leaderId}">
	    <div class="row">
	        <span class="label">초대 코드:</span>
	        <span class="value">
	            <input type="password" id="inviteCode" value="${group.code}" readonly 
	                   style="border: none; background: transparent; width: 100px;" />
	            <button type="button" onclick="copyInviteCode()">복사</button>
	        </span>
	    </div>
	</c:if>
	
    <div class="row">
	    <span class="label">대표 이미지:</span>
	    <span class="value">
	        <c:choose>
	            
	            <c:when test="${not empty group.profile_img}">
	                <img src="${pageContext.request.contextPath}/upload/${group.profile_img}" 
	                     alt="대표 이미지" width="100" style="cursor: pointer;"
	                     onclick="window.open(this.src, '_blank')" />
	            </c:when>
	
	            
	            <c:otherwise>
	                <img src="${pageContext.request.contextPath}/resources/img/default-group.png" 
	                     alt="기본 이미지" width="100" />
	            </c:otherwise>
	        </c:choose>
	    </span>
	</div>

	<div class="row">
	    <span class="label">그룹 인원:</span>
	    <span class="value">👥 ${currentMemberCount} / ${group.maxMember}</span>
	</div>
	
    <%
	    com.fairplay.domain.Group g = (com.fairplay.domain.Group) request.getAttribute("group");
	    String adminComment = "";
	    if (g != null && g.getAdmin_comment() != null) {
	    	adminComment = g.getAdmin_comment().replaceAll("\r\n", "<br/>");
	    }
	    request.setAttribute("formattedComment", adminComment);
	%>

	<div class="row">
	    <span class="label">관리자 한마디:</span>
	    <span class="value">${formattedComment}</span>
	</div>
	
    <div class="row">
    	<span class="label">생성일:</span> 
    	<span class="value">
    		<fmt:formatDate value="${group.created_at}" pattern="yyyy-MM-dd HH:mm" />
		</span>
	</div>
	
	<!-- ✅ 그룹 가입 버튼 조건 처리 -->
<c:choose>

    <c:when test="${empty loginMember}">
        <a href="${pageContext.request.contextPath}/member/setRedirect?redirectURI=/group/detail?id=${group.id}">
            <button type="button" class="btn btn-primary">로그인 후 가입하기</button>
        </a>
    </c:when>

    <c:when test="${isMember}">
        <button type="button" class="btn btn-secondary" disabled>이미 가입된 그룹입니다</button>
    </c:when>

    <c:otherwise>
        <a href="${pageContext.request.contextPath}/groupmember/create?groupId=${group.id}">
            <button type="button" class="btn btn-success">✅ 이 그룹에 가입하기</button>
        </a>
    </c:otherwise>

</c:choose>

    <div class="btn-group">
	    <!-- 목록으로 이동 -->
	    <a href="${pageContext.request.contextPath}/group/groups">
	        <button class="btn btn-list">목록으로</button>
	    </a>
	
	    <c:if test="${not empty loginMember and loginMember.id == group.leaderId}">
		    <!-- 그룹 수정 -->
		    <a href="${pageContext.request.contextPath}/group/edit?id=${group.id}">
		        <button class="btn btn-edit">수정</button>
		    </a>
		
		    <!-- 그룹 삭제 -->
		    <a href="${pageContext.request.contextPath}/group/delete?id=${group.id}" 
		       onclick="return confirm('정말 삭제할까요?');">
		        <button class="btn btn-delete">삭제</button>
		    </a>
		</c:if>

	
	    <!-- ✅ 멤버 보기: 공개 그룹은 누구나 / 비공개는 로그인 + 가입자만 -->
	    <c:choose>
	        
	        <c:when test="${group.publicStatus}">
	            <a href="${pageContext.request.contextPath}/groupmember/list?groupId=${group.id}">
	                <button class="btn btn-primary">📋 멤버 보기</button>
	            </a>
	        </c:when>
	
	        
	        <c:otherwise>
	            <c:if test="${not empty loginMember and isMember}">
	                <a href="${pageContext.request.contextPath}/groupmember/list?groupId=${group.id}">
	                    <button class="btn btn-primary">📋 멤버 보기</button>
	                </a>
	            </c:if>
	        </c:otherwise>
	    </c:choose>
	</div>
	
	<!-- ✅ 일반 멤버는 탈퇴 가능 (그룹장이 아닌 경우에만 보임) -->
	<c:if test="${not empty loginMember and isMember and loginMember.id != group.leaderId}">
	    <form action="${pageContext.request.contextPath}/groupmember/delete" method="post" style="margin-top: 10px;">
	        <input type="hidden" name="groupId" value="${group.id}" />
	        <input type="hidden" name="memberId" value="${loginMember.id}" />
	        <button type="submit" class="btn btn-warning">그룹 탈퇴</button>
	    </form>
	</c:if>
	
	<!-- ✅ 그룹장 탈퇴 버튼 (혼자일 때만 보이게) -->
	<c:if test="${not empty loginMember 
	             and isMember 
	             and loginMember.id == group.leaderId 
	             and currentMemberCount == 1}">
	    <form action="${pageContext.request.contextPath}/groupmember/leave" method="post" style="margin-top: 10px;">
	        <input type="hidden" name="groupId" value="${group.id}" />
	        <button type="submit" class="btn btn-danger">그룹 탈퇴</button>
	    </form>
	</c:if>
	
	
</div>



<script>
    function copyInviteCode() {
        const input = document.getElementById("inviteCode");
        input.type = 'text'; // 비밀번호 필드를 일반 텍스트로 바꿔서 복사 가능하게
        input.select();
        input.setSelectionRange(0, 99999); // 모바일 호환
        document.execCommand("copy");
        alert("초대코드가 복사되었습니다!");
        input.type = 'password'; // 다시 비밀번호 필드로 변경
    }
</script>

</body>
</html>
