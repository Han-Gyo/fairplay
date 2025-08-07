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
	
	// 프사 미리보기 기능	
    const fileInput = document.getElementById('profileImageFile');
    const previewImg = document.getElementById('profilePreview');

    if (fileInput && previewImg) {
        fileInput.addEventListener('change', function (e) {
            const file = e.target.files[0];
			console.log("선택된 파일:", file); // 로그 찍어보기
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

	        // 서버로 기본 이미지로 초기화 요청 의사 전달
	        resetInput.value = 'true';

	        // 선택된 파일 초기화
	        if (fileInput) {
	            fileInput.value = ''; // 파일 input 리셋
	        }
	    });
	}
	
	// 🔍 프사 클릭 시 확대 모달 띄우기
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
	        modalImage.src = ''; // 모달 닫을 때 이미지도 초기화
	    });
	}

});



// 📍 주소 검색 API 실행 함수
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

// 📍 상세주소 입력 시 전체 주소 갱신
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



