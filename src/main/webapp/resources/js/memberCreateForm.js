
// memberCreateForm.js
function checkId() {
    const userId = document.getElementById('user_id').value;
    const contextPath = document.getElementById('contextPath').value;

    fetch(contextPath + '/member/checkId?user_id=' + encodeURIComponent(userId))
        .then(res => {
            if (!res.ok) {
                throw new Error("서버 오류 발생: " + res.status);
            }
            return res.json(); // JSON으로 받기
        })
        .then(data => {
            const idErrorDiv = document.getElementById('idError');
            idErrorDiv.classList.remove('error', 'success'); // 기존 스타일 제거

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
            idErrorDiv.classList.remove('error', 'success');
            idErrorDiv.classList.add('error');
            idErrorDiv.innerText = '서버 통신 실패';
        });
}





function sendCode() {
    const email = document.getElementById('email').value;
    fetch('/signUp/sendCode?email=' + email);
    document.getElementById('emailMsg').innerText = '인증번호가 발송되었습니다';
}

function verifyCode() {
    const code = document.getElementById('emailCode').value;
    fetch('/signUp/verifyCode?code=' + code)
        .then(res => res.text())
        .then(result => {
            document.getElementById('emailMsg').innerText = result;
        });
}

document.addEventListener('DOMContentLoaded', function () {
    document.getElementById('signUpForm').addEventListener('submit', function (e) {
        const pw = document.getElementById('password').value;
        const pwCheck = document.getElementById('passwordCheck').value;
        if (pw !== pwCheck) {
            e.preventDefault();
            document.getElementById('pwError').innerText = '비밀번호가 일치하지 않습니다';
        }
    });
});
