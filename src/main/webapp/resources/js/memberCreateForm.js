// 중복 확인 결과 전역 변수
let idCheckResult = null;
let nicknameCheckResult = null;
let timerInterval; // 전역으로 타이머 ID 관리

// 아이디 중복 확인
function checkId() {
    const userId = document.getElementById('user_id').value.trim();
    const contextPath = document.getElementById('contextPath').value;
    const idErrorDiv = document.getElementById('idError');

    if (userId === '') {
        idErrorDiv.className = 'form-text text-danger';
        idErrorDiv.innerText = '아이디를 입력해주세요.';
        idCheckResult = null;
        return;
    }

    fetch(contextPath + '/member/checkId?user_id=' + encodeURIComponent(userId), {
        method: 'GET',
        headers: { 'Accept': 'application/json' }
    })
    .then(res => res.json())
    .then(data => {
        idCheckResult = data.result;
        if (data.result === 'duplicate') {
            idErrorDiv.className = 'form-text text-danger';
            idErrorDiv.innerText = '이미 사용 중인 아이디입니다.';
        } else if (data.result === 'available') {
            idErrorDiv.className = 'form-text text-success';
            idErrorDiv.innerText = '사용 가능한 아이디입니다.';
        } else {
            idErrorDiv.className = 'form-text text-danger';
            idErrorDiv.innerText = '응답 처리 오류';
        }
    })
    .catch(error => {
        console.error("fetch 오류:", error);
        idErrorDiv.className = 'form-text text-danger';
        idErrorDiv.innerText = '서버 통신 실패';
    });
}

// 닉네임 중복 확인
function checkNickname() {
    const nickname = document.getElementById('nickname').value.trim();
    const contextPath = document.getElementById('contextPath').value;
    const nickDiv = document.getElementById('nicknameCheckResult');

    if (nickname === '') {
        nickDiv.className = 'form-text text-danger';
        nickDiv.innerText = '닉네임을 입력해주세요.';
        nicknameCheckResult = null;
        return;
    }

    fetch(contextPath + '/member/checkNickname?nickname=' + encodeURIComponent(nickname), {
        method: 'GET',
        headers: { 'Accept': 'application/json' }
    })
    .then(res => res.json())
    .then(data => {
        nicknameCheckResult = data.result;
        if (data.result === 'duplicate') {
            nickDiv.className = 'form-text text-danger';
            nickDiv.innerText = '이미 사용 중인 닉네임입니다.';
        } else if (data.result === 'available') {
            nickDiv.className = 'form-text text-success';
            nickDiv.innerText = '사용 가능한 닉네임입니다.';
        } else {
            nickDiv.className = 'form-text text-danger';
            nickDiv.innerText = '응답 처리 오류';
        }
    })
    .catch(error => {
        console.error("닉네임 fetch 오류:", error);
        nickDiv.className = 'form-text text-danger';
        nickDiv.innerText = '서버 통신 실패';
    });
}

// 전체 submit 유효성 검사
document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('signUpForm').addEventListener('submit', function (e) {
        const userId = document.getElementById('user_id').value.trim();
        const idErrorDiv = document.getElementById('idError');

        const pw = document.getElementById('password').value;
        const pwCheck = document.getElementById('passwordCheck').value;
        const pwError = document.getElementById('pwError');

        const emailResultText = document.getElementById("emailResult").innerText;
        const nickname = document.getElementById('nickname').value.trim();
        const zipcode = document.getElementById('zipcode').value.trim();
        const address = document.getElementById('address').value.trim();

        // 아이디 공백 체크 (복원)
        if (userId === '') {
            e.preventDefault();
            idErrorDiv.className = 'form-text text-danger';
            idErrorDiv.innerText = '아이디를 입력해주세요.';
            return;
        }

        // 닉네임 공백 체크
        if (nickname === '') {
            e.preventDefault();
            const nickDiv = document.getElementById('nicknameCheckResult');
            nickDiv.className = 'form-text text-danger';
            nickDiv.innerText = '닉네임은 필수 입력입니다.';
            return;
        }

        // 비밀번호 불일치
        if (pw !== pwCheck) {
            e.preventDefault();
            pwError.className = 'form-text text-danger';
            pwError.innerText = '비밀번호가 일치하지 않습니다.';
        }

        // 아이디 중복 미확인 또는 중복
        if (idCheckResult !== 'available') {
            e.preventDefault();
            idErrorDiv.className = 'form-text text-danger';
            idErrorDiv.innerText = '아이디 중복 확인이 필요하거나, 중복된 아이디입니다.';
        }

        // 닉네임 중복 미확인 또는 중복
        if (nicknameCheckResult !== 'available') {
            e.preventDefault();
            const nickDiv = document.getElementById('nicknameCheckResult');
            nickDiv.className = 'form-text text-danger';
            nickDiv.innerText = '닉네임 중복 확인이 필요하거나, 중복된 닉네임입니다.';
        }

        // 이메일 인증 여부
        if (!emailResultText.includes("성공")) {
            e.preventDefault();
            const emailDiv = document.getElementById("emailResult");
            emailDiv.className = 'form-text text-danger';
            emailDiv.innerText = "이메일 인증을 완료해주세요.";
        }

        // 주소 검사
        if (zipcode === '' || address === '') {
            e.preventDefault();
            alert('주소 검색을 통해 우편번호와 기본 주소를 입력해주세요.');
        }
    });
});

// 시간 포맷 함수
function formatTime(seconds) {
    const min = Math.floor(seconds / 60);
    const sec = seconds % 60;
    return `${min}:${sec < 10 ? '0' + sec : sec}`;
}

// 이메일 인증번호 전송
function sendEmailCode() {
    const email = document.getElementById("email").value.trim();
    const emailResult = document.getElementById("emailResult");
    const timerDisplay = document.getElementById("timerDisplay");
    const emailCodeInput = document.getElementById("emailCode");
    const verifyBtn = document.getElementById("verifyBtn");

    if (email === "") {
        emailResult.className = 'form-text text-danger';
        emailResult.innerText = "이메일을 입력해주세요.";
        return;
    }

    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
        emailResult.className = 'form-text text-danger';
        emailResult.innerText = "올바른 이메일 형식을 입력해주세요.";
        return;
    }

    if (timerInterval) clearInterval(timerInterval);

    emailCodeInput.disabled = false;
    verifyBtn.disabled = false;

    let timeLeft = 180;
    timerDisplay.innerText = `남은 시간: ${formatTime(timeLeft)}`;
    timerInterval = setInterval(() => {
        timeLeft--;
        if (timeLeft <= 0) {
            clearInterval(timerInterval);
            timerDisplay.innerText = "인증 시간이 만료되었습니다. 다시 전송 버튼을 눌러주세요.";
            emailCodeInput.disabled = true;
            verifyBtn.disabled = true;
        } else {
            timerDisplay.innerText = `남은 시간: ${formatTime(timeLeft)}`;
        }
    }, 1000);

    fetch("/fairplay/mail/sendCode", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "email=" + encodeURIComponent(email)
    })
    .then(response => response.text())
    .then(msg => {
        emailResult.className = msg.includes("성공") ? 'form-text text-success' : 'form-text text-danger';
        emailResult.innerText = msg;
    })
    .catch(error => {
        emailResult.className = 'form-text text-danger';
        emailResult.innerText = "인증 요청 실패";
        console.error("인증 요청 실패:", error);
    });
}

// 인증번호 확인
function verifyEmailCode() {
    const code = document.getElementById("emailCode").value;
    const timerDisplay = document.getElementById("timerDisplay");
    const emailCodeInput = document.getElementById("emailCode");
    const verifyBtn = document.getElementById("verifyBtn");

    fetch("/fairplay/mail/verifyCode", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8" },
        body: "code=" + encodeURIComponent(code)
    })
    .then(response => response.text())
    .then(msg => {
        const emailResult = document.getElementById("emailResult");
        if (msg.includes("성공")) {
            emailResult.className = 'form-text text-success';
            emailResult.innerText = msg;
            clearInterval(timerInterval);
            timerDisplay.innerText = "";
            emailCodeInput.disabled = true;
            verifyBtn.disabled = true;
        } else {
            emailResult.className = 'form-text text-danger';
            emailResult.innerText = msg || '인증 실패';
        }
    })
    .catch(error => {
        const emailResult = document.getElementById("emailResult");
        emailResult.className = 'form-text text-danger';
        emailResult.innerText = "인증 실패";
        console.error("인증 실패:", error);
    });
}