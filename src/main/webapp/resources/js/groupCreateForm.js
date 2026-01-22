document.addEventListener('DOMContentLoaded', function () {
    const groupForm = document.getElementById('groupForm');
    const codeInput = document.getElementById('codeInput');
    const codeError = document.getElementById('codeError');
    const imgInput = document.getElementById('groupImageInput');
    const imgPreview = document.getElementById('groupImagePreview');
    const placeholderContent = document.getElementById('placeholderContent');
    const clearBtn = document.getElementById('clearImageBtn');

    // 이미지 업로드 로직
    imgInput?.addEventListener('change', function () {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = e => {
                imgPreview.src = e.target.result;
                imgPreview.style.display = 'block';
                if (placeholderContent) placeholderContent.style.display = 'none';
                if (clearBtn) clearBtn.style.display = 'flex';
            };
            reader.readAsDataURL(file);
        }
    });

    clearBtn?.addEventListener('click', (e) => {
        e.preventDefault();
        imgInput.value = "";
        imgPreview.src = "";
        imgPreview.style.display = 'none';
        if (placeholderContent) placeholderContent.style.display = 'flex';
        clearBtn.style.display = 'none';
    });

    // 초대코드 생성
    document.getElementById('genCodeBtn')?.addEventListener('click', () => {
        const code = Math.random().toString(36).substring(2, 10).toUpperCase();
        codeInput.value = code;
        codeError.style.display = 'none';
        toast("새 코드가 생성되었습니다.");
    });

    // 초대코드 복사
    document.getElementById('copyCodeBtn')?.addEventListener('click', function() {
        if (!codeInput.value || codeInput.value.length !== 8) {
            toast("8자리 코드를 먼저 입력해주세요.");
            return;
        }
        navigator.clipboard.writeText(codeInput.value).then(() => {
            toast("코드가 복사되었습니다.");
        });
    });

    // 폼 전송 시 유효성 검사 (핵심 추가)
    groupForm?.addEventListener('submit', function (e) {
        const codeValue = codeInput.value.trim();
        if (codeValue.length !== 8) {
            e.preventDefault(); // 전송 중단
            codeError.style.display = 'block';
            codeInput.focus();
            toast("초대코드 8자리를 입력해야 합니다.");
        } else {
            codeError.style.display = 'none';
        }
    });

    function toast(msg) {
        let t = document.querySelector('.toast-custom') || document.createElement('div');
        t.className = 'toast-custom shadow-lg';
        document.body.appendChild(t);
        t.textContent = msg;
        t.style.opacity = '1';
        t.style.bottom = '40px';
        setTimeout(() => { t.style.opacity = '0'; t.style.bottom = '-60px'; }, 2500);
    }
});