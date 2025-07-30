console.log("✅ memberEditForm.js 연결 확인");

document.addEventListener('DOMContentLoaded', function () {
    console.log("✅ JS 로딩됨");

    // ===== 📧 이메일 & 📱 전화번호 유효성 검사 ===== //
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
            e.preventDefault(); // 🚫 서버 전송 차단
            alert("입력 형식을 확인해주세요.");
        }
    });

    // 📧 이메일 실시간 검사
    const emailErrorDiv = document.createElement('div');
    emailErrorDiv.className = 'form-text text-danger';
    emailInput.parentNode.appendChild(emailErrorDiv);

    emailInput.addEventListener('input', function () {
        const email = emailInput.value.trim();
        if (!emailRegex.test(email)) {
            emailErrorDiv.textContent = '올바른 이메일 형식이 아닙니다.';
        } else {
            emailErrorDiv.textContent = '';
        }
    });

    // 📱 전화번호 실시간 검사
    const phoneErrorDiv = document.createElement('div');
    phoneErrorDiv.className = 'form-text text-danger';
    phone3.parentNode.parentNode.appendChild(phoneErrorDiv);

    function validatePhoneInput() {
        const valid = phoneRegex.test(phone2.value) && phoneRegex.test(phone3.value);
        phoneErrorDiv.textContent = valid ? '' : '휴대폰 번호는 숫자 3~4자리씩 입력해주세요.';
    }

    phone2.addEventListener('input', validatePhoneInput);
    phone3.addEventListener('input', validatePhoneInput);

	
	
    // ===== 📝 닉네임 중복 확인 버튼 ===== //
    const nicknameInput = document.getElementById('nickname');
    const checkBtn = document.getElementById('checkNicknameBtn');
    const resultDiv = document.getElementById('nicknameCheckResult');

    if (!checkBtn) {
        console.error("❌ checkNicknameBtn 찾을 수 없음");
        return;
    }

    checkBtn.addEventListener('click', function () {
        console.log("🔍 [중복 확인] 버튼 클릭됨");

        const nickname = nicknameInput.value.trim();

        if (nickname === "") {
            resultDiv.innerText = "닉네임을 입력해주세요.";
            resultDiv.style.color = "red";
            return;
        }

		fetch(contextPath + '/mypage/checkNicknameAjax?nickname=' + encodeURIComponent(nickname))
            .then(response => response.json())
            .then(data => {
                console.log("📬 서버 응답:", data);
				if (data.result === "unauthorized") {
				    resultDiv.innerText = "로그인이 필요합니다.";
				    resultDiv.style.color = "gray";
				} else if (data.result === "duplicate") {
				    resultDiv.innerText = "이미 사용 중인 닉네임입니다.";
				    resultDiv.style.color = "red";
				} else {
				    resultDiv.innerText = "사용 가능한 닉네임입니다.";
				    resultDiv.style.color = "green";
				}

            })
            .catch(error => {
                console.error("❌ Ajax 오류:", error);
                resultDiv.innerText = "서버 오류가 발생했습니다.";
                resultDiv.style.color = "gray";
            });
    });
});
