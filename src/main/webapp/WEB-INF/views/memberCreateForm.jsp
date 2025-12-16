<%@ page contentType="text/html; charset=UTF-8" %>

<html>
<head>
    <title>회원가입</title>
    <!-- 외부 CSS 연결 -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberCreateForm.css">
</head>
<body>

<h2>회원가입</h2>

<form id="signUpForm" method="post" 
      action="${pageContext.request.contextPath}/member/create" 
      enctype="multipart/form-data">
      
    <!-- 아이디 -->
    <label for="user_id">아이디</label>
    <input type="text" id="user_id" name="user_id" required />
    <input type="hidden" id="contextPath" value="${pageContext.request.contextPath}" />
    <button type="button" onclick="checkId()">중복확인</button>
    <div id="idError"></div>

    <!-- 비밀번호 -->
    <label for="password">비밀번호</label>
    <input type="password" id="password" name="password" required />
    
    <!-- 비밀번호 확인 -->
    <label for="passwordCheck">비밀번호 확인</label>
    <input type="password" id="passwordCheck" required />
    
    <!-- 비밀번호 검사 결과 메시지 -->
    <div id="pwError" class="check-msg"></div>

    <!-- 실명 -->
    <label for="real_name">실명</label>
    <input type="text" id="real_name" name="real_name" required />

    <!-- 닉네임 입력창 + 중복확인 버튼 -->
    <label for="nickname">닉네임</label>
    <input type="text" id="nickname" name="nickname" required />
    <button type="button" onclick="checkNickname()">중복확인</button>
    <div id="nicknameCheckResult" class="check-msg"></div>

    <!-- 프로필 이미지 -->
    <label for="profileImageFile">프로필 이미지 (선택)</label>
    <input type="file" name="profileImageFile" id="profileImageFile" accept="image/*" />

    <!-- 이메일 입력 -->
    <label for="email">이메일</label>
    <input type="email" id="email" name="email" required>
    <button type="button" onclick="sendEmailCode()" id="sendCodeBtn">인증번호 전송</button>
    
    <!-- 타이머 표시 -->
    <div id="timerDisplay" style="margin-top: 5px; font-weight: bold; color: red;"></div>
    
    <!-- 인증번호 입력 -->
    <label for="emailCode">인증번호 입력</label>
    <input type="text" id="emailCode" placeholder="인증번호 입력">
    <button type="button" onclick="verifyEmailCode()" id="verifyBtn">인증번호 확인</button>
    
    <!-- 인증 결과 메시지 -->
    <div id="emailResult" style="margin-top: 5px; color: green;"></div>

    <!-- 우편번호 -->
    <label for="zipcode">우편번호</label>
    <input type="text" id="zipcode" name="zipcode" readonly required/>
    <button type="button" onclick="execDaumPostcode()">주소 검색</button>
    
    <!-- 기본 주소 -->
    <label for="address">기본 주소</label>
    <input type="text" id="address" name="address" readonly required/>
    
    <!-- 상세 주소 -->
    <label for="addressDetail">상세 주소</label>
    <input type="text" id="addressDetail" name="addressDetail" placeholder="상세주소 입력" required/>

    <!-- 휴대폰 번호 -->
    <label for="phone2">휴대폰 번호</label>
    <div>
        <select name="phone1" required>
            <option value="010">010</option>
            <option value="011">011</option>
            <option value="016">016</option>
        </select> -
        <input type="text" id="phone2" name="phone2" maxlength="4" pattern="\d{3,4}" required /> -
        <input type="text" id="phone3" name="phone3" maxlength="4" pattern="\d{4}" required />
    </div>

    <button type="submit" class="submit-btn">가입하기</button>
</form>

<!-- Daum 주소 검색 API 스크립트 먼저 포함 -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<!-- 주소 검색 실행 함수 정의 -->
<script>
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            var addr = '';

            if (data.userSelectedType === 'R') {
                addr = data.roadAddress;
            } else {
                addr = data.jibunAddress;
            }

            document.getElementById('zipcode').value = data.zonecode;
            document.getElementById("address").value = addr;
            document.getElementById("addressDetail").focus();
        }
    }).open();
}
</script>

<!-- 외부 JS 연결 -->
<script src="${pageContext.request.contextPath}/resources/js/memberCreateForm.js" defer></script>
</body>
</html>