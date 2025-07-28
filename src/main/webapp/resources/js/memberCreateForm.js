// 중복 확인 결과 전역 변수
let idCheckResult = null;
let nicknameCheckResult = null;

// 아이디 중복 확인
function checkId() {
    const userId = document.getElementById('user_id').value;
    const contextPath = document.getElementById('contextPath').value;

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

        idCheckResult = data.result; // ✅ 전역 변수 저장

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
    const nickname = document.getElementById('nickname').value;
    const contextPath = document.getElementById('contextPath').value;

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

        nicknameCheckResult = data.result; // ✅ 전역 변수 저장

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
        pwError.classList.remove('error', 'success');

        // 비밀번호 불일치 시
        if (pw !== pwCheck) {
            e.preventDefault();
            pwError.classList.add('error');
            pwError.innerText = '비밀번호가 일치하지 않습니다.';
        }

        // ✅ 아이디 중복 미확인 or 중복이면 차단
        if (idCheckResult !== 'available') {
            e.preventDefault();
            const idErrorDiv = document.getElementById('idError');
            idErrorDiv.classList.add('error');
            idErrorDiv.innerText = '아이디 중복 확인이 필요하거나, 중복된 아이디입니다.';
        }

        // ✅ 닉네임 중복 미확인 or 중복이면 차단
        if (nicknameCheckResult !== 'available') {
            e.preventDefault();
            const nickDiv = document.getElementById('nicknameCheckResult');
            nickDiv.classList.add('error');
            nickDiv.innerText = '닉네임 중복 확인이 필요하거나, 중복된 닉네임입니다.';
        }
    });
});
