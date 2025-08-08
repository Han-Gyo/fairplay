document.addEventListener('DOMContentLoaded', () => {
    const ctxPath = document.body.dataset.contextPath || '';
    const groupId = document.getElementById('groupId')?.value;
    const yearMonth = document.getElementById('yearMonth')?.value;
    const hook = document.getElementById('chartHooks');

    const groupUrl = hook?.dataset.groupUrl || `${ctxPath}/statistics/group-monthly-total`;

    // 차트 렌더 함수
    const render = (labels, data) => {
        const ctx = document.getElementById('groupChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: '그룹 점수',
                    data: data,
                    backgroundColor: 'rgba(255, 159, 64, 0.5)',
                    borderColor: 'rgba(255, 159, 64, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        title: { display: true, text: '점수' }
                    }
                }
            }
        });
    };

    // JSON 요청 함수
    const fetchJson = async (url) => {
        const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        return await res.json();
    };

    // 데이터 로드
    const load = async () => {
        try {
            const url = `${groupUrl}?groupId=${encodeURIComponent(groupId)}&yearMonth=${encodeURIComponent(yearMonth)}`;
            const json = await fetchJson(url);

            let labels = [], data = [];

            if (json && Array.isArray(json.labels)) {
                labels = json.labels;
                data = json.data || [];
            } else if (Array.isArray(json)) {
                labels = json.map(d => d.day || '');
                data = json.map(d => d.total || 0);
            } else if (json && typeof json.totalScore !== 'undefined') {
                // 단일 총점 API 대응
                labels = [yearMonth];
                data = [json.totalScore];
            }

            render(labels, data);
        } catch (e) {
            console.error('[GroupChart] load failed:', e);
            render([], []);
        }
    };

    load();
});
