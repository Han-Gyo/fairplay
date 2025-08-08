document.addEventListener("DOMContentLoaded", function () {
  const contextPath = document.body.dataset.contextPath;

  document.querySelectorAll(".purchase-check").forEach((checkbox) => {
    checkbox.addEventListener("change", function () {
      const itemId = this.dataset.id;
      const isChecked = this.checked;

      fetch(`${contextPath}/needed/togglePurchased`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ id: itemId, purchased: isChecked }),
      })
        .then((res) => {
          if (!res.ok) throw new Error("서버 오류");
          return res.json();
        })
        .then((data) => {
          const card = this.closest(".needed-card");
          if (data.success) {
            card.classList.toggle("purchased", isChecked);
          } else {
            alert("처리 실패! " + (data.error || ""));
            this.checked = !isChecked;
          }
        })
        .catch((err) => {
          alert("에러 발생: " + err.message);
          this.checked = !isChecked;
        });
    });
  });


  // 삭제 확인 감성 모달 대체
  document.querySelectorAll("form[action$='delete']").forEach((form) => {
    form.addEventListener("submit", function (e) {
      const confirmed = confirm("정말 삭제하시겠습니까?");
      if (!confirmed) e.preventDefault();
    });
  });

  // 수정 버튼 클릭 애니메이션
  document.querySelectorAll(".btn-small").forEach((btn) => {
    btn.addEventListener("click", function () {
      btn.classList.add("clicked");
      setTimeout(() => btn.classList.remove("clicked"), 300);
    });
  });
});