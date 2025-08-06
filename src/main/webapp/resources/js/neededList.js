document.addEventListener('DOMContentLoaded', function () {
    const checkboxes = document.querySelectorAll('.purchase-check');

    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function () {
            const id = this.dataset.id;
            const isPurchased = this.checked;

            fetch(`/fairplay/needed/toggle`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: `id=${id}&isPurchased=${isPurchased}`
            })
            .then(res => res.text())
            .then(msg => {
                if (msg === 'success') {
                    location.reload();  // 새로고침으로 반영
                } else {
                    alert('구매 상태 변경 실패');
                }
            });
        });
    });
});
