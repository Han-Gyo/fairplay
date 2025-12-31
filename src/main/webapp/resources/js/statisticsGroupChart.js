// statisticsGroupChart.js
// 데이터가 1개면 "막대", 여러 개면 "선+그라디언트"로 자동 스위칭

document.addEventListener('DOMContentLoaded', function () {
  if (typeof Chart === 'undefined') return;

  var body = document.body || {};
  var ctxPath = (body.dataset && body.dataset.contextPath) ? body.dataset.contextPath : '';
  var gidEl = document.getElementById('groupId');
  var ymEl  = document.getElementById('yearMonth');
  var hook  = document.getElementById('chartHooks');
  var canvas = document.getElementById('groupChart');
  if (!gidEl || !ymEl || !canvas) return;

  var groupId = gidEl.value;
  var yearMonth = ymEl.value;
  var groupUrl = (hook && hook.dataset && hook.dataset.groupUrl)
    ? hook.dataset.groupUrl
    : (ctxPath + '/statistics/group-monthly-total');

  var ctx = canvas.getContext('2d');
  var chart;

  // ===== 값 라벨 플러그인 (바/포인트 위에 값 표시)
  var valueLabelPlugin = {
    id: 'valueLabel',
    afterDatasetsDraw: function(c) {
      var ds = c.data.datasets[0];
      if (!ds) return;
      var meta = c.getDatasetMeta(0);
      var g = c.ctx;
      g.save();
      g.font = '12px Pretendard, sans-serif';
      g.fillStyle = '#0b4a5a';
      g.textAlign = 'center';
      for (var i = 0; i < meta.data.length; i++) {
        var el = meta.data[i];
        var val = ds.data[i];
        if (val == null) continue;
        var p = el.tooltipPosition();
        g.fillText(String(val), p.x, p.y - 6); // ← 멤버 차트와 동일하게 -6으로 조정
      }
      g.restore();
    }
  };

  // ===== 선 그래프용 배경 그라디언트
  function buildGradient(chart) {
    var area = chart.chartArea;
    var grad = ctx.createLinearGradient(0, area ? area.top : 0, 0, area ? area.bottom : 300);
    grad.addColorStop(0, 'rgba(90, 200, 250, 0.35)');
    grad.addColorStop(1, 'rgba(90, 200, 250, 0.00)');
    return grad;
  }

  // ===== 렌더 (자동 스위칭)
  function render(labels, data) {
    if (chart) chart.destroy();

    var isSingle = !labels || labels.length <= 1;

    if (isSingle) {
      // 데이터 1개 → 막대 차트
      chart = new Chart(ctx, {
        type: 'bar',
        data: {
          labels: labels,
          datasets: [{
            label: '그룹 점수',
            data: data,
            backgroundColor: 'rgba(90,200,250,0.45)',
            borderColor: 'rgba(90,200,250,1)',
            borderWidth: 1,
            borderRadius: 10,
            maxBarThickness: 70
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          animation: { duration: 700, easing: 'easeOutQuart' },
          plugins: { legend: { display: false } },
          scales: {
            x: { grid: { display: false }, ticks: { color: '#2b3e50' } },
            y: {
              beginAtZero: true,
              grid: { color: 'rgba(0,0,0,0.06)', drawBorder: false },
              ticks: { color: '#2b3e50' }
            }
          },
          layout: {
            padding: { left: 6, right: 12, top: 20, bottom: 6 } // ← 멤버 차트와 유사하게 조정
          }
        },
        plugins: [valueLabelPlugin]
      });

    } else {
      // 데이터 여러 개 → 선 그래프 + 그라디언트
      chart = new Chart(ctx, {
        type: 'line',
        data: {
          labels: labels,
          datasets: [{
            label: '그룹 월간 점수',
            data: data,
            borderWidth: 2,
            borderColor: '#39b7e5',
            pointBackgroundColor: '#5ac8fa',
            pointRadius: 3,
            tension: 0.3,
            fill: true,
            backgroundColor: function(arg){ return buildGradient(arg.chart); }
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          animation: { duration: 700, easing: 'easeOutQuart' },
          plugins: { legend: { display: false } },
          scales: {
            x: { grid: { display: false }, ticks: { maxRotation: 0, color: '#2b3e50' } },
            y: {
              beginAtZero: true,
              grid: { color: 'rgba(0,0,0,0.06)', drawBorder: false },
              ticks: { stepSize: 5, color: '#2b3e50' }
            }
          },
          layout: {
            padding: { left: 6, right: 12, top: 20, bottom: 6 } // ← 동일하게 조정
          },
          elements: { point: { hoverRadius: 4 } }
        },
        plugins: [valueLabelPlugin]
      });
    }
  }

  // ===== 데이터 로딩
  function fetchJson(url) {
    return fetch(url, { headers: { 'Accept': 'application/json' }, credentials: 'same-origin' })
      .then(function (res) {
        if (!res.ok) return res.text().then(function(t){ throw new Error('HTTP '+res.status+' '+t); });
        return res.json();
      });
  }

  (function load(){
    var url = groupUrl + '?groupId=' + encodeURIComponent(groupId) + '&yearMonth=' + encodeURIComponent(yearMonth);
    fetchJson(url).then(function(json){
      var labels = [], data = [];
      if (json && json.labels) {
        labels = json.labels;
        data = json.data || [];
      } else if (json && typeof json.totalScore !== 'undefined') {
        labels = [yearMonth];
        data = [json.totalScore];
      } else if (Object.prototype.toString.call(json) === '[object Array]') {
        for (var i = 0; i < json.length; i++) {
          labels.push(json[i].day || '');
          data.push(json[i].total || 0);
        }
      }
      render(labels, data);
    }).catch(function(e){
      console.error('[GroupChart] load failed:', e);
      render([], []);
    });
  })();
});