document.addEventListener('DOMContentLoaded', function () {
  let fullCal = null;

  window.openCalendarModal = function () {
    document.getElementById('calendarModal').style.display = 'block';

    if (!fullCal) {
      fullCal = new FullCalendar.Calendar(document.getElementById('calendar-full'), {
        locale: 'ko',
        titleFormat: { year: 'numeric', month: 'long' },
        initialView: 'dayGridMonth',
        height: 600,
        selectable: true,
        editable: true,
        headerToolbar: {
          left: 'prev,next',
          center: 'title',
          right: 'today'
        },
				dateClick: function (info) {
				  const clickedDate = info.dateStr;

				  // Bootstrap 모달에 있는 hidden input에 날짜 전달
				  document.getElementById('selectedDate').value = clickedDate;

				  // 모달 열기
				  const scheduleModal = new bootstrap.Modal(document.getElementById('scheduleModal'));
				  scheduleModal.show();

				  // 할 일 조회 (그대로 유지)
				  const dateSpan = document.querySelector('#calendarModal .modal-date');
				  if (dateSpan) {
				    dateSpan.textContent = clickedDate;
				  }

					$.ajax({
						url: contextPath + "/todos/calendar/todo-list",
						method: "GET",
						data: { date: clickedDate },
						success: function (todos) {
							console.log("할 일 조회 응답:", todos);
							const list = document.getElementById("todoList");
							list.innerHTML = "";

							if (!todos || todos.length === 0) {
								list.innerHTML = "<li>할 일이 없어요!</li>";
								return;
							}

							todos.forEach(todo => {
								const li = document.createElement("li");
								li.innerHTML = `📌 ${todo.title}`;
								list.appendChild(li);
							});
						},
						error: function () {
							alert("할 일 조회 실패!");
						}
					});

					
					// 일정(schedule) 불러오기
					$.ajax({
					  url: '/schedule/by-date',
					  method: 'GET',
					  data: { date: clickedDate },
					  success: function (scheduleList) {
							console.log("일정 응답:", scheduleList);
					    let html = '';

					    if (!scheduleList || scheduleList.length === 0) {
					      html = "<div>등록된 일정이 없어요!</div>";
					    } else {
					      scheduleList.forEach(sch => {
					        html += `
					          <div class="schedule-item">
					            <strong>${sch.title}</strong><br>
					            메모: ${sch.memo ?? '없음'}<br>
					            공개범위: ${sch.scope ?? '없음'}
					          </div><hr>
					        `;
					      });
					    }

					    $('#schedule-container').html(html);
					  }
					});


				}

      });

      fullCal.render();
    }
  };

  window.closeModal = function () {
    document.getElementById('calendarModal').style.display = 'none';
  };

  window.openModal = function (dateStr) {
    openCalendarModal();
    if (fullCal) {
      fullCal.gotoDate(dateStr);
    }
  };

  window.confirmLogout = function () {
    if (confirm("정말 로그아웃 하시겠습니까?")) {
      window.location.href = contextPath + '/member/logout';
    }
  };
});

// 일정 등록 처리
$(document).on("submit", "#scheduleForm", function (e) {
  e.preventDefault();

  const data = {
    title: $("input[name='title']").val(),
    startDate: $("#selectedDate").val() + "T00:00:00",
    endDate: $("#selectedDate").val() + "T23:59:59",
    visibility: $("select[name='visibility']").val(),
    memo: $("textarea[name='memo']").val(),
    groupId: 1 
  };

  $.ajax({
    type: "POST",
    url: contextPath + "/schedule/create",
    contentType: "application/json",
    data: JSON.stringify(data),
    success: function (res) {
      if (res === "success") {
        alert("일정이 등록되었습니다!");
        const modalInstance = bootstrap.Modal.getInstance(document.getElementById('scheduleModal'));
        modalInstance.hide(); // 모달 닫기
        location.reload();
      } else {
        alert("등록 실패: " + res);
      }
    },
    error: function () {
      alert("서버 오류!");
    }
  });
});
