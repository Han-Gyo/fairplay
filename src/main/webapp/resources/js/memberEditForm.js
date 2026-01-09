console.log(" memberEditForm.js 연결 확인");

document.addEventListener('DOMContentLoaded', function () {
    console.log("JS 로딩됨");

    // ===== 공통 메시지 출력 헬퍼 ===== //
    function showResult(targetDiv, message, type) {
        // type: success, danger, warning, info, muted
        targetDiv.innerHTML = `<span class="text-${type}">${message}</span>`;
    }

    // ===== 이메일 & 전화번호 유효성 검사 ===== //
    const emailInput = document.getElementById('email');
    const phone2 = document.getElementById('phone2');
    const phone3 = document.getElementById('phone3');
    const editForm = document.getElementById('editForm');

    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const phoneRegex = /^\d{3,4}$/;

    editForm.addEventListener('submit', function(e) {
        const email = emailInput.value.trim();
        const emailValid = emailRegex.test(email);
        const phoneValid = phoneRegex.test(phone2.value) && phoneRegex.test(phone3.value);

        if (!emailValid || !phoneValid) {
            e.preventDefault(); // 서버 전송 차단
            alert("입력 형식을 확인해주세요.");
        }
    });

    // ===== 이메일 관련 변수 ===== //
    const emailErrorDiv = document.createElement('div');
    emailErrorDiv.className = 'form-text text-danger';
    emailInput.parentNode.appendChild(emailErrorDiv);

    const emailCheckResult = document.getElementById("emailCheckResult");
    const checkEmailBtn = document.getElementById("checkEmailBtn");
    const sendEmailBtn = document.getElementById("sendEmailCodeBtn");
    const verifyEmailBtn = document.getElementById("verifyEmailCodeBtn");
    const emailCodeInput = document.getElementById("emailCode");
    const originalEmail = document.getElementById("originalEmail").value;

    // 입력 이벤트: 형식 검사 + 중복 확인 버튼만 제어
	emailInput.addEventListener('input', function () {
	    const email = emailInput.value.trim();

	    if (email === originalEmail) {
	        showResult(emailCheckResult, "현재 사용 중인 이메일입니다.", "muted");
	        checkEmailBtn.disabled = true;
	        sendEmailBtn.disabled = true; // 기존 이메일이면 발송 버튼도 비활성화
	        return;
	    }

	    if (!emailRegex.test(email)) {
	        showResult(emailCheckResult, "올바른 이메일 형식이 아닙니다.", "danger");
	        checkEmailBtn.disabled = true;
	        sendEmailBtn.disabled = true; // 형식 틀리면 발송 버튼도 비활성화
	        return;
	    }

	    // 형식만 맞으면 중복 확인 버튼 활성화
	    checkEmailBtn.disabled = false;

	    // 이메일이 바뀌었으니 발송 버튼은 항상 초기화
	    sendEmailBtn.disabled = true;

	    // 인증 상태 초기화
	    const hiddenInput = document.querySelector("input[name='emailVerified']");
	    if (hiddenInput) hiddenInput.remove();
	});

    // 중복 확인 버튼 클릭 이벤트: Ajax 호출
    checkEmailBtn.addEventListener('click', function () {
        const email = emailInput.value.trim();

        fetch(contextPath + "/member/checkEmail?email=" + encodeURIComponent(email))
            .then(res => res.json())
            .then(data => {
                if (data.result === "duplicate") {
                    showResult(emailCheckResult, "이미 사용 중인 이메일입니다.", "danger");
                    sendEmailBtn.disabled = true;
                } else {
                    showResult(emailCheckResult, "사용 가능한 이메일입니다. 인증이 필요합니다.", "success");
                    sendEmailBtn.disabled = false; // 중복검사 통과 후에만 활성화
                }
            })
            .catch(err => {
                console.error("이메일 중복 확인 오류:", err);
                showResult(emailCheckResult, "서버 오류가 발생했습니다.", "danger");
                sendEmailBtn.disabled = true;
            });
    });

    // 전화번호 실시간 검사
    const phoneErrorDiv = document.createElement('div');
    phoneErrorDiv.className = 'form-text text-danger';
    phone3.parentNode.parentNode.appendChild(phoneErrorDiv);

    function validatePhoneInput() {
        const valid = phoneRegex.test(phone2.value) && phoneRegex.test(phone3.value);
        phoneErrorDiv.textContent = valid ? '' : '휴대폰 번호는 숫자 3~4자리씩 입력해주세요.';
    }

    phone2.addEventListener('input', validatePhoneInput);
    phone3.addEventListener('input', validatePhoneInput);

    // ===== 닉네임 중복 확인 버튼 ===== //
    const nicknameInput = document.getElementById('nickname');
    const checkBtn = document.getElementById('checkNicknameBtn');
    const resultDiv = document.getElementById('nicknameCheckResult');

    if (!checkBtn) {
        console.error(" checkNicknameBtn 찾을 수 없음");
        return;
    }

    checkBtn.addEventListener('click', function () {
        console.log(" [중복 확인] 버튼 클릭됨");

        const nickname = nicknameInput.value.trim();

        if (nickname === "") {
            showResult(resultDiv, "닉네임을 입력해주세요.", "danger");
            return;
        }

        fetch(contextPath + '/mypage/checkNicknameAjax?nickname=' + encodeURIComponent(nickname))
            .then(response => response.json())
            .then(data => {
                console.log("서버 응답:", data);
                if (data.result === "unauthorized") {
                    showResult(resultDiv, "로그인이 필요합니다.", "muted");
                } else if (data.result === "duplicate") {
                    showResult(resultDiv, "이미 사용 중인 닉네임입니다.", "danger");
                } else {
                    showResult(resultDiv, "사용 가능한 닉네임입니다.", "success");
                }
            })
            .catch(error => {
                console.error("Ajax 오류:", error);
                showResult(resultDiv, "서버 오류가 발생했습니다.", "muted");
            });
    });

    // ===== 이메일 인증 발송 ===== //
    if (sendEmailBtn) {
        sendEmailBtn.disabled = true; // 초기 비활성화

        sendEmailBtn.addEventListener("click", function () {
            const email = emailInput.value.trim();
            if (email === "") {
                showResult(emailCheckResult, "이메일을 입력해주세요.", "danger");
                return;
            }

            fetch(contextPath + "/mail/sendCode", {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: "email=" + encodeURIComponent(email)
            })
            .then(res => res.text())
            .then(msg => {
                showResult(emailCheckResult, msg, "info");
            })
            .catch(err => {
                console.error("이메일 발송 오류:", err);
                showResult(emailCheckResult, "서버 오류가 발생했습니다.", "danger");
            });
        });
    }

	    // 인증번호 확인
	    if (verifyEmailBtn) {
	        verifyEmailBtn.addEventListener("click", function () {
	            const code = emailCodeInput.value.trim();
	            if (code === "") {
	                showResult(emailCheckResult, "인증번호를 입력해주세요.", "danger");
	                return;
	            }

	            fetch(contextPath + "/mail/verifyCode", {
	                method: "POST",
	                headers: { "Content-Type": "application/x-www-form-urlencoded" },
	                body: "code=" + encodeURIComponent(code)
	            })
	            .then(res => res.text())
	            .then(msg => {
	                if (msg.includes("성공")) {
	                    showResult(emailCheckResult, msg, "success");
	                    const hiddenInput = document.createElement("input");
	                    hiddenInput.type = "hidden";
	                    hiddenInput.name = "emailVerified";
	                    hiddenInput.value = "true";
	                    document.getElementById("editForm").appendChild(hiddenInput);
	                } else {
	                    showResult(emailCheckResult, msg, "danger");
	                }
	            })
	            .catch(err => {
	                console.error("인증 확인 오류:", err);
	                showResult(emailCheckResult, "서버 오류가 발생했습니다.", "danger");
	            });
	        });
	    }

	    // 프사 미리보기 기능
	    const fileInput = document.getElementById('profileImageFile');
	    const previewImg = document.getElementById('profilePreview');

	    if (fileInput && previewImg) {
	        fileInput.addEventListener('change', function (e) {
	            const file = e.target.files[0];
	            console.log("선택된 파일:", file);
	            if (file) {
	                previewImg.src = URL.createObjectURL(file);
	            }
	        });
	    }

	    // 기본 이미지 버튼 처리
	    const resetBtn = document.getElementById('resetImageBtn');
	    const resetInput = document.getElementById('resetProfileImage');

	    if (resetBtn && previewImg && resetInput) {
	        resetBtn.addEventListener('click', function () {
	            const defaultSrc = contextPath + '/resources/img/default-profile.png';
	            previewImg.src = defaultSrc;
	            resetInput.value = 'true';
	            if (fileInput) {
	                fileInput.value = '';
	            }
	        });
	    }

	    // 프사 클릭 시 확대 모달 띄우기
	    const imageModal = document.getElementById('imageModal');
	    const modalImage = document.getElementById('modalImage');

	    if (previewImg && imageModal && modalImage) {
	        previewImg.addEventListener('click', function () {
	            if (previewImg.src) {
	                modalImage.src = previewImg.src;
	                imageModal.style.display = 'flex';
	            }
	        });

	        imageModal.addEventListener('click', function () {
	            imageModal.style.display = 'none';
	            modalImage.src = '';
	        });
	    }

	    // ===== 비밀번호 변경 ===== //
	    const pwForm = document.getElementById("pwChangeForm");
	    const currentPw = document.getElementById("currentPassword");
	    const newPw = document.getElementById("newPassword");
	    const confirmPw = document.getElementById("confirmPassword");
	    const pwChangeResult = document.getElementById("pwChangeResult");

	    // 회원가입 때와 동일한 정규식 (8~16자리, 소문자+숫자+특수문자 포함)
	    const pwRegex = /^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*]).{8,16}$/;

	    if (pwForm) {
	        pwForm.addEventListener("submit", function(e) {
	            e.preventDefault(); // 기본 폼 제출 막기

	            // 클라이언트 측 유효성 검사
	            if (!pwRegex.test(newPw.value)) {
	                showResult(pwChangeResult, "비밀번호는 8~16자의 영문 소문자, 숫자, 특수문자를 포함해야 합니다.", "danger");
	                return;
	            }
	            if (newPw.value !== confirmPw.value) {
	                showResult(pwChangeResult, "새 비밀번호와 확인 비밀번호가 일치하지 않습니다.", "danger");
	                return;
	            }

	            // 서버 요청 (JSON 응답)
	            fetch(contextPath + "/mypage/changePw", {
	                method: "POST",
	                headers: { "Content-Type": "application/x-www-form-urlencoded" },
	                body: "currentPassword=" + encodeURIComponent(currentPw.value) +
	                      "&newPassword=" + encodeURIComponent(newPw.value) +
	                      "&confirmPassword=" + encodeURIComponent(confirmPw.value)
	            })
	            .then(res => res.json())
	            .then(data => {
	                if (data.result === "success") {
	                    showResult(pwChangeResult, data.message, "success");
	                    pwForm.reset(); // 성공 시 폼 초기화
	                } else {
	                    showResult(pwChangeResult, data.message, "danger");
	                }
	            })
	            .catch(err => {
	                console.error("비밀번호 변경 오류:", err);
	                showResult(pwChangeResult, "서버 오류가 발생했습니다.", "danger");
	            });
	        });
	    }

	}); // DOMContentLoaded 끝

	// 주소 검색 API 실행 함수
	function execDaumPostcode() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	            const roadAddr = data.roadAddress;
	            const zonecode = data.zonecode;

	            document.getElementById('postcode').value = zonecode;
	            document.getElementById('roadAddress').value = roadAddr;
	            document.getElementById('detailAddress').focus();

	            document.getElementById('address').value = `(${zonecode}) ${roadAddr}`;
	        }
	    }).open();
	}

	// 상세주소 입력 시 전체 주소 갱신
	document.addEventListener('DOMContentLoaded', function () {
	    const detailInput = document.getElementById('detailAddress');
	    const roadInput = document.getElementById('roadAddress');
	    const zoneInput = document.getElementById('postcode');
	    const fullInput = document.getElementById('address');

	    if (detailInput && roadInput && zoneInput && fullInput) {
	        detailInput.addEventListener('input', function () {
	            fullInput.value = `(${zoneInput.value}) ${roadInput.value} ${detailInput.value}`;
	        });
	    }
	});