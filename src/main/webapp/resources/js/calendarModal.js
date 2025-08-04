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
					document.querySelector('#schedule-date').value = clickedDate;

				  // 모달 내부에 날짜 표시할 .modal-date 요소가 있다면 여기에 날짜 삽입
				  const dateSpan = document.querySelector('#calendarModal .modal-date');
				  if (dateSpan) {
				    dateSpan.textContent = clickedDate;
				  }

				  // ✅ Ajax로 할 일 조회
				  $.ajax({
				    url: '/calendar/todo-list',
				    method: 'GET',
				    data: { date: clickedDate },
				    success: function (todos) {
				      console.log("✅ 불러온 할 일 목록:", todos);

				      const list = document.getElementById("todoList");
				      list.innerHTML = ""; // 초기화

				      if (!todos || todos.length === 0) {
				        list.innerHTML = "<li>📭 등록된 할 일이 없어요!</li>";
				        return;
				      }

				      todos.forEach(todo => {
				        const li = document.createElement("li");
				        li.innerHTML = `
				          <a href="${contextPath}/todos/myTodos?date=${clickedDate}">
				            🧹 ${todo.title} (${todo.nickname})
				          </a>
				        `;
				        list.appendChild(li);
				      });
				    },
				    error: function () {
				      alert("❌ 할 일 조회 실패!");
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
	
	$('#scheduleForm').on('submit', function(e) {
	  e.preventDefault(); // 기본 제출 막기

	  const formData = $(this).serialize(); // 폼 데이터

	  $.ajax({
	    url: contextPath + '/schedule/create',
	    method: 'POST',
	    data: formData,
	    success: function() {
	      alert("일정 등록 완료!");
	      $('#scheduleForm')[0].reset();
	    },
	    error: function() {
	      alert("등록 실패 ㅠㅠ");
	    }
	  });
	});

  window.confirmLogout = function () {
    if (confirm("정말 로그아웃 하시겠습니까?")) {
      window.location.href = contextPath + '/member/logout';
    }
  };
});
