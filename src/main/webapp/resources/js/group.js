// 공용 스크립트 (ES5 호환) - 초대코드 전부 마스킹 + 안전 복사
document.addEventListener('DOMContentLoaded', function () {
  var cp = (document.body && document.body.dataset) ? document.body.dataset.contextPath : '';

  // 검색 필터 (목록)
  var searchInput = document.getElementById('groupSearch');
  if (searchInput) {
    var grid = document.getElementById('groupGrid');
    if (grid) {
      searchInput.addEventListener('input', function () {
        var q = (searchInput.value || '').toLowerCase();
        var cards = grid.querySelectorAll('[data-name]');
        for (var i = 0; i < cards.length; i++) {
          var name = (cards[i].getAttribute('data-name') || '').toLowerCase();
          cards[i].style.display = name.indexOf(q) >= 0 ? '' : 'none';
        }
      });
    }
  }

  // 초대코드 생성/복사 (create/update/detail 공통)
  function randomCode(len) {
    var s = ''; var base = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    for (var i = 0; i < len; i++) s += base.charAt(Math.floor(Math.random() * base.length));
    return s;
  }

  var genBtn = document.getElementById('genCodeBtn');
  if (genBtn) {
    genBtn.addEventListener('click', function(){
      var inp = document.getElementById('codeInput');
      if (!inp) return;
      inp.value = randomCode(8);
      // 항상 마스킹 유지
      if (inp.type !== 'password') inp.type = 'password';
      toast('초대코드를 생성했어요.');
    });
  }

  var copyBtn = document.getElementById('copyCodeBtn');
  if (copyBtn) {
    copyBtn.addEventListener('click', function(){
      var inp = document.getElementById('codeInput');
      if (!inp) return;

      // 비밀번호 필드는 일부 브라우저에서 복사 제한 → 잠시 text로 변경
      var prevType = inp.type;
      inp.type = 'text';
      inp.select();
      inp.setSelectionRange(0, 99999);
      var ok = false;
      try {
        ok = document.execCommand('copy');
      } catch (e) { ok = false; }
      // 즉시 되돌리기
      inp.type = prevType;

      toast(ok ? '초대코드를 복사했어요.' : '복사에 실패했어요. 직접 입력해주세요.');
    });
  }

  // 삭제 확인(data-delete-id 달린 버튼)
  var delBtns = document.querySelectorAll('[data-delete-id]');
  for (var i = 0; i < delBtns.length; i++) {
    delBtns[i].addEventListener('click', function(e){
      if (!confirm('그룹을 삭제할까요? 이 동작은 되돌릴 수 없습니다.')) e.preventDefault();
    });
  }

  // 미니 토스트
  function toast(msg) {
    var t = document.createElement('div');
    t.textContent = msg;
    t.setAttribute('style',
      'position:fixed;left:50%;bottom:24px;transform:translateX(-50%);background:#111827;color:#fff;' +
      'padding:10px 14px;border-radius:8px;font-size:13px;opacity:0;transition:opacity .2s;z-index:9999;'
    );
    document.body.appendChild(t);
    setTimeout(function(){ t.style.opacity = '0.95'; }, 10);
    setTimeout(function(){ t.style.opacity = '0'; }, 1600);
    setTimeout(function(){ document.body.removeChild(t); }, 2000);
  }
  // === 이미지 미리보기 공통 로직 ===
  (function(){
    var input = document.getElementById('groupImageInput');
    var preview = document.getElementById('groupImagePreview');
    var clearBtn = document.getElementById('clearImageBtn');

    if (!input || !preview) return;

	function show(file) {
	  if (!file) { hide(); return; }

	  var url = (window.URL || window.webkitURL).createObjectURL(file);

	  // 로드 완료되면 URL 해제해서 메모리 누수 방지
	  preview.onload = function () {
	    if ((window.URL || window.webkitURL).revokeObjectURL) {
	      (window.URL || window.webkitURL).revokeObjectURL(url);
	    }
	    preview.onload = null; // 핸들러 제거
	  };

	  preview.src = url;
	  preview.style.display = 'block';

	  // ✅ 클릭 확대 가능하도록
	  preview.classList.add('img-thumb');
	  preview.setAttribute('data-full', url);

	  if (clearBtn) clearBtn.style.display = 'inline-block';
	}

	function hide() {
	  preview.removeAttribute('src');
	  preview.removeAttribute('data-full');
	  preview.style.display = 'none';
	  if (clearBtn) clearBtn.style.display = 'none';
	}

	// 초기 보정(수정 폼에서 기존 이미지 있을 때)
	if (preview && preview.getAttribute('src') && !preview.getAttribute('data-full')) {
	  preview.classList.add('img-thumb');
	  preview.setAttribute('data-full', preview.getAttribute('src'));
	}


    input.addEventListener('change', function(){
      if (input.files && input.files[0]) show(input.files[0]);
      else hide();
    });

    if (clearBtn) {
      clearBtn.addEventListener('click', function(){
        input.value = '';
        // 기존 이미지 유지: edit 화면에서는 preview가 이미 src가 있을 수 있음 → 숨기지 않고 놔둘 수도 있음
        // 여기서는 선택만 해제(새 선택 취소)하는 UX로 처리
        if (preview && input.files && input.files.length === 0 && !preview.getAttribute('src')) hide();
        // 선택 해제 토스트
        var t = document.createElement('div');
        t.textContent = '선택을 해제했어요.';
        t.setAttribute('style','position:fixed;left:50%;bottom:24px;transform:translateX(-50%);background:#111827;color:#fff;padding:10px 14px;border-radius:8px;font-size:13px;opacity:0;transition:opacity .2s;z-index:9999;');
        document.body.appendChild(t);
        setTimeout(function(){ t.style.opacity = '0.95'; }, 10);
        setTimeout(function(){ t.style.opacity = '0'; }, 1600);
        setTimeout(function(){ document.body.removeChild(t); }, 2000);
      });
    }
  })();

  // === Lightbox(이미지 클릭 확대) ===
  (function(){
    var lb = document.getElementById('imgLightbox');     // 라이트박스 컨테이너
    var lbImg = document.getElementById('lightboxImg');  // 라이트박스 이미지
    var closeBtn = document.querySelector('.lightbox-close');
    if (!lb || !lbImg) return;

    // 열기
    function open(src){
      lbImg.src = src;
      lb.classList.add('open');
      document.body.style.overflow = 'hidden'; // 스크롤 잠금
    }
    // 닫기
    function close(){
      lb.classList.remove('open');
      lbImg.removeAttribute('src');
      document.body.style.overflow = '';
    }

    // 썸네일 클릭 → 오픈
    document.addEventListener('click', function(e){
      var t = e.target;
      if (t && t.classList && t.classList.contains('img-thumb')){
        e.preventDefault();
        var src = t.getAttribute('data-full') || t.src;
        open(src);
      }
    });

    // 배경 클릭/닫기 버튼/ESC → 닫기
    lb.addEventListener('click', function(e){ if (e.target === lb) close(); });
    if (closeBtn) closeBtn.addEventListener('click', close);
    document.addEventListener('keydown', function(e){ if (e.key === 'Escape') close(); });
  })();

});
