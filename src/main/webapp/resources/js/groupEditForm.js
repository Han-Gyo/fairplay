document.addEventListener('DOMContentLoaded', function () {
    const editForm = document.getElementById('groupEditForm');
    const codeInput = document.getElementById('codeInput');
    const codeError = document.getElementById('codeError');
    const imageDeletedInput = document.getElementById('imageDeleted');
    const imgInput = document.getElementById('groupImageInput');
    const imgPreview = document.getElementById('groupImagePreview');
    const clearBtn = document.getElementById('clearImageBtn');

    imgInput?.addEventListener('change', function () {
        const file = this.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = e => {
                imgPreview.src = e.target.result;
                imgPreview.style.display = 'block';
                document.getElementById('placeholderContent').style.display = 'none';
                clearBtn.style.display = 'flex';
                imageDeletedInput.value = "false";
            };
            reader.readAsDataURL(file);
        }
    });

    clearBtn?.addEventListener('click', (e) => {
        e.preventDefault();
        imgInput.value = "";
        imgPreview.src = "";
        imgPreview.style.display = 'none';
        document.getElementById('placeholderContent').style.display = 'flex';
        clearBtn.style.display = 'none';
        imageDeletedInput.value = "true";
    });

    document.getElementById('genCodeBtn')?.addEventListener('click', () => {
        const code = Math.random().toString(36).substring(2, 10).toUpperCase();
        codeInput.value = code;
        codeError.style.display = 'none';
        toast("코드가 재생성되었습니다.");
    });

    // 폼 전송 시 8자리 유효성 검사
    editForm?.addEventListener('submit', function (e) {
        if (codeInput.value.trim().length !== 8) {
            e.preventDefault();
            codeError.style.display = 'block';
            codeInput.focus();
            toast("초대코드는 반드시 8자리여야 합니다.");
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