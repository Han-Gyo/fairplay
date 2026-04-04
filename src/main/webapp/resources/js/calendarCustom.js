let calendar;

// 1. 달력 모달 열기
function openCalendarModal() {
  const modalDiv = document.getElementById('calendarModal');
  modalDiv.style.display = 'block';

  const calendarEl = document.getElementById('calendar-full');

  if (!calendar) {
    calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'dayGridMonth',
      locale: 'ko',
      height: '650',
      headerToolbar: {
        left: 'prev,next',
        center: 'title',
        right: 'today'
      },
      events: contextPath + '/schedule/events',
			
			eventDataTransform: function(eventData) {
			    return {
			      ...eventData,
			      id: eventData.id,
			      title: eventData.title,
			      start: eventData.scheduleDate,
			      extendedProps: {
			        memo: eventData.memo,
			        visibility: eventData.visibility,
			        groupId: eventData.groupId || eventData.groupid
			      }
			    };
			  },

      // 날짜 클릭 시 (일정 등록)
      dateClick: function(info) {
        const clickedDate = info.dateStr;
        $("#selectedDate").val(clickedDate);

        const allEvents = calendar.getEvents();
        const dayEvents = allEvents.filter(event => {
          const eventDate = event.startStr || event.start.toISOString().split('T')[0];
          return eventDate === clickedDate;
        });

        fetchTodoByDate(clickedDate).done(function(todos) {
          if (dayEvents.length > 0 || (todos && todos.length > 0)) {
            showDailySummary(clickedDate, dayEvents, todos);
          } else {
            $("#scheduleModal").modal("show");
          }
        }).fail(function() {
          $("#scheduleModal").modal("show");
        });
      },

      // 일정 클릭 시 (상세보기)
      eventClick: function(info) {
        const event = info.event;
        const scheduleId = event.id || (event.extendedProps && event.extendedProps.id);
        const visibility = event.extendedProps.visibility;
        const groupName = event.extendedProps.groupName;

        $("#detailId").val(scheduleId);
        $("#detailTitle").text(event.title);
        $("#detailMemo").text(event.extendedProps.memo || "등록된 메모가 없습니다.");
        $("#detailDate").text(event.startStr);

        const $badge = $("#detailGroupName");
        if (visibility === 'group') {
          $badge.text(groupName || '그룹 일정').css("background-color", "#f3969a").show();
        } else {
          $badge.text("private").css("background-color", "#78C2AD").show();
        }
        $("#eventDetailModal").modal("show");
      }
    });
    calendar.render();
  } else {
    calendar.updateSize();
    calendar.refetchEvents();
  }
}

// 2. 달력 모달 닫기
function closeModal() {
  document.getElementById('calendarModal').style.display = 'none';
}

// 3. 그룹 목록 로드 및 공개범위 처리 함수 (중복 제거 통합)
function handleVisibilityChange(visibility, selectedGroupId = null) {
  if (visibility === 'group') {
    $('#groupSelectSection').slideDown(200);
    fetchMyGroups(selectedGroupId);
  } else {
    $('#groupSelectSection').slideUp(200);
    $('#groupIdSelect').val('');
  }
}

function fetchMyGroups(selectedGroupId = null) {
  const $select = $('#groupIdSelect');
  $.ajax({
    url: contextPath + "/todos/api/myGroups",
    type: "GET",
    success: function(data) {
      $select.empty().append('<option value="">-- 그룹을 선택해주세요 --</option>');
      if (data && data.length > 0) {
        data.forEach(group => {
          const isSelected = (selectedGroupId && String(group.id) === String(selectedGroupId)) ? 'selected' : '';
          $select.append(`<option value="${group.id}" ${isSelected}>${group.name}</option>`);
        });
        if (selectedGroupId) $select.val(selectedGroupId);
      }
    }
  });
}

// 4. 이벤트 리스너 및 초기화 (Document Ready)
$(document).ready(function() {
  // 공개 범위 변경 감지
  $(document).on('change', '#visibilitySelect', function() {
    handleVisibilityChange($(this).val());
  });

  // 일정 등록/수정 폼 제출
  $("#scheduleForm").on("submit", function(e) {
    e.preventDefault();
    const editId = $("#editScheduleId").val();
    const isUpdate = editId !== "";
    const scheduleData = {
      title: $("input[name='title']").val(),
      memo: $("textarea[name='memo']").val(),
      scheduleDate: $("#selectedDate").val(),
      visibility: $("select[name='visibility']").val(),
      groupId: $("#groupIdSelect").val()
    };
    if (isUpdate) scheduleData.id = parseInt(editId);

    $.ajax({
      url: contextPath + (isUpdate ? "/schedule/update" : "/schedule/create"),
      type: "POST",
      contentType: "application/json",
      data: JSON.stringify(scheduleData),
      success: function(res) {
        alert(isUpdate ? "일정이 수정되었습니다." : "일정이 등록되었습니다.");
        $("#scheduleModal").modal("hide");
        if (calendar) calendar.refetchEvents();
      },
      error: function(err) {
        alert("로그인 후 이용해주세요.");
      }
    });
  });

  // 모달이 닫힐 때 리셋
  $('#scheduleModal').on('hidden.bs.modal', function() {
    $("#scheduleForm")[0].reset();
    $("#editScheduleId").val("");
    $("#scheduleModalLabel").text("새 일정 등록");
    $("#submitBtn").text("일정 등록하기");
    $("#groupSelectSection").hide();
    $("#groupIdSelect").empty().append('<option value="">-- 그룹을 선택해주세요 --</option>');
  });
});

// 5. 부가 기능 함수들
function fetchTodoByDate(date) {
  return $.ajax({
    url: contextPath + "/todos/by-date",
    type: "GET",
    data: { date: date },
    error: function() {
      $("#todoList").html('<li class="text-danger">에러 발생</li>');
    }
  });
}

function updateEvent() {
  const scheduleId = $("#detailId").val();
  const event = calendar.getEventById(scheduleId);

  if (event) {
    const visibility = event.extendedProps.visibility;
    const groupId = event.extendedProps.groupId;

    $("#editScheduleId").val(scheduleId);
    $("#selectedDate").val(event.startStr);
    $("input[name='title']").val(event.title);
    $("textarea[name='memo']").val(event.extendedProps.memo);

    // 공개범위 값 세팅 및 그룹 선택 섹션 처리
    $("#visibilitySelect").val(visibility);
    handleVisibilityChange(visibility, groupId);

    $("#eventDetailModal").modal("hide");
    $("#scheduleModal").modal("show");
    $("#scheduleModalLabel").text("일정 수정하기");
    $("#submitBtn").text("수정 완료");
  }
}

function deleteEvent() {
  const scheduleId = $("#detailId").val();
  if (!confirm("정말 삭제하시겠습니까?")) return;
  $.ajax({
    url: contextPath + "/schedule/delete",
    type: "POST",
    data: { id: scheduleId },
    success: function() {
      alert("삭제되었습니다.");
      $("#eventDetailModal").modal("hide");
      if (calendar) calendar.refetchEvents();
    }
  });
}

function showDailySummary(date, events, todos) {
  $("#summaryDateTitle").text(date + " 기록");
  const $sList = $("#summaryScheduleList").empty();
  const $tList = $("#summaryTodoList").empty();

  events.forEach(ev => {
    const visibility = ev.extendedProps.visibility;
    const gName = ev.extendedProps.groupName || '알 수 없는 그룹';
    const badgeText = (visibility === 'group') ? gName : 'private';
    const badgeStyle = (visibility === 'group') ? 'background-color: #f3969a;' : 'background-color: #78C2AD;';

    const item = `
      <button type="button" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center mb-2 shadow-sm border-0" 
              onclick="showDetailFromSummary('${ev.id}')" style="border-radius: 10px;">
        <span>${ev.title}</span>
        <span class="badge rounded-pill" style="${badgeStyle} color: white;">${badgeText}</span>
      </button>`;
    $sList.append(item);
  });

  if (todos && todos.length > 0) {
    todos.forEach(t => {
      const item = `<div class="list-group-item d-flex justify-content-between align-items-center mb-2 border-0 shadow-sm" style="border-radius: 10px;">
          <span>${t.title}</span>
          <span class="badge bg-light text-dark rounded-pill">${t.nickname || '미지정'}</span>
        </div>`;
      $tList.append(item);
    });
  }

  $("#calendarModal").css("z-index", "100");
  new bootstrap.Modal(document.getElementById('dailySummaryModal')).show();
  setTimeout(() => {
    $(".modal-backdrop").css("z-index", "5000");
    $("#dailySummaryModal").css("z-index", "5001");
  }, 50);
}

function openRegisterModalFromSummary() {
  $("#dailySummaryModal").modal("hide");
  $("#scheduleModal").modal("show");
}

function showDetailFromSummary(id) {
  $("#dailySummaryModal").modal("hide");
  const event = calendar.getEventById(id);
  if (event) {
    $("#detailId").val(id);
    $("#detailTitle").text(event.title);
    $("#detailMemo").text(event.extendedProps.memo || "메모 없음");
    $("#detailDate").text(event.startStr);

    const visibility = event.extendedProps.visibility;
    const groupName = event.extendedProps.groupName;
    const $badge = $("#detailGroupName");

    if (visibility === 'group') {
      $badge.text(groupName || '그룹 일정').css("background-color", "#f3969a").show();
    } else {
      $badge.text("private").css("background-color", "#78C2AD").show();
    }
    $("#eventDetailModal").modal("show");
  }
}