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
							
              // 부트스트랩 모달의 날짜 input에 클릭한 날짜 세팅
              $("#selectedDate").val(info.dateStr); 
              $("#scheduleModal").modal("show");
							
							fetchTodoByDate(info.dateStr);
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
    $.ajax({
        url: contextPath + "/todos/by-date", 
        type: "GET",
        data: { date: date }, // 클릭한 날짜 (YYYY-MM-DD) 전달
        success: function(todos) {
            const todoList = $("#todoList");
            todoList.empty(); // 일단 기존에 있던 리스트 싹 비우기

            if (todos && todos.length > 0) {
                // 가져온 Todo 데이터가 있으면 하나씩 뿌려줌
                todos.forEach(todo => {
									const li = `
                    <li class="list-group-item d-flex justify-content-between align-items-center border-0 mb-2 shadow-sm" style="border-radius: 10px;">
                        <div>
                            <i class="fas fa-thumbtack text-primary me-2"></i>
                            <span style="font-weight: 500;">${todo.title}</span>
                        </div>
                        <span class="badge bg-light text-dark rounded-pill">${todo.assignedMemberNickname || '담당자'}</span>
                    </li>
                	`;
                    todoList.append(li);
                });
            } else {
                
                todoList.append('<li class="text-center text-muted py-3">이날은 예정된 할 일이 없어요!</li>');
            }

            // 숨겨져 있던 하단 영역(row mt-4)이 있다면 서서히 보여주기
            $(".row.mt-4").fadeIn();
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

// 일별 요약 데이터 로드 함수
function loadDailySummary(date) {
    const $scheduleList = $("#summaryScheduleList");
    const $todoList = $("#summaryTodoList");
    
    $scheduleList.empty();
    $todoList.empty();

    // 💡 여기서 이미 만들어둔 /schedule/events (혹은 유사한 API)를 사용해
    // 해당 날짜의 데이터를 필터링해서 화면에 그려줌
    $.ajax({
        url: contextPath + "/schedule/events-by-date", // 날짜별 조회 API (새로 필요할 수도!)
        type: "GET",
        data: { date: date },
        success: function(data) {
            data.forEach(item => {
                const icon = item.visibility === 'group' ? '👥' : '🔒';
                const badgeClass = item.visibility === 'group' ? 'bg-danger' : 'bg-primary';
                
                const html = `
                    <button type="button" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" onclick="showDetailFromSummary(${item.id})">
                        <div>${icon} ${item.title}</div>
                        <span class="badge ${badgeClass} rounded-pill">${item.visibility}</span>
                    </button>`;
                
                $scheduleList.append(html);
            });
        }
    });
}

// 요약 모달에서 [추가] 버튼 누를 때
function openRegisterModal() {
    $("#dailySummaryModal").modal("hide");
    $("#scheduleModal").modal("show");
}

// 요약 리스트에서 클릭 시 바로 상세 보기로 연결
function showDetailFromSummary(id) {
    $("#dailySummaryModal").modal("hide");
    // 우리가 이미 만들어둔 상세 보기 로직 호출 (eventClick에서 썼던 것과 유사하게)
    // 서버에서 단일 일정 정보 가져와서 eventDetailModal 띄우기
}