document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.getElementById('groupSearch');
    const groupItems = document.querySelectorAll('.group-item');
    const noResults = document.getElementById('noResults');
    const myGroupsOnly = document.getElementById('myGroupsOnly');

    // 그룹 이름 실시간 필터링 기능
    function applyFilters() {
        const searchTerm = searchInput ? searchInput.value.toLowerCase().trim() : "";
        let visibleCount = 0;

        groupItems.forEach(item => {
            const groupName = item.getAttribute('data-name').toLowerCase();
            const isMyGroup = item.dataset.mygroup === "true";

            // 검색 + 내 그룹만 보기 조건 동시 적용
            const matchesSearch = groupName.includes(searchTerm);
            const matchesMyGroup = !myGroupsOnly.checked || isMyGroup;

            if (matchesSearch && matchesMyGroup) {
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
    }

    if (searchInput) {
        searchInput.addEventListener('input', applyFilters);
    }
    if (myGroupsOnly) {
        myGroupsOnly.addEventListener('change', applyFilters);
    }
});