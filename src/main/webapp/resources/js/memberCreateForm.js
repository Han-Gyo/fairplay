// 상태 관리 변수
let idCheckResult = null;
let nicknameCheckResult = null;
let emailAuthStatus = false;
let timerInterval;

// 에러 메시지 출력 함수
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
        return;
    }

    const idRegex = /^[a-z0-9]{5,20}$/;
    if (!idRegex.test(userId)) {
        setError('idError', '아이디는 5~20자의 영문 소문자와 숫자만 가능합니다.');
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
    })
    .catch(() => setError('nicknameCheckResult', '서버 통신 실패'));
}

// 이메일 중복 확인
function checkEmail() {
    const email = document.getElementById('email').value.trim();
    const contextPath = document.getElementById('contextPath').value;
    const sendBtn = document.getElementById('sendCodeBtn');
    const resetEmailBtn = document.getElementById("resetEmailBtn");

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
        setError('emailCheckResult', '유효한 이메일 형식이 아닙니다.');
        sendBtn.disabled = true;
        return;
    }

    fetch(`${contextPath}/member/checkEmail?email=${encodeURIComponent(email)}`)
    .then(res => res.json())
    .then(data => {
        if (data.result === 'available') {
            setError('emailCheckResult', '사용 가능한 이메일입니다. 인증이 필요합니다.', true);
            sendBtn.disabled = false;
            document.getElementById("email").readOnly = true;
            resetEmailBtn.style.display = "inline-block";
        } else {
            setError('emailCheckResult', '이미 등록된 이메일입니다.');
            sendBtn.disabled = true;
        }
    })
    .catch(() => setError('emailCheckResult', '서버 통신 실패'));
}

// DOMContentLoaded: 이벤트 바인딩
document.addEventListener('DOMContentLoaded', function () {
    const pw = document.getElementById('password');
    const pwCheck = document.getElementById('passwordCheck');
    const resetEmailBtn = document.getElementById("resetEmailBtn");

    const validatePw = () => {
        const pwRegex = /^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*]).{8,16}$/;
        if (!pw.value && !pwCheck.value) {
            setError('pwError', '');
            return;
        }
        if (!pwRegex.test(pw.value)) {
            setError('pwError', '비밀번호는 8~16자의 영문 소문자, 숫자, 특수문자를 포함해야 합니다.');
        } else if (pwCheck.value === '') {
            setError('pwError', '비밀번호 형식이 올바릅니다.', true);
        } else if (pw.value === pwCheck.value) {
            setError('pwError', '비밀번호가 일치합니다.', true);
        } else {
            setError('pwError', '비밀번호가 일치하지 않습니다.');
        }
    };

    pw.addEventListener('input', validatePw);
    pwCheck.addEventListener('input', validatePw);
	
    const emailInput = document.getElementById("email");
    const checkEmailBtn = document.querySelector("button[onclick='checkEmail()']");
    const sendBtn = document.getElementById("sendCodeBtn");
    const verifyBtn = document.getElementById("verifyBtn");

    emailInput.addEventListener("input", function () {
        if(checkEmailBtn) checkEmailBtn.disabled = false;
        if(sendBtn) sendBtn.disabled = true;
        if(verifyBtn) verifyBtn.disabled = true;
        setError("emailCheckResult", "");
        setError("emailResult", "");
    });

    if (resetEmailBtn) {
        resetEmailBtn.addEventListener("click", function () {
            const emailInput = document.getElementById("email");
            emailInput.readOnly = false;
            emailInput.value = "";
            if(checkEmailBtn) checkEmailBtn.disabled = false;
            if(sendBtn) sendBtn.disabled = true;
            if(verifyBtn) verifyBtn.disabled = true; 
            
            setError("emailCheckResult", "");
            setError("emailResult", "");
            resetEmailBtn.style.display = "none";
            if (timerInterval) clearInterval(timerInterval);
            document.getElementById("timerDisplay").innerText = "";
            
            const codeInput = document.getElementById("emailCode");
            if(codeInput) {
                codeInput.value = "";
                codeInput.disabled = false;
            }
        });
    }

	document.getElementById('signUpForm').addEventListener('submit', function (e) {
	    const userId = document.getElementById('user_id').value.trim();
	    const userPw = document.getElementById('password').value.trim();
	    const userPwConfirm = document.getElementById('passwordCheck').value.trim();
	    const realName = document.getElementById('real_name').value.trim();
	    const nickname = document.getElementById('nickname').value.trim();
	    const zipcode = document.getElementById('zipcode').value.trim();
	    const address = document.getElementById('address').value.trim();
	    const addressDetail = document.getElementById('addressDetail').value.trim();
	    const phone2 = document.getElementById('phone2').value.trim();
	    const phone3 = document.getElementById('phone3').value.trim();

	    if (!userId) { 
	        setError('idError', '아이디를 입력하세요.'); 
	        document.getElementById('user_id').focus();
	        e.preventDefault(); 
	        return; 
	    }

        // 아이디 중복확인 여부 체크를 아이디 입력 체크 바로 밑으로 옮기는 것이 흐름상 자연스럽습니다.
	    if (idCheckResult !== 'available') { 
	        alert('아이디 중복 확인이 필요합니다.'); 
	        document.getElementById('user_id').focus();
	        e.preventDefault(); 
	        return; 
	    }

	    if (!userPw) { 
	        setError('pwError', '비밀번호를 입력하세요.'); 
	        document.getElementById('password').focus();
	        e.preventDefault(); 
	        return; 
	    }

	    const pwRegex = /^(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*]).{8,16}$/;
	    if (!pwRegex.test(userPw)) { 
            // 제출 시에도 에러 메시지를 보여주면 더 명확합니다.
            setError('pwError', '비밀번호 형식을 확인하세요.');
	        document.getElementById('password').focus();
	        e.preventDefault(); 
	        return; 
	    }

	    if (userPw !== userPwConfirm) { 
            setError('pwError', '비밀번호가 일치하지 않습니다.');
	        document.getElementById('passwordCheck').focus();
	        e.preventDefault(); 
	        return; 
	    }

	    if (!realName) { 
	        alert('실명을 입력해주세요.'); 
	        document.getElementById('real_name').focus();
	        e.preventDefault(); 
	        return; 
	    }

		if (!nickname) { 
		    setError('nicknameCheckResult', '닉네임을 입력해주세요.'); 
		    document.getElementById('nickname').focus(); 
		    e.preventDefault(); 
		    return; 
		}

	    if (nicknameCheckResult !== 'available') { 
	        alert('닉네임 중복 확인이 필요합니다.'); 
	        document.getElementById('nickname').focus();
	        e.preventDefault(); 
	        return; 
	    }

	    if (!emailAuthStatus) { 
	        alert('이메일 인증을 완료해주세요.'); 
	        document.getElementById('email').focus();
	        e.preventDefault(); 
	        return; 
	    }

	    if (!zipcode || !address) { 
	        alert('주소 검색을 완료해주세요.'); 
            // zipcode 버튼이나 필드에 포커스
	        document.getElementById('zipcode').focus();
	        e.preventDefault(); 
	        return; 
	    }

	    if (!addressDetail) { 
	        alert('상세주소를 입력해주세요.'); 
	        document.getElementById('addressDetail').focus();
	        e.preventDefault(); 
	        return; 
	    }

	    if (!/^\d{3,4}$/.test(phone2) || !/^\d{4}$/.test(phone3)) { 
	        alert('전화번호 형식을 확인하세요.'); 
	        document.getElementById('phone2').focus();
	        e.preventDefault(); 
	        return; 
	    }
	});

});

// 이메일 인증번호 발송
function sendEmailCode() {
    const email = document.getElementById("email").value;
    const resetEmailBtn = document.getElementById("resetEmailBtn");
    const checkEmailBtn = document.querySelector("button[onclick='checkEmail()']");
    const sendBtn = document.getElementById("sendCodeBtn");
    const verifyBtn = document.getElementById("verifyBtn");
    
    if (timerInterval) clearInterval(timerInterval);

    let timeLeft = 180;
    const timerDisp = document.getElementById("timerDisplay");

    timerInterval = setInterval(() => {
        const min = Math.floor(timeLeft / 60);
        const sec = timeLeft % 60;
        timerDisp.innerText = `남은 시간: ${min}:${sec < 10 ? '0' + sec : sec}`;
        
        if (--timeLeft < 0) {
            clearInterval(timerInterval);
            timerDisp.innerText = "시간 만료. 다시 입력 버튼을 눌러주세요.";
            
            if(verifyBtn) verifyBtn.disabled = true;
            if(sendBtn) sendBtn.disabled = true;
            if(checkEmailBtn) checkEmailBtn.disabled = true;
            
            setError('emailResult', '인증 시간이 만료되었습니다.', false);
        }
    }, 1000);

    fetch("/fairplay/mail/sendCode", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: `email=${encodeURIComponent(email)}`
    }).then(() => {
        setError('emailResult', '인증번호가 발송되었습니다.', true);
        document.getElementById("email").readOnly = true;
        resetEmailBtn.style.display = "inline-block";
        if(verifyBtn) verifyBtn.disabled = false;
    });
}

// 인증번호 확인
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
            document.getElementById("resetEmailBtn").style.display = "none";
        } else {
            setError('emailResult', '인증번호가 일치하지 않습니다.');
        }
    });
}