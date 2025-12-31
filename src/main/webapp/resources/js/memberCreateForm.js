// 상태 관리 변수 (중복 확인 및 인증 여부)
let idCheckResult = null;
let nicknameCheckResult = null;
let emailAuthStatus = false; // 이메일 인증 성공 여부
let timerInterval;

// 유틸리티: 에러 메시지 출력 전용
function setError(elementId, message, isSuccess = false) {
    const element = document.getElementById(elementId);
    if (!element) return;
    element.innerText = message;
    element.className = isSuccess ? 'form-text text-success fw-bold' : 'form-text text-danger fw-bold';
}

// 아이디 중복 확인
function checkId() {
    const userId = document.getElementById('user_id').value.trim();
    const contextPath = document.getElementById('contextPath').value;

    if (userId === '') {
        setError('idError', '아이디를 입력해주세요.');
        document.getElementById('user_id').focus();
        return;
    }

    fetch(`${contextPath}/member/checkId?user_id=${encodeURIComponent(userId)}`)
    .then(res => res.json())
    .then(data => {
        idCheckResult = data.result;
        if (data.result === 'available') {
            setError('idError', '사용 가능한 아이디입니다.', true);
        } else {
            setError('idError', '이미 사용 중인 아이디입니다.');
            idCheckResult = 'duplicate';
        }
    })
    .catch(() => setError('idError', '서버 통신 실패'));
}

// 닉네임 중복 확인
function checkNickname() {
    const nickname = document.getElementById('nickname').value.trim();
    const contextPath = document.getElementById('contextPath').value;

    if (nickname === '') {
        setError('nicknameCheckResult', '닉네임을 입력해주세요.');
        document.getElementById('nickname').focus();
        return;
    }

    fetch(`${contextPath}/member/checkNickname?nickname=${encodeURIComponent(nickname)}`)
    .then(res => res.json())
    .then(data => {
        nicknameCheckResult = data.result;
        if (data.result === 'available') {
            setError('nicknameCheckResult', '사용 가능한 닉네임입니다.', true);
        } else {
            setError('nicknameCheckResult', '이미 사용 중인 닉네임입니다.');
        }
    });
}

// 이메일 중복 확인 및 전송 버튼 활성화
function checkEmail() {
    const email = document.getElementById('email').value.trim();
    const contextPath = document.getElementById('contextPath').value;
    const sendBtn = document.getElementById('sendCodeBtn');

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        setError('emailCheckResult', '유효한 이메일 형식이 아닙니다.');
        sendBtn.disabled = true;
        return;
    }

    fetch(`${contextPath}/member/checkEmail?email=${encodeURIComponent(email)}`)
    .then(res => res.json())
    .then(data => {
        if (data.result === 'available') {
            setError('emailCheckResult', '사용 가능한 이메일입니다.', true);
            sendBtn.disabled = false;
        } else {
            setError('emailCheckResult', '이미 등록된 이메일입니다.');
            sendBtn.disabled = true;
        }
    });
}

// 비밀번호 실시간 체크
document.addEventListener('DOMContentLoaded', function () {
    const pw = document.getElementById('password');
    const pwCheck = document.getElementById('passwordCheck');

    const validatePw = () => {
        if (pw.value && pwCheck.value) {
            if (pw.value === pwCheck.value) {
                setError('pwError', '비밀번호가 일치합니다.', true);
            } else {
                setError('pwError', '비밀번호가 일치하지 않습니다.');
            }
        }
    };
    pw.addEventListener('input', validatePw);
    pwCheck.addEventListener('input', validatePw);

    // [중요] 폼 제출(Submit) 최종 검증
    document.getElementById('signUpForm').addEventListener('submit', function (e) {
        const userId = document.getElementById('user_id').value.trim();
        const userPw = document.getElementById('password').value.trim();
        const userPwConfirm = document.getElementById('passwordCheck').value.trim();
        const realName = document.getElementById('real_name').value.trim();
        const nickname = document.getElementById('nickname').value.trim();
        const zipcode = document.getElementById('zipcode').value.trim();

        // 1. 공백 검사 및 포커스
        if (!userId) {
            setError('idError', '아이디를 입력하세요.');
            document.getElementById('user_id').focus();
            return e.preventDefault();
        }
        if (!userPw) {
            setError('pwError', '비밀번호를 입력하세요.');
            document.getElementById('password').focus();
            return e.preventDefault();
        }
        if (userPw !== userPwConfirm) {
            setError('pwError', '비밀번호가 일치하지 않습니다.');
            document.getElementById('passwordCheck').focus();
            return e.preventDefault();
        }
        if (!realName) {
            alert('실명을 입력해주세요.');
            document.getElementById('real_name').focus();
            return e.preventDefault();
        }
        if (!nickname) {
            setError('nicknameCheckResult', '닉네임을 입력하세요.');
            document.getElementById('nickname').focus();
            return e.preventDefault();
        }

        // 2. 중복 확인 여부 검사
        if (idCheckResult !== 'available') {
            setError('idError', '아이디 중복 확인이 필요합니다.');
            document.getElementById('user_id').focus();
            return e.preventDefault();
        }
        if (nicknameCheckResult !== 'available') {
            setError('nicknameCheckResult', '닉네임 중복 확인이 필요합니다.');
            document.getElementById('nickname').focus();
            return e.preventDefault();
        }

        // 3. 인증 여부 검사
        if (!emailAuthStatus) {
            setError('emailResult', '이메일 인증을 완료해주세요.');
            document.getElementById('email').focus();
            return e.preventDefault();
        }

        // 4. 주소 검사
        if (!zipcode) {
            alert('주소 검색을 완료해주세요.');
            return e.preventDefault();
        }
        
        // 모든 검증 통과 시 제출 진행
    });
});

// 이메일 인증번호 발송 및 타이머 로직
function sendEmailCode() {
    const email = document.getElementById("email").value;
    if (timerInterval) clearInterval(timerInterval);

    let timeLeft = 180;
    const timerDisp = document.getElementById("timerDisplay");
    
    timerInterval = setInterval(() => {
        const min = Math.floor(timeLeft / 60);
        const sec = timeLeft % 60;
        timerDisp.innerText = `남은 시간: ${min}:${sec < 10 ? '0' + sec : sec}`;
        if (--timeLeft < 0) {
            clearInterval(timerInterval);
            timerDisp.innerText = "시간 만료. 다시 시도하세요.";
            document.getElementById("verifyBtn").disabled = true;
        }
    }, 1000);

    fetch("/fairplay/mail/sendCode", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `email=${encodeURIComponent(email)}`
    }).then(() => setError('emailResult', '인증번호가 발송되었습니다.', true));
}

// 인증번호 확인 로직
function verifyEmailCode() {
    const code = document.getElementById("emailCode").value;
    fetch("/fairplay/mail/verifyCode", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `code=${encodeURIComponent(code)}`
    })
    .then(res => res.text())
    .then(msg => {
        if (msg.includes("성공")) {
            setError('emailResult', '인증 성공!', true);
            emailAuthStatus = true;
            clearInterval(timerInterval);
            document.getElementById("timerDisplay").innerText = "";
            document.getElementById("emailCode").disabled = true;
            document.getElementById("verifyBtn").disabled = true;
        } else {
            setError('emailResult', '인증번호가 일치하지 않습니다.');
        }
    });
}