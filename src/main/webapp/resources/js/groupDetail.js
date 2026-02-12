document.addEventListener('DOMContentLoaded', function () {
  // 아이콘 초기화
  if (window.lucide) {
    window.lucide.createIcons();
  }

  const body = document.body;

  // 1. 서버 메시지 처리
  const msg = body.dataset.msg;
  if (msg && msg !== 'null' && msg.trim() !== '') {
    toast(msg);
  }

  // 2. 초대코드 복사 (가독성 개선)
  const copyBtn = document.getElementById('copyCodeBtn');
  if (copyBtn) {
    copyBtn.addEventListener('click', function() {
      const inp = document.getElementById('codeInput');
      const originalType = inp.type;
      
      inp.type = 'text';
      inp.select();
      
      try {
        if (document.execCommand('copy')) {
          this.textContent = '복사됨';
          this.classList.replace('btn-primary', 'btn-success');
          toast('초대코드가 클립보드에 복사되었습니다.');
          
          setTimeout(() => {
            this.textContent = '복사';
            this.classList.replace('btn-success', 'btn-primary');
          }, 2000);
        }
      } catch (err) {
        toast('복사 실패');
      }
      inp.type = originalType;
    });
  }

  // 3. 삭제 버튼 처리
  const deleteBtns = document.querySelectorAll('[data-delete-id]');
  deleteBtns.forEach(btn => {
    btn.addEventListener('click', function() {
      if (confirm('그룹을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
        const id = this.dataset.deleteId;
        const cp = body.dataset.contextPath;
        location.href = cp + "/group/delete?id=" + id;
      }
    });
  });

  // 4. 라이트박스
  const lb = document.getElementById('imgLightbox');
  const lbImg = document.getElementById('lightboxImg');
  const lbClose = document.querySelector('.lightbox-close');

  document.addEventListener('click', (e) => {
    if (e.target.classList.contains('img-thumb')) {
      lbImg.src = e.target.dataset.full || e.target.src;
      lb.classList.add('open');
      document.body.style.overflow = 'hidden';
    }
  });

  const closeLb = () => { lb.classList.remove('open'); document.body.style.overflow = ''; };
  if (lb) {
    lb.addEventListener('click', (e) => { if (e.target === lb) closeLb(); });
    lbClose.addEventListener('click', closeLb);
    document.addEventListener('keydown', (e) => { if (e.key === 'Escape') closeLb(); });
  }

  // 5. 토스트 메시지
  function toast(msg) {
    let t = document.querySelector('.toast-custom');
    if (!t) {
      t = document.createElement('div');
      t.className = 'toast-custom shadow-lg';
      document.body.appendChild(t);
    }
    t.textContent = msg;
    setTimeout(() => { t.style.opacity = '1'; t.style.bottom = '50px'; }, 10);
    setTimeout(() => { t.style.opacity = '0'; t.style.bottom = '40px'; }, 2500);
  }
});