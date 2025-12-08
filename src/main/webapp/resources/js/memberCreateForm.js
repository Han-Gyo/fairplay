// 중복 확인 결과 전역 변수
let idCheckResult = null;
let nicknameCheckResult = null;
let timerInterval; // 전역으로 타이머 ID 관리


// 아이디 중복 확인
function checkId() {
    const userId = document.getElementById('user_id').value.trim();
	// 아이디 입력값 확인
	console.log("💬 아이디 입력값: [" + userId + "]");
    const contextPath = document.getElementById('contextPath').value;
	const idErrorDiv = document.getElementById('idError');

	// 공백 검사 로직
    if (userId === '') {
        idErrorDiv.classList.add('error');
        idErrorDiv.innerText = '아이디를 입력해주세요.';
        idCheckResult = null; // 전역 변수 초기화
        return;
    }
	
	// fetch 요청
    fetch(contextPath + '/member/checkId?user_id=' + encodeURIComponent(userId), {
        method: 'GET',
        headers: {
            'Accept': 'application/json'
        }
    })
    .then(res => res.json())
    .then(data => {
        const idErrorDiv = document.getElementById('idError');
        idErrorDiv.classList.remove('error', 'success');

        idCheckResult = data.result; // 전역 변수 저장

        if (data.result === 'duplicate') {
            idErrorDiv.classList.add('error');
            idErrorDiv.innerText = '이미 사용 중인 아이디입니다.';
        } else if (data.result === 'available') {
            idErrorDiv.classList.add('success');
            idErrorDiv.innerText = '사용 가능한 아이디입니다.';
        } else {
            idErrorDiv.classList.add('error');
            idErrorDiv.innerText = '응답 처리 오류';
        }
    })
    .catch(error => {
        console.error("fetch 오류:", error);
        const idErrorDiv = document.getElementById('idError');
        idErrorDiv.classList.add('error');
        idErrorDiv.innerText = '서버 통신 실패';
    });
}

// 닉네임 중복 확인
function checkNickname() {
    const nickname = document.getElementById('nickname').value.trim();
    const contextPath = document.getElementById('contextPath').value;
	const nickDiv = document.getElementById('nicknameCheckResult');
	
	if (nickname === '') {
        nickDiv.classList.add('error');
        nickDiv.innerText = '닉네임을 입력해주세요.';
        nicknameCheckResult = null;
        return;
    }

    fetch(contextPath + '/member/checkNickname?nickname=' + encodeURIComponent(nickname), {
        method: 'GET',
        headers: {
            'Accept': 'application/json'
        }
    })
    .then(res => res.json())
    .then(data => {
        const nickDiv = document.getElementById('nicknameCheckResult');
        nickDiv.classList.remove('error', 'success');

        nicknameCheckResult = data.result; // 전역 변수 저장

        if (data.result === 'duplicate') {
            nickDiv.classList.add('error');
            nickDiv.innerText = '이미 사용 중인 닉네임입니다.';
        } else if (data.result === 'available') {
            nickDiv.classList.add('success');
            nickDiv.innerText = '사용 가능한 닉네임입니다.';
        } else {
            nickDiv.classList.add('error');
            nickDiv.innerText = '응답 처리 오류';
        }
    })
    .catch(error => {
        console.error("닉네임 fetch 오류:", error);
        const nickDiv = document.getElementById('nicknameCheckResult');
        nickDiv.classList.add('error');
        nickDiv.innerText = '서버 통신 실패';
    });
}

// 전체 submit 유효성 검사
document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('signUpForm').addEventListener('submit', function (e) {
        const pw = document.getElementById('password').value;
        const pwCheck = document.getElementById('passwordCheck').value;
        const pwError = document.getElementById('pwError');
		const emailResult = document.getElementById("emailResult").innerText;
		const nickname = document.getElementById('nickname').value.trim();
		const zipcode = document.getElementById('zipcode').value.trim();
		const address = document.getElementById('address').value.trim();

		
        pwError.classList.remove('error', 'success');

		// 닉네임 공백 체크
	    if (nickname === '') {
	        e.preventDefault();
	        const nickDiv = document.getElementById('nicknameCheckResult');
	        nickDiv.classList.add('error');
	        nickDiv.innerText = '닉네임은 필수 입력입니다.';
	        return;
	    }
			
        // 비밀번호 불일치 시
        if (pw !== pwCheck) {
            e.preventDefault();
            pwError.classList.add('error');
            pwError.innerText = '비밀번호가 일치하지 않습니다.';
        }

        // 아이디 중복 미확인 or 중복이면 차단
        if (idCheckResult !== 'available') {
            e.preventDefault();
            const idErrorDiv = document.getElementById('idError');
            idErrorDiv.classList.add('error');
            idErrorDiv.innerText = '아이디 중복 확인이 필요하거나, 중복된 아이디입니다.';
        }

        // 닉네임 중복 미확인 or 중복이면 차단
        if (nicknameCheckResult !== 'available') {
            e.preventDefault();
            const nickDiv = document.getElementById('nicknameCheckResult');
            nickDiv.classList.add('error');
            nickDiv.innerText = '닉네임 중복 확인이 필요하거나, 중복된 닉네임입니다.';
        }
		
		// 이메일 인증 여부 확인
		if (!emailResult.includes("성공")) {
            e.preventDefault();
            const emailDiv = document.getElementById("emailResult");
            emailDiv.classList.add('error');
            emailDiv.innerText = "이메일 인증을 완료해주세요.";
        }
		
		// 우편번호와 기본 주소 검사
        if (zipcode === '' || address === '') {
            e.preventDefault();
            alert('주소 검색을 통해 우편번호와 기본 주소를 입력해주세요.');
        }

    });
});

// 시간 포맷 함수 (전역에서 사용 가능하도록 정의)
function formatTime(seconds) {
    const min = Math.floor(seconds / 60);
    const sec = seconds % 60;
    return `${min}:${sec < 10 ? '0' + sec : sec}`;
}


// 이메일 인증번호 전송 및 재전송
function sendEmailCode() {
    const email = document.getElementById("email").value.trim(); // 입력창에서 이메일 값 가져오기 (앞뒤 공백 제거)
    const emailResult = document.getElementById("emailResult");	// 결과 메시지를 표기할 영역 가져오기
    const timerDisplay = document.getElementById("timerDisplay");
    const emailCodeInput = document.getElementById("emailCode");
    const verifyBtn = document.getElementById("verifyBtn");
	
	// 이메일 입력값이 공백일 경우 처리
    if (email === "") {
        emailResult.classList.add("error");
        emailResult.innerText = "이메일을 입력해주세요.";
        return;
    }

    // 이메일 형식 체크 추가
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(email)) {
        emailResult.classList.add("error");
        emailResult.innerText = "올바른 이메일 형식을 입력해주세요.";
        return;
    }

    // 기존 타이머가 있다면 초기화
    if (timerInterval) {
        clearInterval(timerInterval);
    }

    // 인증 입력창과 확인 버튼 다시 활성화
    emailCodeInput.disabled = false;
    verifyBtn.disabled = false;

    let timeLeft = 180; // 3분

    // 타이머 시작
    timerDisplay.innerText = `남은 시간: ${formatTime(timeLeft)}`;
    timerInterval = setInterval(() => {
        timeLeft--;
        if (timeLeft <= 0) {
            clearInterval(timerInterval);

            // 타이머 만료 시
            timerDisplay.innerText = "인증 시간이 만료되었습니다. 다시 전송 버튼을 눌러주세요.";
            emailCodeInput.disabled = true;
            verifyBtn.disabled = true;
        } else {
            timerDisplay.innerText = `남은 시간: ${formatTime(timeLeft)}`;
        }
    }, 1000);

    // 실제 메일 전송 요청
    fetch("/fairplay/mail/sendCode", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "email=" + encodeURIComponent(email)
    })
    .then(response => response.text())
    .then(msg => {
        emailResult.innerText = msg;
    })
    .catch(error => {
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
        headers: {
            "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
        },
        body: "code=" + encodeURIComponent(code)
    })
    .then(response => response.text())
    .then(msg => {
        const emailResult = document.getElementById("emailResult");
        emailResult.innerText = msg;

        // 인증 성공 시 타이머 멈추고 숨기기
        if (msg.includes("성공")) {
            clearInterval(timerInterval); 	// 타이머 멈춤
            timerDisplay.innerText = "";  	// 화면에서 타이머 제거
            emailCodeInput.disabled = true; // 입력창 비활성화
            verifyBtn.disabled = true;      // 버튼 비활성화
        }
    })
    .catch(error => {
        document.getElementById("emailResult").innerText = "인증 실패";
        console.error("인증 실패:", error);
    });
}

//