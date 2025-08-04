document.addEventListener("DOMContentLoaded", function () {
	const contextPath = document.body.getAttribute("data-context-path");
    const groupId = document.getElementById("groupId").value;
    const yearMonth = document.getElementById("yearMonth").value;

    fetch(`${contextPath}/statistics/monthly-score?groupId=${groupId}&yearMonth=${yearMonth}`)
        .then(response => response.json())
        .then(data => {
            const labels = data.map(item => item.memberName);
            const scores = data.map(item => item.totalScore);

            const ctx = document.getElementById("scoreChart").getContext("2d");

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: '총 점수',
                        data: scores,
                        backgroundColor: 'rgba(54, 162, 235, 0.6)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1
                    }]
                },
				options: {
				    responsive: true,
				    plugins: {
				        legend: {
				            display: true,
				            position: 'top'
				        }
				    },
				    scales: {
				        y: {
				            beginAtZero: true,
				            suggestedMax: 10,
				            ticks: {
				                stepSize: 1,
				                precision: 0
				            }
				        }
				    }
				}

            });
        })
        .catch(error => {
            console.error("차트 데이터를 불러오지 못했습니다:", error);
        });
});
