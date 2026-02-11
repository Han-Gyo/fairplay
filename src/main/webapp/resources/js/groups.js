document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('groupSearch');
    const groupItems = document.querySelectorAll('.group-item');
    const noResults = document.getElementById('noResults');

    //그룹 이름 실시간 필터링 기능
    if (searchInput) {
        searchInput.addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase().trim();
            let visibleCount = 0;

            groupItems.forEach(item => {
                const groupName = item.getAttribute('data-name').toLowerCase();
                
                if (groupName.includes(searchTerm)) {
                    item.classList.remove('d-none');
                    visibleCount++;
                } else {
                    item.classList.add('d-none');
                }
            });

            // 검색 결과가 없을 때 메시지 처리
            if (visibleCount === 0) {
                noResults.classList.remove('d-none');
            } else {
                noResults.classList.add('d-none');
            }
        });
    }
});