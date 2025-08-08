// statisticsChart.js
// 역할: 멤버별 점수 바 차트 렌더링
// 예상 JSON 형식 예시:
// { "labels": ["닉네임1","닉네임2",...], "data": [34, 12, ...] }

document.addEventListener('DOMContentLoaded', () => {
  const ctxPath = document.body.dataset.contextPath || '';
  const groupId = document.getElementById('groupId')?.value;
  const yearMonth = document.getElementById('yearMonth')?.value;
  const hook = document.getElementById('chartHooks');
  const memberUrl = hook?.dataset.memberUrl || `${ctxPath}/history/monthly-score/member-data`;

  const canvas = document.getElementById('memberChart');
  if (!canvas || !groupId || !yearMonth) return;

  let memberChart;

  const render = (labels, data) => {
    if (memberChart) memberChart.destroy();
    const ctx = canvas.getContext('2d');

    memberChart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels,
        datasets: [{
          label: '멤버별 점수',
          data,
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: true },
          tooltip: { mode: 'index', intersect: false }
        },
        scales: {
          y: { beginAtZero: true, title: { display: true, text: '점수' } }
        }
      }
    });
  };

  const load = async () => {
    try {
      const url = `${memberUrl}?group_id=${encodeURIComponent(groupId)}&yearMonth=${encodeURIComponent(yearMonth)}`;
      const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
      if (!res.ok) throw new Error('member data http error');
      const json = await res.json();

      const labels = json.labels || json.nicknames || (json.members?.map(m => m.nickname) ?? []);
      const data = json.data || (json.members?.map(m => m.score) ?? []);
      render(labels, data);
    } catch (e) {
      console.error('[MemberChart] load failed:', e);
      render([], []);
    }
  };

  load();
});
