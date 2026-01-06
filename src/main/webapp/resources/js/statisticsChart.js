// Modern member chart (rounded bars + value labels)
document.addEventListener('DOMContentLoaded', function () {
  if (typeof Chart === 'undefined') return;

  var body = document.body || {};
  var ctxPath = (body.dataset && body.dataset.contextPath) ? body.dataset.contextPath : '';
  var gidEl = document.getElementById('groupId');
  var ymEl  = document.getElementById('yearMonth');
  var hook  = document.getElementById('chartHooks');
  var canvas = document.getElementById('memberChart');
  if (!gidEl || !ymEl || !canvas) return;

  var groupId = gidEl.value;
  var yearMonth = ymEl.value;
  var memberUrl = (hook && hook.dataset && hook.dataset.memberUrl)
    ? hook.dataset.memberUrl
    : (ctxPath + '/statistics/monthly-score');

  var ctx = canvas.getContext('2d');
  var chart;

  // 값 라벨 플러그인
  var valueLabelPlugin = {
    id: 'valueLabel',
    afterDatasetsDraw: function(c) {
      var ds = c.data.datasets[0];
      if (!ds) return;
      var meta = c.getDatasetMeta(0);
      var ctx2 = c.ctx;
      ctx2.save();
      ctx2.font = '12px Pretendard, sans-serif';
      ctx2.fillStyle = '#0b4a5a';
      ctx2.textAlign = 'center';
      for (var i = 0; i < meta.data.length; i++) {
        var bar = meta.data[i];
        var val = ds.data[i];
        if (val == null) continue;
        var p = bar.tooltipPosition();
        ctx2.fillText(String(val), p.x, p.y - 6);
      }
      ctx2.restore();
    }
  };

  function render(labels, data) {
    if (chart) chart.destroy();

    chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: '멤버별 점수',
          data: data,
          backgroundColor: 'rgba(90,200,250,0.45)',
          borderColor: 'rgba(90,200,250,1)',
          borderWidth: 1,
          borderRadius: 10,
          maxBarThickness: 48,
          categoryPercentage: 0.7,
          barPercentage: 0.9
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        animation: { duration: 700, easing: 'easeOutQuart' },
        plugins: {
          legend: { display: false },
          tooltip: { callbacks: { label: function(item){ return ' ' + item.parsed.y + '점'; } } }
        },
        scales: {
          x: { grid: { display: false }, ticks: { maxRotation: 45, minRotation: 0, autoSkip: true, color: '#4b5563' } },
          y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.06)', drawBorder: false }, ticks: { stepSize: 5, color: '#4b5563' } }
        },
        layout: { padding: { left: 6, right: 12, top: 4, bottom: 6 } }
      },
      plugins: [valueLabelPlugin]
    });
  }

  function fetchJson(url) {
    return fetch(url, { headers: { 'Accept': 'application/json' }, credentials: 'same-origin' })
      .then(function (res) {
        if (!res.ok) return res.text().then(function(t){ throw new Error('HTTP '+res.status+' '+t); });
        return res.json();
      });
  }

  (function load(){
    var url = memberUrl + '?groupId=' + encodeURIComponent(groupId) + '&yearMonth=' + encodeURIComponent(yearMonth);
    fetchJson(url).then(function(json){
      var labels, data;
      if (Object.prototype.toString.call(json) === '[object Array]') {
        labels = [];
        data = [];
        for (var i = 0; i < json.length; i++) {
          labels.push(json[i].nickname);
          data.push(json[i].score);
        }
      } else {
        var members = (json && Object.prototype.toString.call(json.members) === '[object Array]') ? json.members : [];
        labels = json && json.labels ? json.labels
              : (json && json.nicknames ? json.nicknames
              : members.map(function(m){ return m.nickname; }));
        data   = json && json.data ? json.data
              : members.map(function(m){ return m.score; });
      }
      render(labels, data);
    }).catch(function(e){
      console.error('[MemberChart] load failed:', e);
      render([], []);
    });
  })();
});
