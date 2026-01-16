document.addEventListener('DOMContentLoaded', function () {
  const body = document.body;
  
  // 1. Lucide 아이콘 초기화 (JSP 하단에도 넣었지만 안전을 위해)
  if (window.lucide) {
    window.lucide.createIcons();
  }

  // 2. 서버 메시지 처리 (토스트)
  const serverMsg = body.dataset.msg;
  if (serverMsg && serverMsg.trim() !== '' && serverMsg !== 'null') {
    toast(serverMsg);
  }

  // 3. 초대코드 복사 기능 (개선)
  const copyBtn = document.getElementById('copyCodeBtn');
  if (copyBtn) {
    copyBtn.addEventListener('click', function(){
      const inp = document.getElementById('codeInput');
      if (!inp) return;

      const prevType = inp.type;
      inp.type = 'text';
      inp.select();
      
      try {
        const ok = document.execCommand('copy');
        if (ok) {
          this.textContent = '복사됨!';
          this.classList.replace('btn-dark', 'btn-success');
          toast('초대코드가 클립보드에 복사되었습니다.');
          
          setTimeout(() => {
            this.textContent = '복사';
            this.classList.replace('btn-success', 'btn-dark');
          }, 2000);
        }
      } catch (err) {
        toast('복사 실패!');
      }
      inp.type = prevType;
    });
  }

  // 4. 삭제 컨펌 로직 (기존 유지)
  const delBtns = document.querySelectorAll('[data-delete-id]');
  delBtns.forEach(btn => {
    btn.addEventListener('click', function(e){
      if (!confirm('정말 삭제하시겠습니까? 관련 데이터가 모두 삭제되며 복구할 수 없습니다.')) {
        e.preventDefault();
      } else {
        const id = this.dataset.deleteId;
        const cp = body.dataset.contextPath;
        location.href = cp + "/group/delete?id=" + id;
      }
    });
  });

  // 5. 토스트 함수 (기존 유지 및 스타일 보강)
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

  // 6. Lightbox (기존 유지)
  (function(){
    const lb = document.getElementById('imgLightbox');
    const lbImg = document.getElementById('lightboxImg');
    const closeBtn = document.querySelector('.lightbox-close');
    if (!lb || !lbImg) return;

    document.addEventListener('click', (e) => {
      if (e.target.classList.contains('img-thumb')){
        lbImg.src = e.target.dataset.full || e.target.src;
        lb.classList.add('open');
        document.body.style.overflow = 'hidden';
      }
    });

    const close = () => { lb.classList.remove('open'); document.body.style.overflow = ''; };
    lb.addEventListener('click', (e) => { if (e.target === lb) close(); });
    if (closeBtn) closeBtn.addEventListener('click', close);
    document.addEventListener('keydown', (e) => { if (e.key === 'Escape') close(); });
  })();
});