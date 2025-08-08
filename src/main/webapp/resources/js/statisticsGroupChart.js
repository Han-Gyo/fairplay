// statisticsGroupChart.js
// 역할: 그룹 월간 점수(일자별 합계 등) 차트를 렌더링
// 백엔드에서 JSON 응답만 맞춰주면 그대로 동작함.
// 예상 JSON 형식 예시:
// { "labels": ["01","02","03",...], "data": [10, 20, 0, ...] }

document.addEventListener('DOMContentLoaded', () => {
  const ctxPath = document.body.dataset.contextPath || '';
  const groupId = document.getElementById('groupId')?.value;
  const yearMonth = document.getElementById('yearMonth')?.value;
  const hook = document.getElementById('chartHooks');
  const groupUrl = hook?.dataset.groupUrl || `${ctxPath}/history/monthly-score/group-data`;

  const canvas = document.getElementById('groupChart');
  if (!canvas || !groupId || !yearMonth) return;

  let groupChart;

  const render = (labels, data) => {
    if (groupChart) groupChart.destroy();
    const ctx = canvas.getContext('2d');

    groupChart = new Chart(ctx, {
      type: 'line',
      data: {
        labels,
        datasets: [{
          label: '그룹 월간 점수',
          data,
          tension: 0.25,
          borderWidth: 2,
          pointRadius: 3,
          // 색은 Chart.js 기본 팔레트 사용(너가 원하면 CSS 변수 연동 가능)
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: true },
          tooltip: { mode: 'index', intersect: false }
        },
        scales: {
          y: { beginAtZero: true, title: { display: true, text: '점수' } },
          x: { title: { display: true, text: '일자' } }
        }
      }
    });
  };

  // ✅ 데이터 가져오기
  const load = async () => {
    try {
      const url = `${groupUrl}?group_id=${encodeURIComponent(groupId)}&yearMonth=${encodeURIComponent(yearMonth)}`;
      const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
      if (!res.ok) throw new Error('group data http error');
      const json = await res.json();

      // 방어코드: 키 이름이 다를 수 있어 유연 처리
      const labels = json.labels || json.days || [];
      const data = json.data || json.values || [];
      render(labels, data);
    } catch (e) {
      console.error('[GroupChart] load failed:', e);
      // 최소 폴백: 비어있는 차트
      render([], []);
    }
  };

  load();
});
