document.addEventListener('DOMContentLoaded', function () {
  const form = document.getElementById('groupForm');
  const codeInput = document.getElementById('codeInput');

  // === 초대코드 생성 ===
  const genBtn = document.getElementById('genCodeBtn');
  if (genBtn) {
    genBtn.addEventListener('click', function () {
      const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
      let code = "";
      for (let i = 0; i < 8; i++) {
        code += chars.charAt(Math.floor(Math.random() * chars.length));
      }
      codeInput.value = code;
      codeInput.type = "password"; // 항상 마스킹 유지
      toast("새 초대코드가 생성되었습니다!");
    });
  }

  // === 초대코드 복사 ===
  const copyBtn = document.getElementById('copyCodeBtn');
  if (copyBtn) {
    copyBtn.addEventListener('click', function () {
      const prevType = codeInput.type;
      codeInput.type = 'text'; // 잠깐 보이게
      codeInput.select();
      try {
        const ok = document.execCommand('copy');
        if (ok) {
          this.textContent = '복사됨!';
          this.classList.remove('btn-outline-secondary');
          this.classList.add('btn-success');
          toast('초대코드가 클립보드에 복사되었습니다.');
          setTimeout(() => {
            this.textContent = '복사';
            this.classList.remove('btn-success');
            this.classList.add('btn-outline-secondary');
          }, 2000);
        }
      } catch (err) {
        toast('복사 실패!');
      }
      codeInput.type = prevType; // 다시 password로 복원
    });
  }

  // === 대표 이미지 미리보기 ===
  const imgInput = document.getElementById('groupImageInput');
  const imgPreview = document.getElementById('groupImagePreview');
  const clearBtn = document.getElementById('clearImageBtn');
  if (imgInput && imgPreview && clearBtn) {
    imgInput.addEventListener('change', function () {
      const file = this.files[0];
      if (file) {
        const reader = new FileReader();
        reader.onload = e => {
          imgPreview.src = e.target.result;
          imgPreview.style.display = 'block';
          clearBtn.style.display = 'inline-block';
        };
        reader.readAsDataURL(file);
      } else {
        imgPreview.src = "";
        imgPreview.style.display = "none";
        clearBtn.style.display = "none";
      }
    });
    clearBtn.addEventListener('click', function () {
      imgInput.value = "";
      imgPreview.src = "";
      imgPreview.style.display = "none";
      this.style.display = "none";
    });
  }

  // === 폼 제출 시 초대코드 검증 ===
  form.addEventListener('submit', function (e) {
    const codeVal = codeInput.value.trim();
    if (codeVal.length !== 8) {
      e.preventDefault();
      toast("초대코드는 반드시 8자리여야 합니다!");
      codeInput.focus();
    }
  });

  // === 토스트 메시지 ===
  function toast(msg) {
    let t = document.querySelector('.toast-custom');
    if (!t) {
      t = document.createElement('div');
      t.className = 'toast-custom';
      document.body.appendChild(t);
    }
    t.textContent = msg;
    t.style.opacity = '1';
    setTimeout(() => {
      t.style.opacity = '0';
    }, 2000);
  }
});