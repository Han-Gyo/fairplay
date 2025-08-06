// 📁 resources/js/statisticsGroupChart.js

document.addEventListener("DOMContentLoaded", function () {
    const groupId = document.getElementById("groupId").value;
    const yearMonth = document.getElementById("yearMonth").value;

    // 예: /api/statistics/group-total?groupId=1&yearMonth=2025-08
    fetch(`/fairplay/statistics/group-monthly-total?groupId=${groupId}&yearMonth=${yearMonth}`)
        .then(res => res.json())
        .then(data => {
            const ctx = document.getElementById("groupChart").getContext("2d");

            new Chart(ctx, {
                type: "bar",
                data: {
                    labels: [data.groupName],
                    datasets: [{
                        label: "총 점수",
                        data: [data.totalScore],
                        backgroundColor: "rgba(75, 192, 192, 0.4)",
                        borderColor: "rgba(75, 192, 192, 1)",
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            precision: 0
                        }
                    }
                }
            });
        });
});
