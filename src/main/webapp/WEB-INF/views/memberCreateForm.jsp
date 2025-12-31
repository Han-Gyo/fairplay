<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>회원가입</title>
    <!-- Bootstrap Minty 테마 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css" rel="stylesheet">
    <!-- 커스텀 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberCreateForm.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow-lg rounded">
                <div class="card-header text-center bg-primary text-white">
                    <h2 class="mb-0">회원가입</h2>
                </div>
                <div class="card-body">
                    <form id="signUpForm" method="post"
                          action="${pageContext.request.contextPath}/member/create"
                          enctype="multipart/form-data">

                        <!-- 아이디 -->
                        <div class="mb-3">
                            <label for="user_id" class="form-label">아이디</label>
                            <div class="input-group">
                                <input type="text" id="user_id" name="user_id" class="form-control" required>
                                <button type="button" class="btn btn-outline-primary" onclick="checkId()">중복확인</button>
                            </div>
                            <input type="hidden" id="contextPath" value="${pageContext.request.contextPath}" />
                            <div id="idError" class="form-text text-danger"></div>
                        </div>

                        <!-- 비밀번호 -->
                        <div class="mb-3">
                            <label for="password" class="form-label">비밀번호</label>
                            <input type="password" id="password" name="password" class="form-control" required>
                        </div>

                        <!-- 비밀번호 확인 -->
                        <div class="mb-3">
                            <label for="passwordCheck" class="form-label">비밀번호 확인</label>
                            <input type="password" id="passwordCheck" class="form-control" required>
                            <div id="pwError" class="form-text text-danger"></div>
                        </div>

                        <!-- 실명 -->
                        <div class="mb-3">
                            <label for="real_name" class="form-label">실명</label>
                            <input type="text" id="real_name" name="real_name" class="form-control" required>
                        </div>

                        <!-- 닉네임 -->
                        <div class="mb-3">
                            <label for="nickname" class="form-label">닉네임</label>
                            <div class="input-group">
                                <input type="text" id="nickname" name="nickname" class="form-control" required>
                                <button type="button" class="btn btn-outline-primary" onclick="checkNickname()">중복확인</button>
                            </div>
                            <div id="nicknameCheckResult" class="form-text"></div>
                        </div>

                        <!-- 프로필 이미지 -->
                        <div class="mb-3">
                            <label for="profileImageFile" class="form-label">프로필 이미지 (선택)</label>
                            <input type="file" name="profileImageFile" id="profileImageFile" class="form-control" accept="image/*">
                        </div>

                        <!-- 이메일 -->
                        <div class="mb-3">
                            <label for="email" class="form-label">이메일</label>
                            <div class="input-group">
                                <input type="email" id="email" name="email" class="form-control" required>
                                <button type="button" class="btn btn-outline-primary" onclick="checkEmail()">중복확인</button>
                                <button type="button" class="btn btn-outline-primary" 
        						onclick="sendEmailCode()" id="sendCodeBtn" disabled>인증번호 전송</button>
                            </div>
                            <div id="emailCheckResult" class="form-text mt-1"></div>
                            <div id="timerDisplay" class="form-text text-danger fw-bold mt-1"></div>
                        </div>

                        <!-- 인증번호 -->
                        <div class="mb-3">
                            <label for="emailCode" class="form-label">인증번호 입력</label>
                            <div class="input-group">
                                <input type="text" id="emailCode" class="form-control" placeholder="인증번호 입력">
                                <button type="button" class="btn btn-outline-success" onclick="verifyEmailCode()" id="verifyBtn">인증번호 확인</button>
                            </div>
                            <div id="emailResult" class="form-text text-success mt-1"></div>
                        </div>

                        <!-- 주소 -->
                        <div class="mb-3">
                            <label for="zipcode" class="form-label">우편번호</label>
                            <div class="input-group">
                                <input type="text" id="zipcode" name="zipcode" class="form-control" readonly required>
                                <button type="button" class="btn btn-outline-primary" onclick="execDaumPostcode()">주소 검색</button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="address" class="form-label">기본 주소</label>
                            <input type="text" id="address" name="address" class="form-control" readonly required>
                        </div>

                        <div class="mb-3">
                            <label for="addressDetail" class="form-label">상세 주소</label>
                            <input type="text" id="addressDetail" name="addressDetail" class="form-control" placeholder="상세주소 입력" required>
                        </div>

                        <!-- 휴대폰 번호 -->
                        <div class="mb-3">
                            <label class="form-label">휴대폰 번호</label>
                            <div class="input-group">
                                <select name="phone1" class="form-select" required>
                                    <option value="010">010</option>
                                    <option value="011">011</option>
                                    <option value="016">016</option>
                                </select>
                                <input type="text" id="phone2" name="phone2" class="form-control" maxlength="4" pattern="\d{3,4}" required>
                                <input type="text" id="phone3" name="phone3" class="form-control" maxlength="4" pattern="\d{4}" required>
                            </div>
                        </div>

                        <!-- 가입 버튼 -->
                        <div class="d-flex gap-2 mt-4">
						  <button type="submit" class="btn btn-success flex-fill">가입하기</button>
						  <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary flex-fill" role="button">홈으로</a>
						</div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Daum 주소 검색 API -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            var addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;
            document.getElementById('zipcode').value = data.zonecode;
            document.getElementById("address").value = addr;
            document.getElementById("addressDetail").focus();
        }
    }).open();
}
</script>

<!-- 외부 JS -->
<script src="${pageContext.request.contextPath}/resources/js/memberCreateForm.js" defer></script>
</body>
</html>