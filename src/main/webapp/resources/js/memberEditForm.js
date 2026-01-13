console.log(" memberEditForm.js 연결 확인");

document.addEventListener('DOMContentLoaded', function () {
    console.log("JS 로딩됨");

    // ===== 공통 메시지 출력 헬퍼 ===== //
    function showResult(targetDiv, message, type) {
        targetDiv.innerHTML = `<span class="text-${type}">${message}</span>`;
    }

    // ===== 유효성 검증 및 제출 제어 ===== //
    const emailInput = document.getElementById('email');
    const phone2 = document.getElementById('phone2');
    const phone3 = document.getElementById('phone3');
    const editForm = document.getElementById('editForm');
    
    // 닉네임 관련
    const nicknameInput = document.getElementById("nickname");
    const checkNicknameBtn = document.getElementById("checkNicknameBtn");
    const nicknameCheckResult = document.getElementById("nicknameCheckResult");
    const originalNickname = nicknameInput ? nicknameInput.value.trim() : "";
    let isNicknameChecked = true;

    // 이메일 초기값 (제출 시 비교용)
    const originalEmail = document.getElementById("originalEmail").value.trim();

    const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    const phoneRegex = /^\d{3,4}$/;

    // [수정] 제출 전 로직: 이메일이 바뀌었을 때만 인증 체크
    editForm.addEventListener('submit', function(e) {
        const email = emailInput.value.trim();
        const phoneValid = phoneRegex.test(phone2.value) && phoneRegex.test(phone3.value);
        
        // 1. 전화번호 형식 검사
        if (!phoneValid) {
            e.preventDefault();
            alert("전화번호 형식을 확인해주세요.");
            return;
        }

        // 2. 닉네임 중복 체크 확인
        if (!isNicknameChecked) {
            e.preventDefault();
            alert("닉네임 중복 확인을 진행해주세요.");
            nicknameInput.focus();
            return;
        }

        // 3. [수정됨] 이메일 검증 로직
        // 이메일이 공백이거나 기존 이메일과 같다면 검사를 건너뛰고 제출 허용
        if (email !== "" && email !== originalEmail) {
            // 이메일 형식이 맞는지 확인
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert("올바른 이메일 형식이 아닙니다.");
                return;
            }

            // 형식이 맞다면 인증 완료 여부 확인
            const isEmailVerified = document.querySelector("input[name='emailVerified']");
            if (!isEmailVerified) {
                e.preventDefault();
                alert("이메일 변경 시 인증이 필요합니다.");
                return;
            }
        }
    });

    // ===== 닉네임 중복 확인 로직 (기존 유지) ===== //
    if (nicknameInput) {
        nicknameInput.addEventListener("input", function() {
            const currentNickname = nicknameInput.value.trim();
            if (currentNickname === originalNickname) {
                isNicknameChecked = true;
                showResult(nicknameCheckResult, "", "muted");
            } else {
                isNicknameChecked = false;
                showResult(nicknameCheckResult, "닉네임 중복 확인이 필요합니다.", "warning");
            }
        });

        checkNicknameBtn.addEventListener("click", function() {
            const nickname = nicknameInput.value.trim();
            if (nickname === "") {
                showResult(nicknameCheckResult, "닉네임을 입력해주세요.", "danger");
                return;
            }
            if (nickname === originalNickname) {
                showResult(nicknameCheckResult, "현재 사용 중인 본인의 닉네임입니다.", "success");
                isNicknameChecked = true;
                return;
            }

            fetch(contextPath + "/member/checkNickname?nickname=" + encodeURIComponent(nickname))
                .then(res => res.json())
                .then(data => {
                    if (data.result === "duplicate") {
                        showResult(nicknameCheckResult, "이미 사용 중인 닉네임입니다.", "danger");
                        isNicknameChecked = false;
                    } else {
                        showResult(nicknameCheckResult, "사용 가능한 닉네임입니다.", "success");
                        isNicknameChecked = true;
                    }
                })
                .catch(err => {
                    console.error("닉네임 중복 확인 오류:", err);
                    showResult(nicknameCheckResult, "서버 오류가 발생했습니다.", "danger");
                });
        });
    }

    // ===== 이메일 관련 변수 및 이벤트 (기존 유지) ===== //
    const emailCheckResult = document.getElementById("emailCheckResult");
    const checkEmailBtn = document.getElementById("checkEmailBtn");
    const sendEmailBtn = document.getElementById("sendEmailCodeBtn");
    const verifyEmailBtn = document.getElementById("verifyEmailCodeBtn");
    const emailCodeInput = document.getElementById("emailCode");
	const resetEmailBtn = document.getElementById("resetEmailBtn");

    emailInput.addEventListener('input', function () {
        const email = emailInput.value.trim();

        if (email === originalEmail || email === "") {
            showResult(emailCheckResult, email === "" ? "" : "현재 사용 중인 이메일입니다.", "muted");
            checkEmailBtn.disabled = true;
            sendEmailBtn.disabled = true;
            return;
        }

        if (!emailRegex.test(email)) {
            showResult(emailCheckResult, "올바른 이메일 형식이 아닙니다.", "danger");
            checkEmailBtn.disabled = true;
            sendEmailBtn.disabled = true;
            return;
        }

		showResult(emailCheckResult, "", "muted");
        checkEmailBtn.disabled = false;
        sendEmailBtn.disabled = true;

        const hiddenInput = document.querySelector("input[name='emailVerified']");
        if (hiddenInput) hiddenInput.remove();
    });

    // 중복 확인 버튼
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
                    sendEmailBtn.disabled = false;
                }
            })
            .catch(err => {
                console.error("이메일 중복 확인 오류:", err);
                showResult(emailCheckResult, "서버 오류가 발생했습니다.", "danger");
            });
    });

    // ===== 이메일 인증 발송 ===== //
    if (sendEmailBtn) {
		sendEmailBtn.addEventListener("click", function () {
		    const email = emailInput.value.trim();
		    fetch(contextPath + "/mail/sendCode", {
		        method: "POST",
		        headers: { "Content-Type": "application/x-www-form-urlencoded" },
		        body: "email=" + encodeURIComponent(email)
		    })
		    .then(res => res.text())
		    .then(msg => {
		        showResult(emailCheckResult, msg, "info");
		        emailInput.readOnly = true;
		        resetEmailBtn.style.display = "inline-block";
		    })
		    .catch(err => {
		        showResult(emailCheckResult, "서버 오류가 발생했습니다.", "danger");
		    });
		});
    }

    // ===== 이메일 다시 입력 버튼 ===== //
    if (resetEmailBtn) {
        resetEmailBtn.addEventListener("click", function () {
            emailInput.readOnly = false;
            emailInput.value = originalEmail; // 다시 입력 시 기존 이메일로 복구
            checkEmailBtn.disabled = true;
            sendEmailBtn.disabled = true;
            showResult(emailCheckResult, "", "muted");
            resetEmailBtn.style.display = "none";
        });
    }

    // ===== 인증번호 확인 ===== //
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
                    emailInput.readOnly = false;
                }
            });
        });
    }

    // ===== 프사 미리보기 (기존 유지) ===== //
    const fileInput = document.getElementById('profileImageFile');
    const previewImg = document.getElementById('profilePreview');

    if (fileInput && previewImg) {
        fileInput.addEventListener('change', function (e) {
            const file = e.target.files[0];
            if (file) {
                previewImg.src = URL.createObjectURL(file);
            }
        });
    }

    const resetBtn = document.getElementById('resetImageBtn');
    const resetInput = document.getElementById('resetProfileImage');

    if (resetBtn && previewImg && resetInput) {
        resetBtn.addEventListener('click', function () {
            const defaultSrc = contextPath + '/resources/img/default-profile.png';
            previewImg.src = defaultSrc;
            resetInput.value = 'true';
            if (fileInput) fileInput.value = '';
        });
    }

    // 프사 클릭 확대 모달 (기존 유지)
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
        });
    }

    // ===== 비밀번호 변경 (기존 유지) ===== //
    const pwForm = document.getElementById("pwChangeForm");
    const currentPw = document.getElementById("currentPassword");
    const newPw = document.getElementById("newPassword");
    const confirmPw = document.getElementById("confirmPassword");
    const pwChangeResult = document.getElementById("pwChangeResult");

    const pwRegex = /^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*]).{8,16}$/;

    if (pwForm) {
        pwForm.addEventListener("submit", function(e) {
            e.preventDefault();
            if (!pwRegex.test(newPw.value)) {
                showResult(pwChangeResult, "비밀번호는 8~16자의 영문 소문자, 숫자, 특수문자를 포함해야 합니다.", "danger");
                return;
            }
            if (newPw.value !== confirmPw.value) {
                showResult(pwChangeResult, "새 비밀번호와 확인 비밀번호가 일치하지 않습니다.", "danger");
                return;
            }
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
                    pwForm.reset();
                } else {
                    showResult(pwChangeResult, data.message, "danger");
                }
            });
        });
    }
});

// ===== 주소 검색 API 실행 함수 (기존 유지) ===== //
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