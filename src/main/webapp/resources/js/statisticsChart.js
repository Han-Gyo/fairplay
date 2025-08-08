document.addEventListener('DOMContentLoaded', () => {
    const ctxPath = document.body.dataset.contextPath || '';
    const groupId = document.getElementById('groupId')?.value;
    const yearMonth = document.getElementById('yearMonth')?.value;
    const hook = document.getElementById('chartHooks');

    const memberUrl = hook?.dataset.memberUrl || `${ctxPath}/statistics/monthly-score`;

    // 차트 렌더 함수
    const render = (labels, data) => {
        const ctx = document.getElementById('memberChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: '멤버별 점수',
                    data: data,
                    backgroundColor: 'rgba(90, 200, 250, 0.5)',
                    borderColor: 'rgba(90, 200, 250, 1)',
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
            const url = `${memberUrl}?groupId=${encodeURIComponent(groupId)}&yearMonth=${encodeURIComponent(yearMonth)}`;
            const json = await fetchJson(url);

            let labels, data;

            if (Array.isArray(json)) {
                // List<MemberMonthlyScore> 처리
                labels = json.map(m => m.nickname);
                data = json.map(m => m.score);
            } else {
                const members = Array.isArray(json.members) ? json.members : [];
                labels = json.labels || json.nicknames || members.map(m => m.nickname);
                data = json.data || members.map(m => m.score);
            }

            render(labels, data);
        } catch (e) {
            console.error('[MemberChart] load failed:', e);
            render([], []);
        }
    };

    load();
});
