/**
 * FairPlay 프로젝트 전용 캘린더 로직
 */
let calendar; 

// 1. 달력 모달 열기
function openCalendarModal() {
    const modalDiv = document.getElementById('calendarModal');
    modalDiv.style.display = 'block';

    const calendarEl = document.getElementById('calendar-full');
    
    // 달력이 아직 생성되지 않았다면 초기화
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
            
            // 날짜 클릭 시 (일정 등록)
						dateClick: function(info) {
						    const clickedDate = info.dateStr;
						    $("#selectedDate").val(clickedDate); // 등록용 날짜 미리 세팅

						    // 1. FullCalendar에 이미 로드된 일정들 필터링
						    const allEvents = calendar.getEvents();
						    const dayEvents = allEvents.filter(event => {
						        const eventDate = event.startStr || event.start.toISOString().split('T')[0];
						        return eventDate === clickedDate;
						    });

						    // 2. 서버에서 Todo 데이터 가져오기
						    fetchTodoByDate(clickedDate).done(function(todos) {
						        // [조건 체크] 일정(dayEvents)이 있거나, 할 일(todos)이 하나라도 있다면?
						        if (dayEvents.length > 0 || (todos && todos.length > 0)) {
						            // 상세 요약 모달 띄우기 (하단 div가 아니라 모달로!)
						            showDailySummary(clickedDate, dayEvents, todos);
						        } else {
						            // 아무것도 없으면 바로 일정 등록 모달 오픈
						            $("#scheduleModal").modal("show");
						        }
						    }).fail(function() {
						        // 통신 실패 시에도 등록은 가능하게 처리
						        $("#scheduleModal").modal("show");
						    });
						},
            
            // 일정 클릭 시 (상세보기)
            eventClick: function(info) {
              const event = info.event;
							const scheduleId = event.id || (event.extendedProps && event.extendedProps.id);
							console.log("클릭한 일정 ID 확인:", scheduleId);
							// 모달 각 요소에 데이터 집어넣기
							$("#detailId").val(scheduleId);
					    $("#detailTitle").text(event.title);
					    
					    // extendedProps에 들어있는 메모 가져오기 (없으면 기본값)
					    const memo = event.extendedProps.memo || "등록된 메모가 없습니다.";
					    $("#detailMemo").text(memo);
					    
					    // 날짜 예쁘게 포맷팅 (YYYY-MM-DD)
					    const dateStr = event.startStr;
					    $("#detailDate").text(dateStr);

					    // 2. 상세보기 모달 띄우기
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

// 3. 일정 등록 AJAX (JQuery 사용)
$(document).ready(function() {
    $("#scheduleForm").on("submit", function(e) {
        e.preventDefault(); // 폼 기본 제출 막기
        
        // 서버로 보낼 데이터 구성
        const scheduleData = {
            title: $("input[name='title']").val(),
            memo: $("textarea[name='memo']").val(),
            scheduleDate: $("#selectedDate").val(),
            visibility: $("select[name='visibility']").val()
        };

        $.ajax({
            url: contextPath + "/schedule/create",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(scheduleData),
            success: function(res) {
                alert("일정이 등록되었습니다!");
                $("#scheduleModal").modal("hide");
                $("#scheduleForm")[0].reset(); // 폼 초기화
                
                if(calendar) {
                    calendar.refetchEvents(); // 달력 데이터 갱신
                }
            },
            error: function(err) {
                console.error(err);
                alert("일정 등록에 실패했습니다. 다시 시도해주세요.");
            }
        });
    });
});

// 4. 날짜 클릭 시 해당 날짜의 Todo 가져오기
function fetchTodoByDate(date) {
    return $.ajax({
        url: contextPath + "/todos/by-date", 
        type: "GET",
        data: { date: date }, // 클릭한 날짜 (YYYY-MM-DD) 전달
        success: function(todos) {
        },
        error: function(err) {
            console.error("Todo 로드 실패:", err);
            $("#todoList").html('<li class="text-danger">할 일을 불러오는 중 에러가 발생했습니다.</li>');
						
        }
				
    });
		
}

function deleteEvent() {
    const scheduleId = $("#detailId").val();
		console.log("삭제할 ID:", scheduleId);
		
    if (!confirm("정말 이 일정을 삭제하시겠습니까?")) return;

    $.ajax({
        url: contextPath + "/schedule/delete", // 컨트롤러 주소
        type: "POST",
        data: { id: scheduleId },
        success: function(res) {
					console.log("서버 응답:", res);
          alert("일정이 삭제되었습니다!");
          $("#eventDetailModal").modal("hide"); // 상세창 닫기
            
	        if(calendar) {
	          calendar.refetchEvents(); // 캘린더에서 해당 일정 즉시 제거
          }
        },
				error: function(xhr, status, error) {
	        console.error("에러 내용:", error);
	        console.error("상태 코드:", xhr.status);
	        alert("삭제 실패! 서버 콘솔이나 브라우저 콘솔을 확인해주세요.");
	    	}
    });
}

// 요약 모달을 채우고 보여주는 함수
function showDailySummary(date, events, todos) {
    $("#summaryDateTitle").text(date + " 기록");
    const $sList = $("#summaryScheduleList").empty();
    const $tList = $("#summaryTodoList").empty();

    // 일정/할 일 리스트 채우는 코드는 그대로 (생략)
    if (events.length > 0) {
        events.forEach(ev => {
            const badgeClass = ev.extendedProps.visibility === 'group' ? 'bg-info' : 'bg-primary';
            const item = `<button type="button" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center mb-2 shadow-sm border-0" 
                        onclick="showDetailFromSummary('${ev.id}')" style="border-radius: 10px;">
                    <span>${ev.title}</span>
                    <span class="badge ${badgeClass} rounded-pill">${ev.extendedProps.visibility}</span>
                </button>`;
            $sList.append(item);
        });
    } else { $sList.append('<p class="text-muted small ps-2">등록된 일정이 없습니다.</p>'); }

    if (todos && todos.length > 0) {
        todos.forEach(t => {
            const item = `<div class="list-group-item d-flex justify-content-between align-items-center mb-2 border-0 shadow-sm" style="border-radius: 10px;">
                    <span>${t.title}</span>
                    <span class="badge bg-light text-dark rounded-pill">${t.assignedMemberNickname || '미지정'}</span>
                </div>`;
            $tList.append(item);
        });
    } else { $tList.append('<p class="text-muted small ps-2">예정된 할 일이 없습니다.</p>'); }

    // 1. 모달을 띄우기 전에 캘린더 모달의 z-index를 일시적으로 낮춤
    $("#calendarModal").css("z-index", "100"); 

    // 2. 모달 띄우기
    const myModal = new bootstrap.Modal(document.getElementById('dailySummaryModal'));
    myModal.show();

    // 3. 모달이 뜨고 나서 생성되는 배경막(backdrop)의 z-index를 강제로 5000으로!
    setTimeout(() => {
        $(".modal-backdrop").css("z-index", "5000");
        $("#dailySummaryModal").css("z-index", "5001");
    }, 50);
}

// 요약 모달에서 등록 버튼 누를 때
function openRegisterModalFromSummary() {
    $("#dailySummaryModal").modal("hide");
    $("#scheduleModal").appendTo("body").modal("show");
}

// 요약 리스트에서 일정 클릭 시 상세 모달로 연결
function showDetailFromSummary(id) {
    $("#dailySummaryModal").modal("hide");
    // 기존에 만들어둔 eventClick 로직을 활용하기 위해 해당 이벤트 객체 찾기
    const event = calendar.getEventById(id);
    if(event) {
        // 이미 구현하신 상세 모달 채우기 로직 실행
        $("#detailId").val(id);
        $("#detailTitle").text(event.title);
        $("#detailMemo").text(event.extendedProps.memo || "메모 없음");
        $("#detailDate").text(event.startStr);
        $("#eventDetailModal").modal("show");
    }
}