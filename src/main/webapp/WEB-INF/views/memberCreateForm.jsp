<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>회원가입 | Fairplay</title>
    <link href="https://cdn.jsdelivr.net/npm/bootswatch@5.3.2/dist/minty/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/memberCreateForm.css">
</head>
<body class="bg-light">

<div class="container mt-5 mb-5">
    <div class="row justify-content-center">
        <div class="col-md-7">
            <div class="card shadow-sm border-0 rounded-3">
                <div class="card-header text-center bg-primary text-white py-3">
                    <h3 class="mb-0 fw-bold">회원가입</h3>
                </div>
                <div class="card-body p-4">
                    <form id="signUpForm" method="post"
                          action="${pageContext.request.contextPath}/member/create"
                          enctype="multipart/form-data" novalidate>

                        <!-- 아이디 -->
						<div class="mb-3">
						    <label for="user_id" class="form-label fw-semibold">아이디</label>
						    <div class="input-group">
						        <input type="text" id="user_id" name="user_id"
						               class="form-control" placeholder="아이디를 입력하세요"
						               minlength="5" maxlength="20"
						               pattern="^[a-z0-9]{5,20}$"
						               required>
						        <button type="button" class="btn btn-primary" onclick="checkId()">중복확인</button>
						    </div>
						    <input type="hidden" id="contextPath" value="${pageContext.request.contextPath}" />
						    <div id="idError" class="form-text mt-1"></div>
						</div>


                        <!-- 비밀번호 -->
						<div class="mb-3">
						    <label for="password" class="form-label fw-semibold">비밀번호</label>
						    <input type="password" id="password" name="password"
						           class="form-control" placeholder="비밀번호 입력"
						           minlength="8" maxlength="16"
						           pattern="^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*]).{8,16}$"
						           required>
						    <div class="form-text">비밀번호는 8~16자의 영문 소문자, 숫자, 특수문자를 포함해야 합니다.</div>
						</div>
						
						<!-- 비밀번호 확인 -->
						<div class="mb-3">
						    <label for="passwordCheck" class="form-label fw-semibold">비밀번호 확인</label>
						    <input type="password" id="passwordCheck" name="passwordCheck"
						           class="form-control" placeholder="비밀번호 재입력"
						           minlength="8" maxlength="16"
						           pattern="^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*]).{8,16}$"
						           required>
						    <div id="pwError" class="form-text mt-1"></div>
						</div>

                        <!-- 실명 -->
                        <div class="mb-3">
                            <label for="real_name" class="form-label fw-semibold">실명</label>
                            <input type="text" id="real_name" name="real_name" class="form-control" placeholder="이름을 입력하세요" required>
                        </div>

                        <!-- 닉네임 -->
                        <div class="mb-3">
                            <label for="nickname" class="form-label fw-semibold">닉네임</label>
                            <div class="input-group">
                                <input type="text" id="nickname" name="nickname" class="form-control" placeholder="닉네임 입력" required>
                                <button type="button" class="btn btn-primary" onclick="checkNickname()">중복확인</button>
                            </div>
                            <div id="nicknameCheckResult" class="form-text mt-1"></div>
                        </div>

                        <!-- 프로필 이미지 -->
                        <div class="mb-3">
                            <label for="profileImageFile" class="form-label fw-semibold">프로필 이미지 (선택)</label>
                            <input type="file" name="profileImageFile" id="profileImageFile" class="form-control" accept="image/*">
                        </div>

                        <!-- 이메일 -->
                        <div class="mb-4">
						    <label for="email" class="form-label fw-semibold">이메일</label>
						    <div class="input-group mb-2">
						        <input type="email" id="email" name="email" class="form-control" placeholder="example@mail.com" required>
						        <button type="button" class="btn btn-primary" onclick="checkEmail()">중복확인</button>
						        <button type="button" class="btn btn-outline-primary" onclick="sendEmailCode()" id="sendCodeBtn" disabled>
						            인증번호 전송
						        </button>
						        <!-- 다시 입력 버튼 추가 -->
						        <button type="button" class="btn btn-warning" id="resetEmailBtn" style="display:none;">
						            다시 입력
						        </button>
						    </div>
						
						    <!-- 결과 메시지 영역 -->
						    <div id="emailCheckResult" class="form-text"></div>
						    <div id="timerDisplay" class="form-text text-danger fw-bold"></div>
						
						    <div class="input-group mt-2">
						        <input type="text" id="emailCode" class="form-control" placeholder="인증번호 6자리">
						        <button type="button" class="btn btn-success" onclick="verifyEmailCode()" id="verifyBtn">인증 확인</button>
						    </div>
						    <div id="emailResult" class="form-text"></div>
						</div>


                        <hr>

                        <!-- 주소 -->
                        <div class="mb-3">
                            <label for="zipcode" class="form-label fw-semibold">주소</label>
                            <div class="input-group mb-2">
                                <input type="text" id="zipcode" name="zipcode" class="form-control" placeholder="우편번호" readonly required>
                                <button type="button" class="btn btn-secondary" onclick="execDaumPostcode()">검색</button>
                            </div>
                            <input type="text" id="address" name="address" class="form-control mb-2" placeholder="기본 주소" readonly required>
                            <input type="text" id="addressDetail" name="addressDetail" class="form-control" placeholder="상세 주소를 입력하세요" required>
                        </div>

                        <!-- 휴대폰 -->
                        <div class="mb-4">
                            <label class="form-label fw-semibold">휴대폰 번호</label>
                            <div class="input-group">
                                <select name="phone1" class="form-select" style="max-width: 90px;" required>
                                    <option value="010">010</option>
                                    <option value="011">011</option>
                                    <option value="016">016</option>
                                </select>
                                <input type="text" id="phone2" name="phone2" class="form-control" maxlength="4" pattern="\\d{3,4}" required placeholder="숫자 3~4자리">
                                <input type="text" id="phone3" name="phone3" class="form-control" maxlength="4" pattern="\\d{4}" required placeholder="숫자 4자리">
                            </div>
                        </div>

                        <!-- 가입 버튼 -->
                        <div class="d-flex gap-2 mt-4">
                            <button type="submit" class="btn btn-success btn-lg fw-bold flex-fill">가입하기</button>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-lg fw-bold flex-fill d-flex align-items-center justify-content-center" role="button">홈으로</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

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
<script src="${pageContext.request.contextPath}/resources/js/memberCreateForm.js" defer></script>
</body>
</html>