document.addEventListener("DOMContentLoaded", function () {
    const contextPath = document.body.getAttribute("data-context-path");
    const groupId = document.getElementById("groupId").value;
    const yearMonth = document.getElementById("yearMonth").value;

    // 🔥 콘텍스트/파라미터 확인 로그
    console.log("📌 contextPath:", contextPath);
    console.log("📌 groupId:", groupId);
    console.log("📌 yearMonth:", yearMonth);

    // ✅ 멤버별 점수 fetch
    fetch(`${contextPath}/statistics/monthly-score?groupId=${groupId}&yearMonth=${yearMonth}`)
        .then(response => response.json())
        .then(data => {
            console.log("🔥 가져온 데이터:", data);

            const labels = data.map(item => item.nickname);
            const scores = data.map(item => item.score);

            console.log("📊 labels:", labels);
            console.log("📊 scores:", scores);

            const ctx = document.getElementById("scoreChart").getContext("2d");

            console.log("✅ Chart 생성 시작");

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                        label: '총 점수',
                        data: scores,
                        backgroundColor: 'rgba(54, 162, 235, 0.6)',
                        borderColor: 'rgba(54, 162, 235, 1)',
                        borderWidth: 1,
                        barThickness: 50,
                        categoryPercentage: 0.8,
                        barPercentage: 0.9
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

            console.log("✅ Chart 생성 완료");
        })
        .catch(error => {
            console.error("❌ 차트 데이터를 불러오지 못했습니다:", error);
        });

    // ✅ 그룹 총점 fetch (멤버 차트 완성 후 이어붙이기)
    fetch(`${contextPath}/statistics/group-monthly-total?groupId=${groupId}&yearMonth=${yearMonth}`)
        .then(response => response.json())
        .then(data => {
            console.log("🔥 그룹 총점 데이터:", data);

            const ctx = document.getElementById("groupTotalChart").getContext("2d");

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: [data.groupName || `그룹 ${data.groupId}`],
                    datasets: [{
                        label: '우리 그룹 총점',
                        data: [data.totalScore],
                        backgroundColor: 'rgba(255, 159, 64, 0.6)',
                        borderColor: 'rgba(255, 159, 64, 1)',
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            suggestedMax: 100,
                            ticks: {
                                stepSize: 10
                            }
                        }
                    }
                }
            });
        })
        .catch(error => {
            console.error("❌ 그룹 총점 차트 로딩 실패:", error);
        });
});
